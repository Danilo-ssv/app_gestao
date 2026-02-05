import 'package:app_gestao/src/modules/authentication/pages/login_page.dart';
import 'package:app_gestao/src/modules/categorias_produtos/pages/categorias_produtos_page.dart';
import 'package:app_gestao/src/modules/clientes/pages/clientes_page.dart';
import 'package:app_gestao/src/modules/contas_pagar/pages/contas_pagar_page.dart';
import 'package:app_gestao/src/modules/contas_receber/pages/contas_receber_page.dart';
import 'package:app_gestao/src/modules/despesas/pages/despesas_page.dart';
import 'package:app_gestao/src/modules/fornecedores/pages/fornecedores_page.dart';
import 'package:app_gestao/src/modules/home/pages/home_page.dart';
import 'package:app_gestao/src/modules/marcas_produtos/pages/marcas_produtos_page.dart';
import 'package:app_gestao/src/modules/produtos/pages/produtos_page.dart';
import 'package:app_gestao/src/modules/usuarios/pages/usuarios_page.dart';
import 'package:app_gestao/src/modules/vendas/pages/vendas_page.dart';
import 'package:app_gestao/src/shared/providers/local_storage_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DashboardPageContainer extends StatefulWidget {
  const DashboardPageContainer({super.key});

  @override
  State<DashboardPageContainer> createState() => _DashboardPageContainerState();
}

class _DashboardPageContainerState extends State<DashboardPageContainer> {
  late final LocalStorageProvider localStorageProvider;

  final _pageController = PageController();
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();

    localStorageProvider = context.read<LocalStorageProvider>();

    localStorageProvider.init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: _buildTitle()),
      drawer: _buildDrawer(),
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _pageController,
        onPageChanged: (value) => setState(() => _currentIndex = value),
        children: [
          const HomePage(),
          const ClientesPage(),
          const ProdutosPage(),
          const VendasPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_alt_outlined),
            label: 'Clientes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory_2_outlined),
            label: 'Produtos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.point_of_sale),
            label: 'Vendas',
          ),
        ],
        currentIndex: _currentIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.black,
        showUnselectedLabels: true,
        onTap: (value) => _pageController.jumpToPage(value),
      ),
    );
  }

  Widget _buildTitle() {
    if (_currentIndex == 0) return const Text('Home');
    if (_currentIndex == 1) return const Text('Clientes');
    if (_currentIndex == 2) return const Text('Produtos');
    return const Text('Vendas');
  }

  Widget _buildDrawer() {
    return Drawer(
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                // ListTile(
                //   onTap: () {
                //     context.go(ClientRoutes.dashboardHome());
                //   },
                //   title: Text('Home'),
                //   leading: Icon(Icons.home),
                // ),
                SizedBox(
                  height: 200,
                  child: UserAccountsDrawerHeader(
                    accountName: const Text('#1 Adriana'),
                    accountEmail: const Text('drica-bernini@hotmail.com'),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    currentAccountPictureSize: const Size(50, 50),
                    currentAccountPicture: const CircleAvatar(
                      child: ClipOval(
                        child: Icon(Icons.person),
                      ),
                    ),
                  ),
                ),
                ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    _pageController.jumpToPage(0);
                  },
                  title: const Text('Home'),
                  leading: const Icon(Icons.home_outlined),
                ),
                const Row(
                  children: [
                    Expanded(child: Divider(height: 0, indent: 5, endIndent: 5)),
                    Text('Pessoas', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
                    Expanded(child: Divider(height: 0, indent: 5, endIndent: 5)),
                  ],
                ),
                ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    _pageController.jumpToPage(1);
                  },
                  title: const Text('Clientes'),
                  leading: const Icon(Icons.people_alt_outlined),
                ),
                ListTile(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const FornecedoresPage()));
                  },
                  title: const Text('Fornecedores'),
                  leading: const Icon(Icons.person_2_outlined),
                ),
                const Row(
                  children: [
                    Expanded(child: Divider(height: 0, indent: 5, endIndent: 5)),
                    Text('Produtos', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
                    Expanded(child: Divider(height: 0, indent: 5, endIndent: 5)),
                  ],
                ),
                ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    _pageController.jumpToPage(2);
                  },
                  title: const Text('Produtos'),
                  leading: const Icon(Icons.inventory_2_outlined),
                ),
                ListTile(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const CategoriasProdutosPage()));
                  },
                  title: const Text('Categorias de Produtos'),
                  leading: const Icon(Icons.style_outlined),
                ),
                ListTile(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const MarcasProdutosPage()));
                  },
                  title: const Text('Marcas de Produtos'),
                  leading: const Icon(Icons.sell_outlined),
                ),
                const Row(
                  children: [
                    Expanded(child: Divider(height: 0, indent: 5, endIndent: 5)),
                    Text('Financeiro', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
                    Expanded(child: Divider(height: 0, indent: 5, endIndent: 5)),
                  ],
                ),
                ListTile(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const ContasPagarPage()));
                  },
                  title: const Text('Contas a Pagar'),
                  leading: const Icon(Icons.payment_outlined),
                ),
                ListTile(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const ContasReceberPage()));
                  },
                  title: const Text('Contas a Receber'),
                  leading: const Icon(Icons.attach_money_rounded),
                ),
                ListTile(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const DespesasPage()));
                  },
                  title: const Text('Despesas'),
                  leading: const Icon(Icons.receipt_long),
                ),
                const Row(
                  children: [
                    Expanded(child: Divider(height: 0, indent: 5, endIndent: 5)),
                    Text('Vendas', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
                    Expanded(child: Divider(height: 0, indent: 5, endIndent: 5)),
                  ],
                ),
                ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    _pageController.jumpToPage(3);
                  },
                  title: const Text('Vendas'),
                  leading: const Icon(Icons.point_of_sale),
                ),
                const Row(
                  children: [
                    Expanded(child: Divider(height: 0, indent: 5, endIndent: 5)),
                    Text('Configurações', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
                    Expanded(child: Divider(height: 0, indent: 5, endIndent: 5)),
                  ],
                ),
                ListTile(
                  onTap: () {},
                  title: const Text('Configurações'),
                  leading: const Icon(Icons.settings),
                ),
                ListTile(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const UsuariosPage()));
                  },
                  title: const Text('Usuários'),
                  leading: const Icon(Icons.people_outline_outlined),
                ),
              ],
            ),
          ),
          const Divider(height: 0),
          ListTile(
            onTap: () {
              showDialog<String>(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Sair'),
                    content: const SingleChildScrollView(
                      child: ListBody(
                        children: <Widget>[
                          Text('Deseja realmente Sair?'),
                        ],
                      ),
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('Cancelar'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        child: const Text('Sair'),
                        onPressed: () {
                          localStorageProvider.clearLocalStorage(
                            ClearProps(
                              user: true,
                              token: true,
                              themeMode: true,
                            ),
                          );
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginPage()));
                        },
                      ),
                    ],
                  );
                },
              );
            },
            title: const Text('Sair', style: TextStyle(color: Colors.red)),
            leading: const Icon(Icons.logout, color: Colors.red),
          ),
        ],
      ),
    );
  }
}
