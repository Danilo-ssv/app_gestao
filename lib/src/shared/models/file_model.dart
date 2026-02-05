enum FileOrigin { network, local }

class FileModel {
  final FileOrigin fileOrigin;
  final String? urlPath;
  final String? path;

  FileModel({
    required this.fileOrigin,
    required this.urlPath,
    required this.path,
  });
}
