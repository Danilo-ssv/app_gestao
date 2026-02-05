import 'package:app_gestao/src/modules/produtos/pages/insert_baixa_estoque_page.dart';
import 'package:app_gestao/src/modules/produtos/pages/insert_produtos_page.dart';
import 'package:app_gestao/src/shared/functions/bars_code_scanner.dart';
import 'package:flutter/material.dart';
import 'package:app_gestao/src/modules/produtos/state/produtos_state.dart';
import 'package:app_gestao/src/shared/functions/delete_modal_function.dart';
import 'package:app_gestao/src/shared/components/search_text_field.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:provider/provider.dart';

class ProdutosPage extends StatefulWidget {
  const ProdutosPage({super.key});

  @override
  State<ProdutosPage> createState() => _ProdutosPageState();
}

class _ProdutosPageState extends State<ProdutosPage> {
  late final ProdutosState state;

  final ScrollController _scrollController = ScrollController();

  final _searchcontroller = TextEditingController();

  void navigateToInsertPage(String id, {required bool clone, String? codigoBarra, String? nome, String? preco}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InsertProdutosPage(
          id: id,
          clone: clone,
          onSave: () {
            state.resetOnDispose();
            read(loadMore: false);
          },
          codigoBarra: codigoBarra,
          nome: nome,
          preco: preco,
        ),
      ),
    );
  }

  void delete(List<String> listaIds) {
    deleteModalFunction(
      context,
      length: listaIds.length,
      function: () async => await state.delete(context, listaIds),
    );
  }

  Future<void> read({required bool loadMore}) async {
    await state.read(context, loadMore: loadMore);
  }

  @override
  void initState() {
    super.initState();

    state = context.read<ProdutosState>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.addListener(() {
        if (_scrollController.position.maxScrollExtent == _scrollController.offset) {
          if (state.page < state.numberOfPages) {
            state.changePage(increment: true);

            read(loadMore: true);
          }
        }
      });

      read(loadMore: false);
    });
  }

  @override
  void dispose() {
    _searchcontroller.dispose();
    _scrollController.dispose();

    state.resetOnDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: ExpandableFab(
        type: ExpandableFabType.up,
        distance: 80,
        openButtonBuilder: RotateFloatingActionButtonBuilder(
          child: const Icon(Icons.add),
          fabSize: ExpandableFabSize.regular,
        ),
        closeButtonBuilder: RotateFloatingActionButtonBuilder(
          backgroundColor: Colors.red,
          child: const Icon(Icons.close),
          fabSize: ExpandableFabSize.regular,
        ),
        children: [
          FloatingActionButton(
            heroTag: null,
            child: const Icon(Icons.qr_code_2),
            onPressed: () async {
              final codigoBarra = await barsCodeScanner(context);

              if (!context.mounted || codigoBarra == null) return;

              final res = await state.readByBarsCode(context, codigoBarra);

              if (!context.mounted) return;

              navigateToInsertPage(
                '',
                clone: false,
                codigoBarra: codigoBarra,
                nome: res?.nome ?? '',
                preco: res?.preco ?? '',
              );
            },
          ),
          FloatingActionButton(
            heroTag: null,
            child: const Icon(Icons.grading),
            onPressed: () => navigateToInsertPage('', clone: false),
          ),
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () => navigateToInsertPage('', clone: false),
      //   child: Icon(Icons.add),
      // ),
      body: RefreshIndicator(
        onRefresh: () async {
          state.resetOnDispose();
          await read(loadMore: false);
        },
        child: Stack(
          children: [
            Column(
              children: [
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: SearchTextField(
                          controller: _searchcontroller,
                          onChanged: (_) => state.changeSearch(_searchcontroller.text),
                          onFinished: () => read(loadMore: false),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        final codigoBarra = await barsCodeScanner(context);

                        if (!context.mounted || codigoBarra == null) return;

                        navigateToInsertPage(
                          '0',
                          clone: false,
                          codigoBarra: codigoBarra,
                        );
                      },
                      icon: const Icon(Icons.qr_code_2),
                    ),
                    const SizedBox(width: 5),
                  ],
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Builder(
                      builder: (context) {
                        final data = context.watch<ProdutosState>().data;
                        final loading = context.watch<ProdutosState>().loading;

                        if (loading == Loading.none && data.isEmpty) {
                          return ListView(
                            children: const [
                              SizedBox(height: 40),
                              Text('Não há Itens Cadastrados!', textAlign: TextAlign.center),
                            ],
                          );
                        }

                        return ListView.builder(
                          controller: _scrollController,
                          itemCount: data.length + 1,
                          itemBuilder: (context, index) {
                            if (index == data.length) {
                              if (loading == Loading.loadMore) {
                                return const SizedBox(
                                  height: 100,
                                  child: Center(child: CircularProgressIndicator()),
                                );
                              }

                              if (state.page >= state.numberOfPages) {
                                return const SizedBox(
                                  height: 100,
                                  child: Center(child: Text('Fim dos Itens Cadastrados!')),
                                );
                              }

                              return const SizedBox(height: 100);
                            }

                            final item = data[index];

                            return Card(
                              child: SizedBox(
                                height: 130,
                                child: Row(
                                  children: [
                                    // ClipRRect(
                                    //   borderRadius: BorderRadius.horizontal(left: Radius.circular(8)),
                                    //   child: Container(
                                    //     width: 5,
                                    //     color: Colors.orange,
                                    //     // color: formatStatus(item.status),
                                    //   ),
                                    // ),
                                    Expanded(
                                      child: InkWell(
                                        borderRadius: const BorderRadius.only(
                                          bottomLeft: Radius.circular(8),
                                          topLeft: Radius.circular(8),
                                        ),
                                        onTap: () {},
                                        onDoubleTap: () => navigateToInsertPage(item.id, clone: false),
                                        child: Padding(
                                          padding: const EdgeInsets.only(top: 6, left: 10),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  SizedBox(
                                                    // width: MediaQuery.of(context).size.width - 157,
                                                    width: MediaQuery.of(context).size.width - 150,
                                                    child: Text(
                                                      item.nome,
                                                      style: const TextStyle(fontSize: 17),
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                  Text('#${item.id}', style: const TextStyle(fontSize: 17)),
                                                ],
                                              ),
                                              Text(
                                                'Código: ${item.codigo}',
                                                style: const TextStyle(fontSize: 17),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              Text(
                                                item.preco,
                                                style: const TextStyle(fontSize: 17),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              Text(
                                                'Estoque: ${item.estoque}',
                                                style: const TextStyle(fontSize: 17),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Column(
                                      children: [
                                        Expanded(
                                          child: InkWell(
                                            borderRadius: const BorderRadius.only(
                                              topRight: Radius.circular(8),
                                            ),
                                            onTap: () => navigateToInsertPage(item.id, clone: false),
                                            child: const SizedBox(
                                              width: 50,
                                              child: Icon(Icons.edit),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: MenuAnchor(
                                            alignmentOffset: const Offset(-45, 0),
                                            style: const MenuStyle(padding: WidgetStatePropertyAll(EdgeInsets.zero)),
                                            builder: (context, controller, child) {
                                              return InkWell(
                                                borderRadius: const BorderRadius.only(
                                                  bottomRight: Radius.circular(8),
                                                ),
                                                onTap: () {
                                                  if (controller.isOpen) {
                                                    controller.close();
                                                  } else {
                                                    controller.open();
                                                  }
                                                },
                                                child: const SizedBox(
                                                  width: 50,
                                                  child: Icon(Icons.more_vert),
                                                ),
                                              );
                                            },
                                            menuChildren: [
                                              // MenuItemButton(
                                              //   onPressed: () => navigateToInsertPage(item.id, clone: true),
                                              //   child: Row(
                                              //     children: [
                                              //       SizedBox(width: 15),
                                              //       Text('Clonar'),
                                              //       SizedBox(width: 15),
                                              //     ],
                                              //   ),
                                              // ),
                                              MenuItemButton(
                                                onPressed: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) => InsertBaixaEstoquePage(
                                                        id: item.id,
                                                        onSave: () {
                                                          state.resetOnDispose();
                                                          read(loadMore: false);
                                                        },
                                                      ),
                                                    ),
                                                  );
                                                },
                                                child: const Row(
                                                  children: [
                                                    SizedBox(width: 15),
                                                    Text('Dar Baixa'),
                                                    SizedBox(width: 15),
                                                  ],
                                                ),
                                              ),
                                              const Divider(height: 0),
                                              MenuItemButton(
                                                onPressed: () => delete([item.id]),
                                                child: const Row(
                                                  children: [
                                                    SizedBox(width: 15),
                                                    Text('Excluir', style: TextStyle(color: Colors.red)),
                                                    SizedBox(width: 15),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
            if (context.watch<ProdutosState>().loading == Loading.refresh) ...const [
              Center(child: CircularProgressIndicator()),
            ]
          ],
        ),
      ),
    );
  }
}
