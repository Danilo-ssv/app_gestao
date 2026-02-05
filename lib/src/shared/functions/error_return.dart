enum TypeErrorModel { notAuthenticated, notAllowed, common }

class ErrorModel {
  final TypeErrorModel type;
  final String message;

  ErrorModel({
    required this.type,
    required this.message,
  });
}

ErrorModel errorReturn(String message) {
  if (message == 'NotAuthenticated') return ErrorModel(type: TypeErrorModel.notAuthenticated, message: 'Não está Autenticado!');
  if (message == 'NotAllowed') return ErrorModel(type: TypeErrorModel.notAllowed, message: 'Não possui esta Autorização!');
  return ErrorModel(type: TypeErrorModel.common, message: message);
}
