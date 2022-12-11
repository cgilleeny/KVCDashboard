import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_check_kidz_dashboard/widgets/detection_left_eye_view.dart';
import 'package:go_check_kidz_dashboard/widgets/detection_right_eye_view.dart';
import 'package:go_check_kidz_dashboard/widgets/full_image_button.dart';
import 'package:go_check_kidz_dashboard/widgets/id_popover_button.dart';
import 'package:go_check_kidz_dashboard/widgets/symmetry_view.dart';
import 'package:intl/intl.dart';

import '../cubit/eyepair_cubit.dart';
import '../cubit/image_cubit.dart';
import '../data/eyepair/eyepair_repository_instance.dart';
import '../data/eyepair_image/eyepair_image_repository_instance.dart';
import '../data/model/classification.dart';
import '../data/model/eyepair.dart';

class EyepairView extends StatefulWidget {
  final EyePair eyepair;

  // ignore: use_key_in_widget_constructors
  const EyepairView(this.eyepair, {Key? key}) : super(key: key);

  @override
  State<EyepairView> createState() => _EyepairViewState();
}

class _EyepairViewState extends State<EyepairView> {
  late EyePair eyepair;
  late String dateString;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    eyepair = widget.eyepair;
    dateString = eyepair.timestamp != null
        ? DateFormat("MM-dd-yyyy h:mm a").format(eyepair.timestamp!)
        : 'unknown';
  }

  @override
  void didUpdateWidget(covariant EyepairView oldWidget) {
    // TODO: implement didUpdateWidget

    setState(() {
      eyepair = widget.eyepair;
      dateString = eyepair.timestamp != null
          ? DateFormat("MM-dd-yyyy h:mm a").format(eyepair.timestamp!)
          : 'unknown';
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    assert(debugCheckHasMaterial(context));

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        elevation: 20,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        color: const Color.fromARGB(255, 210, 214, 210),
        child: ClipPath(
          clipper: ShapeBorderClipper(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0))),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    PopoverButton(eyepair),
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
                    FullImageButton(eyepair),
                    BlocProvider(
                      create: (context) =>
                          EyepairCubit(EyepairRepositoryInstance.repository),
                      child: SymmetryView(
                        eyepair,
                        (Classification classification) {
                          if (eyepair.symmetryHumanLabel != classification) {
                            Map<String, dynamic> map = {
                              "symmetry_human_label":
                                  fromClassification(classification)
                            };
                            BlocProvider.of<EyepairCubit>(context)
                                .updateEyepair(widget.eyepair.rowKey, map);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (eyepair.left != null)
                    MultiBlocProvider(
                      providers: [
                        BlocProvider(
                          create: (context) => ImageCubit(
                              ImageEyepairRepositoryInstance.repository),
                        ),
                        BlocProvider(
                          create: (context) => EyepairCubit(
                              EyepairRepositoryInstance.repository),
                        ),
                      ],
                      child: Expanded(
                        child: DetectionLeftEyeView(
                          eyepair.rowKey,
                          eyepair.left!,
                        ),
                      ),
                    ),
                  if (eyepair.right != null)
                    MultiBlocProvider(
                      providers: [
                        BlocProvider(
                          create: (context) => ImageCubit(
                              ImageEyepairRepositoryInstance.repository),
                        ),
                        BlocProvider(
                          create: (context) => EyepairCubit(
                              EyepairRepositoryInstance.repository),
                        ),
                      ],
                      child: Expanded(
                        child: DetectionRightEyeView(
                          eyepair.rowKey,
                          eyepair.right!,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}