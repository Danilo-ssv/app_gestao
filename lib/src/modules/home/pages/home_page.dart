import 'package:app_gestao/src/modules/home/state/home_state.dart';
import 'package:app_gestao/src/shared/providers/local_storage_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final LocalStorageProvider localStorageProvider;
  late final HomeState state;

  @override
  void initState() {
    super.initState();

    localStorageProvider = context.read<LocalStorageProvider>();
    state = context.read<HomeState>();

    if (localStorageProvider.isInitialized) {
      state.home(context);
    }

    localStorageProvider.addListener(() {
      if (localStorageProvider.isInitialized && mounted) {
        state.home(context);
      }
    });
  }

  // @override
  // void dispose() {
  //   super.dispose();

  //   localStorageProvider.removeListener(() {});
  // }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Início')),
    );
  }
}
