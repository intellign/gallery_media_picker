import 'package:flutter/material.dart';
import 'package:gallery_media_picker/src/core/decode_image.dart';
import 'package:gallery_media_picker/src/core/functions.dart';
import 'package:gallery_media_picker/src/presentation/pages/gallery_media_picker_controller.dart';
import 'package:photo_manager/photo_manager.dart';

class CoverThumbnail extends StatefulWidget {
  final int thumbnailQuality;
  final double thumbnailScale;
  final BoxFit thumbnailFit;
  final Widget? permissionWidget;
  final int viewIndex;
  const CoverThumbnail(
      {Key? key,
      this.permissionWidget,
      this.thumbnailQuality = 120,
      this.thumbnailScale = 1.0,
      this.thumbnailFit = BoxFit.cover,
      required this.viewIndex})
      : super(key: key);

  @override
  State<CoverThumbnail> createState() => _CoverThumbnailState();
}

class _CoverThumbnailState extends State<CoverThumbnail> {
  /// create object of PickerDataProvider
  final provider = GalleryMediaPickerController();

  @override
  void initState() {
    super.initState();
    if (widget.viewIndex != 1 &&
        (widget.permissionWidget == null ||
            !(widget.permissionWidget is Widget))) {
      GalleryFunctions.getPermission(setState, provider);
    }
  }

  @override
  void dispose() {
    if (mounted) {
      provider.pickedFile.clear();
      provider.picked.clear();
      provider.pathList.clear();
      PhotoManager.stopChangeNotify().catchError((e) {});

      super.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget imgIcon({bool loading = false}) {
      return Container(
        height: 45,
        width: 45,
        color: Colors.transparent,
        child: Transform.scale(
          scale: 0.7,
          child: loading
              ? CircularProgressIndicator(
                  strokeWidth: 1.5,
                  color: Colors.white,
                )
              : Icon(
                  Icons.photo_rounded,
                  color: Colors.white,
                ),
        ),
      );
    }

    return provider.pathList.isNotEmpty
        ? Image(
            errorBuilder: (context, error, stackTrace) {
              return imgIcon();
            },
            image: DecodeImage(provider.pathList[0],
                thumbSize: widget.thumbnailQuality,
                index: 0,
                scale: widget.thumbnailScale),
            fit: widget.thumbnailFit,
            filterQuality: FilterQuality.high,
          )
        : Container(
            child: widget.permissionWidget != null
                ? Container(
                    height: 45,
                    width: 45,
                    color: Colors.transparent,
                    child: Transform.scale(
                      scale: 0.7,
                      child: const Icon(
                        Icons.priority_high_rounded,
                        color: Colors.red,
                      ),
                    ),
                  )
                : imgIcon(),
          );
  }
}
