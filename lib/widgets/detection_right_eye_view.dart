import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transparent_image/transparent_image.dart';

import '../cubit/eyepair_cubit.dart';
import '../cubit/image_cubit.dart';
import '../data/model/classification.dart';
import '../data/model/eye.dart';
import 'classification_view.dart';

class DetectionRightEyeView extends StatefulWidget {
  final String rowKey;
  final Eye eye;
  // final void Function(Classification classification) onUpdateHumanLabel;

  const DetectionRightEyeView(
    this.rowKey,
    this.eye,
    // this.onUpdateHumanLabel,
  );

  @override
  State<DetectionRightEyeView> createState() => _DetectionRightEyeViewState();
}

class _DetectionRightEyeViewState extends State<DetectionRightEyeView> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.eye.detectionImage == null) {
        BlocProvider.of<ImageCubit>(context).fetchRightEye(widget.rowKey);
      }
    });
  }

  @override
  void didUpdateWidget(covariant DetectionRightEyeView oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    setState(() {
      if (widget.eye.detectionImage == null) {
        BlocProvider.of<ImageCubit>(context).fetchRightEye(widget.rowKey);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<ImageCubit, ImageState>(
          listener: (listenerContext, state) {
            if (state is ImageLoaded) {
              if (state.memoryImage != null) {
                setState(() {
                  widget.eye.detectionImage = state.memoryImage;
                });
              }
            }
          },
        ),
        BlocListener<EyepairCubit, EyepairState>(
          listener: (listenerContext, state) {
            if (state is EyepairUpdated) {
              setState(() {
                widget.eye.humanLabel = toClassification(state.classification);
              });
            }
          },
        ),
      ],
      child: BlocBuilder<EyepairCubit, EyepairState>(builder: (context, state) {
        return Stack(alignment: Alignment.center, children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Right Single Detection',
                  textAlign: TextAlign.center,
                ),
              ),
              widget.eye.detectionImage != null
                  ? SizedBox(
                      width: double.infinity,
                      height: 85,
                      child: FittedBox(
                        fit: BoxFit.fill,
                        clipBehavior: Clip.hardEdge,
                        child: FadeInImage(
                            placeholder: MemoryImage(kTransparentImage),
                            image: widget.eye.detectionImage!),
                      ),
                    )
                  : const SizedBox(
                      height: 85,
                      child: Icon(
                        Icons.visibility,
                        size: 50,
                      ),
                    ),
              ClassificationView(
                widget.eye,
                (Classification classification) {
                  if (widget.eye.humanLabel != classification) {
                    Map<String, dynamic> map = {
                      "right_human_label": fromClassification(classification)
                    };
                    BlocProvider.of<EyepairCubit>(context)
                        .updateEyepair(widget.rowKey, map);
                  }
                },
              ),
            ],
          ),
          if (state is EyepairUpdating)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ]);
      }),
    );
  }
}