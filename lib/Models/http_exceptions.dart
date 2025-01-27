class HttpExceptions implements Exception {
  String message;
  HttpExceptions({required this.message});
  @override
  String toString() {
    return message;
    // super.toString(); // Instance of httpException
  }
}

class NoProductsExceptions implements Exception {
  String message;
  NoProductsExceptions({required this.message});
  @override
  String toString() {
    return message;
    // super.toString(); // Instance of httpException
  }
}

class NoOrdersExceptions implements Exception {
  String message;
  NoOrdersExceptions({required this.message});
  @override
  String toString() {
    return message;
    // super.toString(); // Instance of httpException
  }
}

class NoInternetExceptions implements Exception {
  String message;
  NoInternetExceptions({required this.message});
  @override
  String toString() {
    return message;
    // super.toString(); // Instance of httpException
  }
}

class OnUnknownExceptions implements Exception {
  String message;
  OnUnknownExceptions({required this.message});
  @override
  String toString() {
    return message;
    // super.toString(); // Instance of httpException
  }
}
