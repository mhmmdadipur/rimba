import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widgets/widgets.dart';

class ImageViewerPage extends StatefulWidget {
  final File? file;
  final String? url;
  final bool isNetworkImage;
  final bool renderAppbar;

  const ImageViewerPage({
    super.key,
    required this.isNetworkImage,
    this.file,
    this.url,
    this.renderAppbar = false,
  })  : assert(file != null || url != null), // there has to be one
        assert(!(file != null && url != null)); // can't have both;

  @override
  State<ImageViewerPage> createState() => _ImageViewerPageState();
}

class _ImageViewerPageState extends State<ImageViewerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.renderAppbar ? const CustomAppBarWidget() : null,
      body: widget.isNetworkImage
          ? SizedBox(
              width: Get.width,
              height: Get.height,
              child: CustomCacheImage(
                  imageUrl: '${widget.url}', fit: BoxFit.contain),
            )
          : Container(
              width: Get.width,
              height: Get.height,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: FileImage(widget.file!), fit: BoxFit.contain),
              ),
            ),
    );
  }
}
