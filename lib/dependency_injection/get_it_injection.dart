part of "path.dart";

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  /// ================= Api client ================
  serviceLocator.registerFactory<ApiClient>(
    () => ApiClient(),
  );
}
