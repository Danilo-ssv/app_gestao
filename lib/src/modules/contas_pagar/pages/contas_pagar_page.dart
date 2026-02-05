import 'package:app_gestao/src/modules/contas_pagar/pages/insert_contas_pagar_page.dart';
import 'package:app_gestao/src/modules/contas_pagar/pages/contas_pagar_parcelling_page.dart';
import 'package:app_gestao/src/modules/contas_pagar/pages/contas_pagar_write_off_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:app_gestao/src/modules/contas_pagar/state/contas_pagar_state.dart';
import 'package:app_gestao/src/shared/functions/delete_modal_function.dart';
import 'package:app_gestao/src/shared/components/search_text_field.dart';
import 'package:provider/provider.dart';

class ContasPagarPage extends StatefulWidget {
  const ContasPagarPage({super.key});

  @override
  State<ContasPagarPage> createState() => _ContasPagarPageState();
}

class _ContasPagarPageState extends State<ContasPagarPage> {
  late final ContasPagarState state;

  final ScrollController _scrollController = ScrollController();

  final _dateController = TextEditingController();
  final _searchcontroller = TextEditingController();

  void navigateToInsertPage(String id, {required bool clone}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InsertContasPagarPage(
          id: id,
          clone: clone,
          onSave: () {
            state.resetOnDispose(resetFilters: false);
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

    state = context.read<ContasPagarState>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.addListener(() {
        if (_scrollController.position.maxScrollExtent == _scrollController.offset) {
          if (state.page < state.numberOfPages) {
            state.changePage(increment: true);

            read(loadMore: true);
          }
        }
      });

      final now = DateTime.now();

      state.changeDateTimeRange(
        DateTimeRange(start: DateTime(now.year, now.month, 1), end: DateTime(now.year, now.month + 1, 0)),
      );

      final startDate = DateFormat('dd/MM/yyyy').format(state.dateTimeRange!.start);
      final endDate = DateFormat('dd/MM/yyyy').format(state.dateTimeRange!.end);
      _dateController.text = '$startDate - $endDate';

      read(loadMore: false);
    });
  }

  @override
  void dispose() {
    _dateController.dispose();
    _searchcontroller.dispose();
    _scrollController.dispose();

    state.resetOnDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contas a Pagar'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => navigateToInsertPage('', clone: false),
        child: const Icon(Icons.add),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          state.resetOnDispose(resetFilters: false);
          await read(loadMore: false);
        },
        child: Stack(
          children: [
            Column(
              children: [
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: SearchTextField(
                          controller: _searchcontroller,
                          onChanged: (_) => state.changeSearch(_searchcontroller.text),
                          onFinished: () => read(loadMore: false),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            showDragHandle: true,
                            builder: (context) {
                              return Padding(
                                padding: EdgeInsets.only(
                                  left: 10,
                                  right: 10,
                                  bottom: MediaQuery.of(context).viewInsets.bottom,
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: TextField(
                                            controller: _dateController,
                                            textAlign: TextAlign.center,
                                            readOnly: true,
                                            onTap: () async {
                                              final date = await showDateRangePicker(
                                                context: context,
                                                firstDate: DateTime(DateTime.now().year - 20),
                                                lastDate: DateTime(DateTime.now().year + 50),
                                                initialDateRange: DateTimeRange(
                                                  start: state.dateTimeRange!.start,
                                                  end: state.dateTimeRange!.end,
                                                ),
                                              );
                                              if (!context.mounted || date == null) return;
                                              state.changeDateTimeRange(date);
                                              final startDate = DateFormat('dd/MM/yyyy').format(date.start);
                                              final endDate = DateFormat('dd/MM/yyyy').format(date.end);
                                              _dateController.text = '$startDate - $endDate';
                                              read(loadMore: false);
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    DropdownMenu(
                                      width: MediaQuery.of(context).size.width - 20,
                                      initialSelection: context.watch<ContasPagarState>().status,
                                      onSelected: (value) {
                                        state.changeStatus(value ?? Status.$1);
                                        read(loadMore: false);
                                        Navigator.pop(context);
                                      },
                                      dropdownMenuEntries: const [
                                        DropdownMenuEntry(value: Status.$0, label: 'Todos'),
                                        DropdownMenuEntry(value: Status.$1, label: 'Pendente'),
                                        DropdownMenuEntry(value: Status.$2, label: 'Pago'),
                                        DropdownMenuEntry(value: Status.$3, label: 'Atrasado'),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                        icon: const Icon(Icons.tune_rounded),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Builder(
                      builder: (context) {
                        final data = context.watch<ContasPagarState>().data;
                        final loading = context.watch<ContasPagarState>().loading;

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
                                    ClipRRect(
                                      borderRadius: const BorderRadius.horizontal(left: Radius.circular(8)),
                                      child: Container(
                                        width: 5,
                                        color: Color(int.parse('0xff${item.color.split('#').last}')),
                                      ),
                                    ),
                                    Expanded(
                                      child: InkWell(
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
                                                    width: MediaQuery.of(context).size.width - 150,
                                                    child: Text(
                                                      item.nomeFornecedores,
                                                      style: const TextStyle(fontSize: 17),
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                  const Spacer(),
                                                  Text('#${item.id}', style: const TextStyle(fontSize: 17)),
                                                ],
                                              ),
                                              Text(
                                                item.nomeDespesas,
                                                style: const TextStyle(fontSize: 17),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              Text(
                                                item.descricao,
                                                style: const TextStyle(fontSize: 17),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    item.dataVencimento,
                                                    style: const TextStyle(fontSize: 17),
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                  const Spacer(),
                                                  Text(
                                                    item.valor,
                                                    style: const TextStyle(fontSize: 17),
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ],
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
                                              MenuItemButton(
                                                onPressed: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) => ContasPagarParcellingPage(
                                                        id: item.id,
                                                        onSave: () {
                                                          state.resetOnDispose(resetFilters: false);
                                                          read(loadMore: false);
                                                        },
                                                      ),
                                                    ),
                                                  );
                                                },
                                                child: const Row(
                                                  children: [
                                                    SizedBox(width: 15),
                                                    Text('Parcelar'),
                                                    SizedBox(width: 15),
                                                  ],
                                                ),
                                              ),
                                              MenuItemButton(
                                                onPressed: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) => ContasPagarWriteOffPage(
                                                        id: item.id,
                                                        onSave: () {
                                                          state.resetOnDispose(resetFilters: false);
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
            if (context.watch<ContasPagarState>().loading == Loading.refresh) ...const [
              Center(child: CircularProgressIndicator()),
            ]
          ],
        ),
      ),
    );
  }
}
