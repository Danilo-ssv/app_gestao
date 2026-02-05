import 'dart:typed_data';

import 'package:dio/dio.dart';

enum ImageOrigin {
  network,
  file,
  memory,
}

class ImageModel {
  final ImageOrigin imageOrigin;
  final String name;
  final String? urlPath; // network
  final String? path; // file
  final Uint8List? bytes; // memory

  ImageModel({
    required this.imageOrigin,
    required this.name,
    required this.urlPath,
    required this.path,
    required this.bytes,
  }) {
    if (imageOrigin == ImageOrigin.network && urlPath == null) throw 'When ImageOrigin.network, urlPath is Required!';
    if (imageOrigin == ImageOrigin.file && path == null) throw 'When ImageOrigin.file, path is Required!';
    if (imageOrigin == ImageOrigin.memory && bytes == null) throw 'When ImageOrigin.memory, bytes is Required!';
  }

  Future<MultipartFile?> getInsertImage() async {
    if (imageOrigin == ImageOrigin.file) return await MultipartFile.fromFile(path!, filename: name);
    if (imageOrigin == ImageOrigin.memory) return MultipartFile.fromBytes(bytes!, filename: name);
    return null;
  }
}
