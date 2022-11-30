import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:go_check_kidz_dashboard/cubit/image_cubit.dart';
import 'package:go_check_kidz_dashboard/widgets/full_image.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_check_kidz_dashboard/data/model/classification.dart';
import 'package:popover/popover.dart';
import 'package:transparent_image/transparent_image.dart';
// import '../bloc/image/image_bloc.dart';
import '../UI/shared/basic_dialog.dart';
import '../cubit/eyepair_cubit.dart';
import '../data/eyepair_image/eyepair_image_repository_instance.dart';
import '../data/model/eye.dart';
import '../data/model/eyepair.dart';
import '../data/model/filter.dart';

import '../enums/dialog_type.dart';
import '../utils/custom_page_route.dart';
import '../widgets/error_banner.dart';
import 'filter_page.dart';

import '../widgets/popup_menu_button.dart';
import '../widgets/more_menu_button.dart';

class DashboardPage extends StatefulWidget {
  final String socialEmail;
  // final List<AzureUser> azureUsers;

  const DashboardPage(this.socialEmail, {Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int pageIndex = 0;
  Filter? filter;
  int rowsPerPage = 10;
  final _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return MultiBlocListener(
      listeners: [
        BlocListener<EyepairCubit, EyepairState>(
          listener: (context, state) {
            if (state is EyepairsLoaded) {
              setState(() {
                pageIndex = state.page.pageIndex;
              });
            }
          },
        ),
      ],
      child: BlocBuilder<EyepairCubit, EyepairState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              actions: [
                IconButton(
                  icon: const Icon(Icons.filter_list),
                  color: theme.appBarTheme.actionsIconTheme != null
                      ? theme.appBarTheme.actionsIconTheme!.color
                      : theme.primaryIconTheme.color,
                  onPressed: () async {
                    final newFilter = await Navigator.of(context).push(
                        CustomPageRoute(child: FilterPage(filter ?? Filter())));
                    if (!mounted || newFilter == null || newFilter == filter) {
                      return;
                    }
                    setState(() {
                      filter = newFilter;
                    });
                    BlocProvider.of<EyepairCubit>(context)
                        .fetchFirstPage(filter: newFilter);
                  },
                ),
                MoreMenuButton(),
              ],
              title: const Text('KVC Dashboard'),
            ),
            body: Stack(
              children: [
                // pages.length > pageIndex
                //     ?
                Column(
                  children: [
                    if (state is EyepairsError)
                      ErrorBanner(state.errorDescription),
                    // ? ErrorBanner(state.errorDescription)
                    // : null,
                    Expanded(
                      child: NotificationListener<ScrollUpdateNotification>(
                        onNotification: (scrollNotification) {
                          print('_controller.offset: ${_controller.offset}');
                          return false;
                        },
                        child: EyepairListView(
                            state is EyepairsLoaded ? state.page.eyepairs : [],
                            _controller),
                      ),
                    ),
                    // ].whereType<Widget>().toList(),
                  ],
                ),
                // : null,
                if (state is EyepairsLoading)
                  const Center(
                    child: CircularProgressIndicator(),
                  ),
                // ? const Center(
                //     child: CircularProgressIndicator(),
                //   )
                // : null,
              ],
            ),
            floatingActionButton: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: FloatingActionButton(
                    backgroundColor: pageIndex > 0
                        ? Theme.of(context).primaryColor
                        : Colors.grey,
                    onPressed: pageIndex > 0
                        ? () {
                            BlocProvider.of<EyepairCubit>(context).fetchPage(
                              pageIndex - 1,
                            );
                            // _onNewPage(pageIndex - 1);
                          }
                        : null,
                    heroTag: null,
                    child: const Icon(Icons.arrow_back),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: FloatingActionButton(
                    backgroundColor:
                        state is EyepairsLoaded && state.page.hasNextPage
                            ? Theme.of(context).primaryColor
                            : Colors.grey,
                    onPressed: state is EyepairsLoaded && state.page.hasNextPage
                        ? () {
                            BlocProvider.of<EyepairCubit>(context)
                                .fetchPage(pageIndex + 1);

                            // _onNewPage(pageIndex + 1);
                          }
                        : null,
                    heroTag: null,
                    child: const Icon(Icons.arrow_forward),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class EyepairListView extends StatefulWidget {
  final List<EyePair> eyepairs;
  final ScrollController controller;
  // ignore: use_key_in_widget_constructors
  EyepairListView(
    this.eyepairs,
    this.controller,
  );

  @override
  State<EyepairListView> createState() => _EyepairListViewState();
}

class _EyepairListViewState extends State<EyepairListView> {
  int eyeLoadIndex = 0;
  List<EyePair> eyepairs = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    eyepairs = widget.eyepairs;
  }

  @override
  void didUpdateWidget(covariant EyepairListView oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    setState(() {
      // eyeLoadIndex = 0;
      eyepairs = widget.eyepairs;
      // if (eyepairs.isNotEmpty) {
      //   BlocProvider.of<ImageCubit>(context).fetchEyepairImage(
      //     widget.eyepairs[eyeLoadIndex],
      //   );
      // }
      // if (eyepairs.isNotEmpty) {
      //   BlocProvider.of<ImageCubit>(context).fetchEyepairImages(
      //     eyepairs,
      //   );
      // }
    });
  }

  @override
  Widget build(BuildContext context) {
    return
        // BlocListener<ImageCubit, ImageState>(
        //   listener: ((context, state) {
        //     if (state is ImagesLoaded) {
        //       setState(() {
        //         eyeLoadIndex++;
        //       });
        //       if (kDebugMode) {
        //         print('eyeLoadIndex: $eyeLoadIndex');
        //       }
        //       if (eyepairs.length > eyeLoadIndex) {
        //         BlocProvider.of<ImageCubit>(context).fetchEyepairImage(
        //           eyepairs[eyeLoadIndex],
        //         );
        //       }
        //     }
        //   }),
        //   child:
        BlocBuilder<ImageCubit, ImageState>(
      builder: (context, state) {
        return ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          itemBuilder: (_, i) => EyepairView(eyepairs[i]),
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: eyepairs.length,
          controller: widget.controller,
        );
      },
    );
    // );
  }
}

class EyepairView extends StatefulWidget {
  final EyePair eyepair;

  // ignore: use_key_in_widget_constructors
  const EyepairView(this.eyepair);

  @override
  State<EyepairView> createState() => _EyepairViewState();
}

class _EyepairViewState extends State<EyepairView> {
  void _displayFullImage(EyePair eyepair) {
    showAnimatedDialog(
      context: context,
      builder: (BuildContext context) {
        return BasicDialog(BasicDialogType.portrait, FullImage(eyepair),
            buttonsDef: [
              DialogButton(
                'Done',
                true,
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
            ]);
      },
      animationType: DialogTransitionType.fade,
      curve: Curves.fastOutSlowIn,
      duration: const Duration(milliseconds: 5000),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateString = widget.eyepair.timestamp != null
        ? DateFormat("MM-dd-yyyy h:mm a").format(widget.eyepair.timestamp!)
        : 'unknown';
    assert(debugCheckHasMaterial(context));

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        color: Color.fromARGB(255, 210, 214, 210),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  PopoverButton(widget.eyepair),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(dateString),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  FullImageButton(widget.eyepair),
                  SymmetryView(widget.eyepair, (Classification classification) {
                    if (widget.eyepair.symmetryHumanLabel != classification) {
                      Map<String, dynamic> map = {
                        "symmetry_human_label":
                            fromClassification(classification)
                      };
                      // BlocProvider.of<EyepairsBloc>(context).add(
                      //   UpdateEyepair(
                      //     widget.eyepair.rowKey!,
                      //     map,
                      //   ),
                      // );
                    }
                  }),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                widget.eyepair.left != null
                    ? BlocProvider(
      create: (context) =>
          ImageCubit(ImageEyepairRepositoryInstance.repository),
      child:                     Expanded(
                        child: DetectionLeftEyeView(
                            widget.eyepair.rowKey, widget.eyepair.left!,
                            (Classification classification) {
                          if (widget.eyepair.left?.humanLabel !=
                              classification) {
                            Map<String, dynamic> map = {
                              "left_human_label":
                                  fromClassification(classification)
                            };
                          }
                        }),
                      ),
    )
                    

                    : null,
                widget.eyepair.right != null
                    ? Expanded(
                        child: DetectionRightEyeView(widget.eyepair.right!,
                            (Classification classification) {
                          if (widget.eyepair.right?.humanLabel !=
                                  classification &&
                              widget.eyepair.rowKey != null) {
                            Map<String, dynamic> map = {
                              "right_human_label":
                                  fromClassification(classification)
                            };
                            // BlocProvider.of<EyepairsBloc>(context).add(
                            //   UpdateEyepair(
                            //     widget.eyepair.rowKey!,
                            //     map,
                            //   ),
                            // );
                          }
                        }),
                      )
                    : null,
              ].whereType<Widget>().toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class SymmetryView extends StatelessWidget {
  final EyePair eyepair;
  final void Function(Classification classification) onUpdateHumanLabel;

  const SymmetryView(this.eyepair, this.onUpdateHumanLabel, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'Symmetry',
            textAlign: TextAlign.center,
          ),
        ),
        CustomPopupMenuButton(
          classification: eyepair.symmetryHumanLabel,
          iconData: Icons.person,
          onSelected: (choice) => onUpdateHumanLabel(choice.classification),
        ),
        ButtonView(
          icon: const Icon(Icons.contrast),
          choice: settingChoices[eyepair.statusSymmetry.index],
        ),
      ],
    );
  }
}

class FullImageButton extends StatefulWidget {
  final EyePair eyepair;

  const FullImageButton(
    this.eyepair, {
    Key? key,
  }) : super(key: key);

  @override
  State<FullImageButton> createState() => _FullImageButtonState();
}

class _FullImageButtonState extends State<FullImageButton> {
  void _displayFullImage(EyePair eyepair) {
    showAnimatedDialog(
      context: context,
      builder: (BuildContext context) {
        return BasicDialog(BasicDialogType.portrait, FullImage(eyepair),
            buttonsDef: [
              DialogButton(
                'Done',
                true,
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
            ]);
      },
      animationType: DialogTransitionType.fade,
      curve: Curves.fastOutSlowIn,
      duration: const Duration(milliseconds: 350),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: IconButton(
          onPressed: widget.eyepair.rowKey != 'Unknown RowKey'
              ? () async {
                  BlocProvider.of<ImageCubit>(context)
                      .fetchImage(widget.eyepair.rowKey, '_full.jpg');
                  _displayFullImage(widget.eyepair);
                }
              : null,
          iconSize: 45.0,
          icon: const Icon(Icons.portrait)),
    );
  }
}

class DetectionLeftEyeView extends StatefulWidget {
  final String rowKey;
  final Eye eye;
  final void Function(Classification classification) onUpdateHumanLabel;

  const DetectionLeftEyeView(
    this.rowKey,
    this.eye,
    this.onUpdateHumanLabel,
  );

  @override
  State<DetectionLeftEyeView> createState() => _DetectionLeftEyeViewState();
}

class _DetectionLeftEyeViewState extends State<DetectionLeftEyeView> {
  MemoryImage? detectionImage;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    detectionImage = widget.eye.detectionImage;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (detectionImage == null) {
        BlocProvider.of<ImageCubit>(context).fetchLeftEye(
          widget.rowKey
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ImageCubit, ImageState>(
        listener: (listenerContext, state) {
          if (state is LeftImageLoaded) {
            if (state.memoryImage != null) {
            setState(() {
              detectionImage = state.memoryImage;
            });
            }
          }
        },
        child:
    BlocBuilder<ImageCubit, ImageState>(builder: (context, state) {

      return Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Left Single Detection',
              textAlign: TextAlign.center,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              detectionImage != null
                  ? SizedBox(
                      // color: Colors.blue,
                      width: double.infinity,
                      height: 85,
                      child: FittedBox(
                        fit: BoxFit.fill,
                        clipBehavior: Clip.hardEdge,
                        child: FadeInImage(
                            placeholder: MemoryImage(kTransparentImage),
                            image: detectionImage!),
                      ),
                    )
                  : const SizedBox(
                      // width: 240,
                      height: 85,
                      child: Icon(
                        Icons.visibility,
                        size: 50,
                      ),
                    ),
              ClassificationView(widget.eye, widget.onUpdateHumanLabel),
            ].whereType<Widget>().toList(),
          ),
        ],
      );
    }),
    );
  }
}

class DetectionRightEyeView extends StatelessWidget {
  final Eye eye;
  final void Function(Classification classification) onUpdateHumanLabel;

  const DetectionRightEyeView(
    this.eye,
    this.onUpdateHumanLabel,
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'Right Single Detection',
            textAlign: TextAlign.center,
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            eye.detectionImage != null
                // ? Image.memory(eye.detectionImageBytes!)
                ? SizedBox(
                    width: double.infinity,
                    height: 85,
                    child: FittedBox(
                      fit: BoxFit.fill,
                      clipBehavior: Clip.hardEdge,
                      child: FadeInImage(
                          placeholder: MemoryImage(kTransparentImage),
                          image: eye.detectionImage!),
                    ),
                  )
                : const SizedBox(
                    height: 85,
                    child: Icon(
                      Icons.visibility,
                      size: 50,
                    ),
                  ),
            ClassificationView(eye, onUpdateHumanLabel),
          ].whereType<Widget>().toList(),
        ),
      ],
    );
  }
}

class ClassificationView extends StatelessWidget {
  final Eye eye;
  final void Function(Classification classification) onUpdateHumanLabel;

  const ClassificationView(
    this.eye,
    this.onUpdateHumanLabel,
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CustomPopupMenuButton(
            classification: eye.humanLabel,
            iconData: Icons.person,
            onSelected: (choice) {
              if (kDebugMode) {
                print(choice.name);
              }
              // widget.eye.humanLabel = choice.classification;
              onUpdateHumanLabel(choice.classification);
            }),
        ButtonView(
          icon: const Icon(Icons.settings),
          choice: settingChoices[eye.mlResult.index],
        ),
        Row(
          children: [
            Expanded(
              child: ButtonView(
                icon: const Icon(Icons.thumb_up),
                choice: Choice(
                  name: eye.mlConfidenceNormal != null
                      ? eye.mlConfidenceNormal!.toStringAsFixed(2)
                      : "?.???",
                  classification: Classification.ok,
                  color: settingChoices[0].color,
                ),
              ),
            ),
            Expanded(
              child: ButtonView(
                icon: const Icon(Icons.thumb_down),
                choice: Choice(
                  name: eye.mlConfidenceAbnormal != null
                      ? eye.mlConfidenceAbnormal!.toStringAsFixed(2)
                      : "?.???",
                  classification: Classification.refer,
                  color: settingChoices[1].color,
                ),
              ),
            ),
          ],
        ),
      ].whereType<Widget>().toList(),
    );
  }
}

class PopoverButton extends StatelessWidget {
  EyePair eyePair;

  PopoverButton(this.eyePair, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // String rowKey = eyePair.rowKey ?? 'unknown';

    return ActionChip(
      // visualDensity: VisualDensity(vertical: -4.0),
      labelPadding: const EdgeInsets.all(2.0),
      avatar: const CircleAvatar(
        backgroundColor: Colors.white70,
        child: Icon(Icons.question_mark_rounded),
      ),
      label: const Text(
        'ID',
        style: TextStyle(
          color: Colors.white,
          fontSize: 12.0,
        ),
      ),
      onPressed: () {
        showPopover(
          context: context,
          transitionDuration: const Duration(milliseconds: 150),
          bodyBuilder: (context) => Container(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child:
                  Text(eyePair.rowKey, style: const TextStyle(fontSize: 12.0)),
            ),
          ),
          direction: PopoverDirection.bottom,
          width: 325,
          height: 45,
          arrowHeight: 15,
          arrowWidth: 30,
        );
      },
      backgroundColor: Theme.of(context).primaryColor,
      elevation: 6.0,
      shadowColor: Colors.grey[60],
      padding: const EdgeInsets.all(8.0),
    );
  }
}
