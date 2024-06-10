
enum Flavor {
  development,
  release,
}

class AppFlavor {
  static Flavor appFlavor = Flavor.development;

  static String get baseApi {
    switch (appFlavor) {
      case Flavor.release:
        return 'https://jsonplaceholder.typicode.com';
      case Flavor.development:
        return 'https://jsonplaceholder.typicode.com';
      default:
        return 'https://jsonplaceholder.typicode.com';
    }
  }
}