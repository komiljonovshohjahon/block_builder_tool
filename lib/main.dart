import 'package:block_builder_tool/pages/pages.dart';
import 'package:creatego_packages/creatego_packages.dart';
import 'package:flutter/material.dart';

final _router = GoRouter(routes: [
  GoRoute(path: "/", builder: (context, state) => const HomePage()),
]);

void main() {
  CreategoRunner.run(
      params:
          const RunnerParams(child: BlockBuilderApp(), size: Size(1080, 720)));
}

class BlockBuilderApp extends StatelessWidget {
  const BlockBuilderApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Block Builder',
      routerConfig: _router,
    );
  }
}
