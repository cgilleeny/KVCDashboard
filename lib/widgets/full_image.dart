import 'dart:isolate';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image/image.dart';
import 'package:transparent_image/transparent_image.dart';

import '../cubit/image_cubit.dart';
import '../data/model/eyepair.dart';
import 'error_banner.dart';

class FullImage extends StatefulWidget {
  final EyePair eyepair;

  FullImage(this.eyepair, {Key? key}) : super(key: key);

  @override
  State<FullImage> createState() => _FullImageState();
}

class _FullImageState extends State<FullImage> with TickerProviderStateMixin {
  // Uint8List? imageBytes;
  MemoryImage? portrait;
  String? errorMessage;
  // late AnimationController _controller;
  // late Animation<double> _animation;

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   // _controller =
  //   //     AnimationController(vsync: this, duration: const Duration(seconds: 15));
  //   //     _animation = CurvedAnimation(parent: _controller, curve: Curves.linearToEaseOut)
  // }

  // MemoryImage? _cropBottom(Uint8List imageBytes) {
  //   final image = decodeImage(imageBytes);
  //   if (image == null) {
  //     return null;
  //   }
  //   print(
  //       'image.width: ${image.width}, image.height: ${image.height}, w/.75 = ${image.width / 0.75}');
  //   if (image.height > (image.width / 0.75).round()) {
  //     final face =
  //         copyCrop(image, 0, 0, image.width, (image.width / 0.75).round());
  //     return MemoryImage(Uint8List.fromList(encodeJpg(face)));
  //   }
  //   return MemoryImage(imageBytes);
  // }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ImageCubit, ImageState>(
      listener: (context, state) {
        if (state is ImageLoaded) {
          if (state.memoryImage == null) {
            errorMessage = 'Portrait image not found.';
          }
          widget.eyepair.fullImage = state.memoryImage;
          portrait = state.memoryImage;
        }
        if (state is ImageLoadingError) {
          errorMessage = state.errorDescription;
        }
      },
      child: BlocBuilder<ImageCubit, ImageState>(
        builder: ((context, state) {
          if (state is ImageLoaded && portrait == null) {
            if (state.memoryImage == null) {
            errorMessage = 'Portrait image not found.';
            }
          widget.eyepair.fullImage = state.memoryImage;
          portrait = state.memoryImage;
          }

          return AnimatedSize(
            curve: Curves.linearToEaseOut,
            duration: const Duration(seconds: 1),
            child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (errorMessage != null)
                    ErrorBanner(
                      errorMessage,
                    ),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      if (portrait != null)
                        FadeInImage(
                            placeholder: MemoryImage(kTransparentImage),
                            image: portrait!),
                      AnimatedOpacity(
                        opacity: portrait == null ? 1.0 : 0.0,
                        duration: const Duration(seconds: 10),
                        child: const Icon(Icons.portrait, size: 250),
                      ),
                      if (state is ImageLoading)
                        const Center(child: CircularProgressIndicator()),
                    ],
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
