import 'package:app_gestao/src/modules/despesas/pages/insert_despesas_page.dart';
import 'package:flutter/material.dart';
import 'package:app_gestao/src/modules/despesas/state/despesas_state.dart';
import 'package:app_gestao/src/shared/functions/delete_modal_function.dart';
import 'package:app_gestao/src/shared/components/search_text_field.dart';
import 'package:provider/provider.dart';

class DespesasPage extends StatefulWidget {
  const DespesasPage({super.key});

  @override
  State<DespesasPage> createState() => _DespesasPageState();
}

class _DespesasPageState extends State<DespesasPage> {
  late final DespesasState state;

  final ScrollController _scrollController = ScrollController();

  final _searchcontroller = TextEditingController();

  void navigateToInsertPage(String id, {required bool clone}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InsertDespesasPage(
          id: id,
          clone: clone,
          onSave: () {
            state.resetOnDispose();
            read(loadMore: false);
          },
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

    state = context.read<DespesasState>();

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
      appBar: AppBar(
        title: const Text('Despesas'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => navigateToInsertPage('', clone: false),
        child: const Icon(Icons.add),
      ),
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: SearchTextField(
                    controller: _searchcontroller,
                    onChanged: (_) => state.changeSearch(_searchcontroller.text),
                    onFinished: () => read(loadMore: false),
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Builder(
                      builder: (context) {
                        final data = context.watch<DespesasState>().data;
                        final loading = context.watch<DespesasState>().loading;

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
                                              Text('ID: ${item.id}', style: const TextStyle(fontSize: 17)),
                                              Text(
                                                item.nome,
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
                                              MenuItemButton(
                                                onPressed: () => navigateToInsertPage(item.id, clone: true),
                                                child: const Row(
                                                  children: [
                                                    SizedBox(width: 15),
                                                    Text('Clonar'),
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
            if (context.watch<DespesasState>().loading == Loading.refresh) ...const [
              Center(child: CircularProgressIndicator()),
            ]
          ],
        ),
      ),
    );
  }
}
