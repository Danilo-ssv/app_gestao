import 'dart:ui';

import 'package:app_gestao/src/modules/authentication/services/authentication_services.dart';
import 'package:app_gestao/src/modules/authentication/state/authentication_state.dart';
import 'package:app_gestao/src/modules/categorias_produtos/services/categorias_produtos_services.dart';
import 'package:app_gestao/src/modules/categorias_produtos/state/categorias_produtos_state.dart';
import 'package:app_gestao/src/modules/clientes/services/clientes_services.dart';
import 'package:app_gestao/src/modules/clientes/state/clientes_state.dart';
import 'package:app_gestao/src/modules/contas_pagar/services/contas_pagar_services.dart';
import 'package:app_gestao/src/modules/contas_pagar/state/contas_pagar_state.dart';
import 'package:app_gestao/src/modules/contas_receber/services/contas_receber_services.dart';
import 'package:app_gestao/src/modules/contas_receber/state/contas_receber_state.dart';
import 'package:app_gestao/src/modules/despesas/services/despesas_services.dart';
import 'package:app_gestao/src/modules/despesas/state/despesas_state.dart';
import 'package:app_gestao/src/modules/fornecedores/services/fornecedores_services.dart';
import 'package:app_gestao/src/modules/fornecedores/state/fornecedores_state.dart';
import 'package:app_gestao/src/modules/home/services/home_services.dart';
import 'package:app_gestao/src/modules/home/state/home_state.dart';
import 'package:app_gestao/src/modules/marcas_produtos/services/marcas_produtos_services.dart';
import 'package:app_gestao/src/modules/marcas_produtos/state/marcas_produtos_state.dart';
import 'package:app_gestao/src/modules/produtos/services/produtos_services.dart';
import 'package:app_gestao/src/modules/produtos/state/produtos_state.dart';
import 'package:app_gestao/src/modules/usuarios/services/usuarios_services.dart';
import 'package:app_gestao/src/modules/usuarios/state/usuarios_state.dart';
import 'package:app_gestao/src/modules/vendas/services/vendas_services.dart';
import 'package:app_gestao/src/modules/vendas/state/vendas_state.dart';
import 'package:app_gestao/src/shared/pages/dashboard_page_container.dart';
import 'package:app_gestao/src/shared/providers/api_provider.dart';
import 'package:app_gestao/src/shared/providers/global_provider.dart';
import 'package:app_gestao/src/shared/providers/global_services.dart';
import 'package:app_gestao/src/shared/providers/local_storage_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter is initialized
  try {
    await dotenv.load(fileName: ".env"); // Load environment variables
  } catch (e) {
    throw Exception('Error loading .env file: $e'); // Print error if any
  }
  runApp(const MyApp());
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Essencial
        Provider(create: (context) => ApiProvider()),
        ChangeNotifierProvider(create: (context) => LocalStorageProvider()),
        Provider(
            create: (context) =>
                AuthenticationServices(context.read(), context.read())),
        ChangeNotifierProvider(
            create: (context) =>
                AuthenticationState(context.read(), context.read())),
        Provider(
            create: (context) =>
                GlobalServices(context.read(), context.read())),
        Provider(create: (context) => GlobalProvider(context.read())),
        // HOME
        Provider(
            create: (context) => HomeServices(context.read(), context.read())),
        ChangeNotifierProvider(create: (context) => HomeState(context.read())),
        // CLIENTES
        Provider(
            create: (context) =>
                ClientesServices(context.read(), context.read())),
        ChangeNotifierProvider(
            create: (context) => ClientesState(context.read())),
        // PRODUTOS
        Provider(
            create: (context) =>
                ProdutosServices(context.read(), context.read())),
        ChangeNotifierProvider(
            create: (context) => ProdutosState(context.read())),
        // AGENDA
        // Provider(create: (context) => ClientesServices(context.read(), context.read())),
        // ChangeNotifierProvider(create: (context) => ClientesState(context.read())),
        // USUARIOS
        Provider(
            create: (context) =>
                UsuariosServices(context.read(), context.read())),
        ChangeNotifierProvider(
            create: (context) => UsuariosState(context.read())),
        // FORNECEDORES
        Provider(
            create: (context) =>
                FornecedoresServices(context.read(), context.read())),
        ChangeNotifierProvider(
            create: (context) => FornecedoresState(context.read())),
        // CATEGORIAS PRODUTOS
        Provider(
            create: (context) =>
                CategoriasProdutosServices(context.read(), context.read())),
        ChangeNotifierProvider(
            create: (context) => CategoriasProdutosState(context.read())),
        // DESPESAS
        Provider(
            create: (context) =>
                DespesasServices(context.read(), context.read())),
        ChangeNotifierProvider(
            create: (context) => DespesasState(context.read())),
        // CONTAS A PAGAR
        Provider(
            create: (context) =>
                ContasPagarServices(context.read(), context.read())),
        ChangeNotifierProvider(
            create: (context) => ContasPagarState(context.read())),
        // CONTAS A RECEBER
        Provider(
            create: (context) =>
                ContasReceberServices(context.read(), context.read())),
        ChangeNotifierProvider(
            create: (context) => ContasReceberState(context.read())),
        // MARCAS PRODUTOS
        Provider(
            create: (context) =>
                MarcasProdutosServices(context.read(), context.read())),
        ChangeNotifierProvider(
            create: (context) => MarcasProdutosState(context.read())),
        // VENDAS
        Provider(
            create: (context) =>
                VendasServices(context.read(), context.read())),
        ChangeNotifierProvider(
            create: (context) => VendasState(context.read())),
      ],
      child: MaterialApp(
        scrollBehavior: MyCustomScrollBehavior(),
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('pt')],
        theme: ThemeData(
          // primaryColor: Colors.red,
          // primarySwatch: Colors.red,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
          scaffoldBackgroundColor: const Color(0xfff1f1f1),
          appBarTheme: const AppBarTheme(
            titleTextStyle: TextStyle(fontSize: 24, color: Colors.black),
            centerTitle: true,
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
            iconTheme: IconThemeData(color: Colors.black),
            shadowColor: Colors.black54,
            elevation: 2,
          ),
          tabBarTheme: const TabBarThemeData(
            unselectedLabelStyle: TextStyle(fontSize: 15, color: Colors.black),
            labelStyle: TextStyle(fontSize: 15, color: Colors.black),
          ),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            foregroundColor: Colors.white,
            backgroundColor: Colors.blue,
            // backgroundColor: Theme.of(context).colorScheme.primary,
          ),
          inputDecorationTheme: const InputDecorationTheme(
            contentPadding: EdgeInsets.fromLTRB(10.0, 8.0, 10.0, 10.0),
            constraints: BoxConstraints(maxHeight: 50),
            // constraints: BoxConstraints(maxHeight: 40),
            border: OutlineInputBorder(),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blue),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
          dropdownMenuTheme: const DropdownMenuThemeData(
            inputDecorationTheme: InputDecorationTheme(
              filled: true,
              fillColor: Colors.white,
            ),
          ),
          dialogTheme: const DialogThemeData(backgroundColor: Colors.white),
          bottomSheetTheme:
              const BottomSheetThemeData(backgroundColor: Colors.white),
          // pageTransitionsTheme: const PageTransitionsTheme(
          //   builders: {
          //     TargetPlatform.android: CustomTransitionBuilder(),
          //     TargetPlatform.iOS: CustomTransitionBuilder(),
          //     TargetPlatform.macOS: CustomTransitionBuilder(),
          //     TargetPlatform.windows: CustomTransitionBuilder(),
          //     TargetPlatform.linux: CustomTransitionBuilder(),
          //   },
          // ),
        ),
        home: const DashboardPageContainer(),
      ),
    );

    // return MaterialApp(
    //   scrollBehavior: MyCustomScrollBehavior(),
    //   title: 'Flutter Demo',
    //   debugShowCheckedModeBanner: false,
    //   theme: ThemeData(
    //     colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
    //     useMaterial3: true,
    //   ),
    //   home: const HomePage(),
    // );
  }
}
