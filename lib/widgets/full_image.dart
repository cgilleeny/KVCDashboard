import 'dart:isolate';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image/image.dart';
import 'package:transparent_image/transparent_image.dart';

import '../cubit/image_cubit.dart';
import '../data/eyepair_image/eyepair_image_repository_instance.dart';
import '../data/model/eyepair.dart';
import 'error_banner.dart';

class FullImage extends StatefulWidget {
  final EyePair eyepair;

  const FullImage(this.eyepair, {Key? key}) : super(key: key);

  @override
  State<FullImage> createState() => _FullImageState();
}

class _FullImageState extends State<FullImage> with TickerProviderStateMixin {
  MemoryImage? portrait;
  String? errorMessage;

  Widget _imageContainer(ImageState state) {
    return Column(
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ImageCubit(ImageEyepairRepositoryInstance.repository)
        ..fetchPortrait(widget.eyepair.rowKey),
      child: BlocListener<ImageCubit, ImageState>(
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
              child: _imageContainer(state),
            );
          }),
        ),
      ),
    );
  }
}
