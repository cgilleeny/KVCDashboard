/*
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:go_check_kidz_dashboard/bloc/image/image_bloc.dart';
import '../widgets/error_banner.dart';
import '../data/model/eyepair.dart';

class ImageDialog extends StatefulWidget {
  final EyePair eyepair;

  // ignore: use_key_in_widget_constructors
  const ImageDialog(this.eyepair);

  @override
  State<ImageDialog> createState() => _ImageDialogState();
}

class _ImageDialogState extends State<ImageDialog> {
  Uint8List? imageBytes;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.eyepair.fullImageBytes == null) {
        BlocProvider.of<ImageBloc>(context).add(LoadFullImage(widget.eyepair));
      } else {
        setState(() {
          imageBytes = widget.eyepair.fullImageBytes;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(children: [
      BlocListener<ImageBloc, ImageState>(listenWhen: (context, state) {
        return state is FullImageLoaded;
      }, listener: (context, state) {
        if (state is FullImageLoaded) {
          widget.eyepair.fullImageBytes = state.imageBytes;
          setState(() {
            imageBytes = state.imageBytes;
          });
        }
        if (state is FullImageError) {}
      }, child: BlocBuilder<ImageBloc, ImageState>(builder: ((context, state) {
        final mediaHeight = MediaQuery.of(context).size.height;
        final mediaWidth = MediaQuery.of(context).size.width;
        return Center(
          child: Container(
            // color: Colors.red,
            width: mediaWidth - (mediaWidth ~/ 5),
            height: mediaHeight - (mediaHeight ~/ 2),
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  state is FullImageError
                      ? Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: ErrorBanner(
                            state.errorDescription,
                          ),
                        )
                      : null,
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      imageBytes != null
                          // state is FullImageLoaded
                          ? SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: Image.memory(imageBytes!),
                            )
                          : const FittedBox(
                              fit: BoxFit.fill,
                              child: Icon(Icons.portrait, size: 200),
                            ),
                      state is ImageLoading
                          ? const Center(child: CircularProgressIndicator())
                          : null,
                    ].whereType<Widget>().toList(),
                  ),
                ].whereType<Widget>().toList(),
              ),
            ),
          ),
        );
        // );
      })))
    ]);
  }
}
*/