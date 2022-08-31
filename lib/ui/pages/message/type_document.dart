enum TypeDocument {
  IMAGE,
  VIDEO,
  FILE,
}

extension TypeDocumentExtension on TypeDocument {
  static TypeDocument? fromTypeDocument(String type) {
    switch (type) {
      case "IMAGE":
        return TypeDocument.IMAGE;
      case "VIDEO":
        return TypeDocument.VIDEO;
      case "FILE":
        return TypeDocument.FILE;
    }
    return null;
  }

  String get toTypeDocument {
    switch (this) {
      case TypeDocument.IMAGE:
        return "IMAGE";
      case TypeDocument.VIDEO:
        return "VIDEO";
      case TypeDocument.FILE:
        return "FILE";
    }
  }
}
