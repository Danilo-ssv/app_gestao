import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:app_gestao/src/shared/constants/api_routes.dart';
import 'package:app_gestao/src/shared/models/image_model.dart';

class CustomImage extends StatelessWidget {
  final Function(ImageModel imageModel)? onTap;
  final ImageModel? image;
  final double? height;
  final double? width;
  final BorderRadius? borderRadius;

  const CustomImage({
    super.key,
    required this.onTap,
    required this.image,
    this.height,
    this.width,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap == null
          ? null
          : () async {
              try {
                FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.image, allowMultiple: false);

                if (result == null) return;

                if (kIsWeb) {
                  if (result.files.single.bytes == null) return;
                  onTap!(
                    ImageModel(
                      imageOrigin: ImageOrigin.memory,
                      name: result.files.single.name,
                      urlPath: null,
                      path: null,
                      bytes: result.files.single.bytes,
                    ),
                  );
                } else {
                  if (result.files.single.path == null) return;
                  onTap!(
                    ImageModel(
                      imageOrigin: ImageOrigin.file,
                      name: result.files.single.name,
                      urlPath: null,
                      path: result.files.single.path,
                      bytes: null,
                    ),
                  );
                }
              } catch (_) {}
            },
      borderRadius: borderRadius ?? const BorderRadius.all(Radius.circular(4)),
      child: ClipRRect(
        borderRadius: borderRadius ?? const BorderRadius.all(Radius.circular(4)),
        child: buildImage(image),
      ),
    );
  }

  Widget buildImage(ImageModel? image) {
    if (image?.imageOrigin == ImageOrigin.network) {
      return CachedNetworkImage(
        height: height,
        width: width,
        imageUrl: 'https://gestao-bucket.s3.us-east-2.amazonaws.com/${image!.urlPath!}',
        // imageUrl: '${ApiRoutes.baseUrl}${ApiRoutes.storage}/${image!.urlPath!}',
        // cacheManager: DefaultCacheManager(),
        fit: BoxFit.cover,
        placeholder: (context, url) => const Align(
          alignment: Alignment.center,
          child: CircularProgressIndicator(
            strokeWidth: 3,
          ),
        ),
        errorWidget: (context, url, error) => const Icon(Icons.error_outline),
      );
    }

    if (image?.imageOrigin == ImageOrigin.file) {
      return Image.file(
        File(image!.path!),
        height: height,
        width: width,
        fit: BoxFit.cover,
      );
    }

    if (image?.imageOrigin == ImageOrigin.memory) {
      return Image.memory(
        image!.bytes!,
        height: height,
        width: width,
        fit: BoxFit.cover,
      );
    }

    return Image.asset(
      'assets/no_image.png',
      height: height,
      width: width,
      fit: BoxFit.cover,
    );
  }
}
