import 'package:app_gestao/src/modules/vendas/pages/details_vendas_page.dart';
import 'package:app_gestao/src/modules/vendas/pages/finalize_vendas_page.dart';
import 'package:app_gestao/src/modules/vendas/pages/insert_vendas_page.dart';
import 'package:app_gestao/src/shared/providers/global_provider.dart';
import 'package:flutter/material.dart';
import 'package:app_gestao/src/modules/vendas/state/vendas_state.dart';
import 'package:app_gestao/src/shared/functions/delete_modal_function.dart';
import 'package:app_gestao/src/shared/components/search_text_field.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class VendasPage extends StatefulWidget {
  const VendasPage({super.key});

  @override
  State<VendasPage> createState() => _VendasPageState();
}

class _VendasPageState extends State<VendasPage> {
  late final VendasState state;

  final ScrollController _scrollController = ScrollController();

  final _dateController = TextEditingController();
  final _idClientesController = TextEditingController(text: '0');
  final _nomeClientesController = TextEditingController(text: 'Todos');
  final _searchcontroller = TextEditingController();
  // String _status = '0';

  void navigateToInsertPage(String id, {required bool clone}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InsertVendasPage(
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

  Color formatStatus(String status) {
    if (status == '1') return Colors.grey[700]!;
    if (status == '2') return Colors.green;
    return Colors.grey[700]!;
  }

  @override
  void initState() {
    super.initState();

    state = context.read<VendasState>();

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
                                    SearchAnchor(
                                      builder: (context, controller) {
                                        return TextField(
                                          controller: _nomeClientesController,
                                          decoration: const InputDecoration(
                                            label: Text('Cliente'),
                                          ),
                                          readOnly: true,
                                          onTap: () {
                                            controller.openView();
                                          },
                                        );
                                      },
                                      suggestionsBuilder: (context, controller) async {
                                        final search = controller.text;

                                        // final res = await context.read<GlobalProvider>().readClientes(context, search, includesAllOption: true);
                                        final res = await context.read<GlobalProvider>().readClientes(context, search);

                                        return (res ?? [])
                                            .map(
                                              (e) => ListTile(
                                                onTap: () {
                                                  _idClientesController.text = e.id;
                                                  _nomeClientesController.text = e.nome;
                                                  controller.closeView('');

                                                  state.changeIdClientes(_idClientesController.text);
                                                  read(loadMore: false);
                                                  Navigator.pop(context);
                                                },
                                                leading: const Icon(Icons.people),
                                                title: Text(e.nome),
                                                subtitle: Text('#${e.id}'),
                                              ),
                                            )
                                            .toList();
                                      },
                                    ),
                                    const SizedBox(height: 10),
                                    DropdownMenu(
                                      width: MediaQuery.of(context).size.width - 20,
                                      initialSelection: context.watch<VendasState>().status,
                                      onSelected: (value) {
                                        // _status = value ?? '1';
                                        state.changeStatus(value ?? Status.$0);
                                        read(loadMore: false);
                                        Navigator.pop(context);
                                      },
                                      dropdownMenuEntries: const [
                                        DropdownMenuEntry(value: Status.$0, label: 'Todos'),
                                        DropdownMenuEntry(value: Status.$1, label: 'Pendente'),
                                        DropdownMenuEntry(value: Status.$2, label: 'Finalizado'),
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
                        final data = context.watch<VendasState>().data;
                        final loading = context.watch<VendasState>().loading;

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
                                        color: formatStatus(item.status),
                                      ),
                                    ),
                                    Expanded(
                                      child: InkWell(
                                        borderRadius: const BorderRadius.only(
                                          bottomLeft: Radius.circular(8),
                                          topLeft: Radius.circular(8),
                                        ),
                                        onTap: () {},
                                        onDoubleTap: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => DetailsVendasPage(
                                              id: item.id,
                                            ),
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.only(top: 6, left: 10),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'ID: ${item.id}',
                                                style: const TextStyle(fontSize: 17),
                                              ),
                                              Text(
                                                item.nomeClientes,
                                                style: const TextStyle(fontSize: 17),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              Text(
                                                item.valorTotal,
                                                style: const TextStyle(fontSize: 17),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              Text(
                                                item.dataModificacao,
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
                                                      builder: (context) => DetailsVendasPage(
                                                        id: item.id,
                                                      ),
                                                    ),
                                                  );
                                                },
                                                child: const Row(
                                                  children: [
                                                    SizedBox(width: 15),
                                                    Text('Detalhes'),
                                                    SizedBox(width: 15),
                                                  ],
                                                ),
                                              ),
                                              MenuItemButton(
                                                onPressed: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) => FinalizeVendasPage(
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
                                                    Text('Finalizar'),
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
            if (context.watch<VendasState>().loading == Loading.refresh) ...const [
              Center(child: CircularProgressIndicator()),
            ]
          ],
        ),
      ),
    );

    // return Container(
    //   color: const Color(0xfff5f6f8),
    //   child: Padding(
    //     padding: const EdgeInsets.all(10),
    //     child: Column(
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       children: [
    //         const Text(
    //           'Vendas',
    //           style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
    //         ),
    //         const SizedBox(height: 5),
    //         Expanded(
    //           child: Card(
    //             margin: EdgeInsets.zero,
    //             color: Colors.white,
    //             surfaceTintColor: Colors.white,
    //             child: Padding(
    //               padding: const EdgeInsets.all(8.0),
    //               child: Column(
    //                 children: [
    //                   Row(
    //                     children: [
    //                       Material(
    //                         color: Colors.blue,
    //                         borderRadius: BorderRadius.circular(4),
    //                         child: InkWell(
    //                           onTap: () {
    //                             navigateToInsertPage('', clone: false);
    //                           },
    //                           borderRadius: BorderRadius.circular(4),
    //                           child: const Padding(
    //                             padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
    //                             child: Text(
    //                               '+ Inserir',
    //                               style: TextStyle(color: Colors.white),
    //                             ),
    //                           ),
    //                         ),
    //                       ),
    //                       const SizedBox(width: 10),
    //                       SizedBox(
    //                         width: 200,
    //                         child: CustomTextfield(
    //                           controller: _dateController,
    //                           textAlign: TextAlign.center,
    //                           readOnly: true,
    //                           onTap: () async {
    //                             final date = await showDateRangePicker(
    //                               context: context,
    //                               firstDate: DateTime(DateTime.now().year - 20),
    //                               lastDate: DateTime(DateTime.now().year + 50),
    //                               initialDateRange: DateTimeRange(
    //                                 start: state.dateTimeRange!.start,
    //                                 end: state.dateTimeRange!.end,
    //                               ),
    //                               builder: (context, child) {
    //                                 return Column(
    //                                   mainAxisAlignment: MainAxisAlignment.center,
    //                                   children: [
    //                                     ConstrainedBox(
    //                                       constraints: const BoxConstraints(maxWidth: 480.0, maxHeight: 500),
    //                                       child: child,
    //                                     )
    //                                   ],
    //                                 );
    //                               },
    //                             );

    //                             if (!mounted || date == null) return;

    //                             state.changeDateTimeRange(date);

    //                             final startDate = DateFormat('dd/MM/yyyy').format(date.start);
    //                             final endDate = DateFormat('dd/MM/yyyy').format(date.end);

    //                             _dateController.text = '$startDate - $endDate';

    //                             read();
    //                           },
    //                         ),
    //                       ),
    //                       const SizedBox(width: 10),
    //                       CustomDropdownMenu(
    //                         width: 130,
    //                         initialSelection: '1',
    //                         onSelected: (value) {
    //                           state.changeStatus(value);
    //                           read();
    //                         },
    //                         dropdownMenuEntries: const [
    //                           DropdownMenuEntry(value: '0', label: 'Todos'),
    //                           DropdownMenuEntry(value: '1', label: 'Pendente'),
    //                           DropdownMenuEntry(value: '2', label: 'Finalizado'),
    //                         ],
    //                       ),
    //                       const Spacer(),
    //                       Transform.translate(
    //                         offset: const Offset(0, 5),
    //                         child: Row(
    //                           crossAxisAlignment: CrossAxisAlignment.start,
    //                           children: [
    //                             CustomActionButton(
    //                               function: context.watch<VendasState>().selectedItems.length == 1
    //                                   ? () {
    //                                       navigateToInsertPage(state.selectedItems.first, clone: false);
    //                                     }
    //                                   : null,
    //                               icon: Icons.edit,
    //                               mainColor: context.watch<VendasState>().selectedItems.length == 1
    //                                   ? const Color.fromRGBO(33, 150, 243, 1)
    //                                   : const Color.fromARGB(255, 180, 181, 182),
    //                               bgColor: context.watch<VendasState>().selectedItems.length == 1
    //                                   ? const Color.fromRGBO(33, 150, 243, .2)
    //                                   : const Color(0xffeeeff0),
    //                               tooptip: context.watch<VendasState>().selectedItems.length == 1 ? 'Editar Registro' : '',
    //                             ),
    //                             const SizedBox(width: 5),
    //                             CustomActionButton(
    //                               function: context.watch<VendasState>().selectedItems.length == 1
    //                                   ? () {
    //                                       navigateToInsertPage(state.selectedItems.first, clone: true);
    //                                     }
    //                                   : null,
    //                               icon: Icons.copy,
    //                               mainColor: context.watch<VendasState>().selectedItems.length == 1
    //                                   ? const Color.fromRGBO(0, 0, 0, 1)
    //                                   : const Color.fromARGB(255, 180, 181, 182),
    //                               bgColor: context.watch<VendasState>().selectedItems.length == 1
    //                                   ? const Color.fromRGBO(0, 0, 0, .1)
    //                                   : const Color(0xffeeeff0),
    //                               tooptip: context.watch<VendasState>().selectedItems.length == 1 ? 'Copiar Registro' : '',
    //                             ),
    //                             const SizedBox(width: 5),
    //                             CustomActionButton(
    //                               function: context.watch<VendasState>().selectedItems.isNotEmpty
    //                                   ? () => delete(
    //                                         state.selectedItems,
    //                                       )
    //                                   : null,
    //                               icon: Icons.delete,
    //                               mainColor: context.watch<VendasState>().selectedItems.isNotEmpty
    //                                   ? const Color.fromRGBO(244, 67, 54, 1)
    //                                   : const Color.fromARGB(255, 180, 181, 182),
    //                               bgColor: context.watch<VendasState>().selectedItems.isNotEmpty
    //                                   ? const Color.fromRGBO(244, 67, 54, .2)
    //                                   : const Color(0xffeeeff0),
    //                               tooptip: context.watch<VendasState>().selectedItems.isNotEmpty ? 'Excluir Registro' : '',
    //                             ),
    //                             const SizedBox(width: 5),
    //                           ],
    //                         ),
    //                       ),
    //                       SearchTextField(
    //                         controller: _searchcontroller,
    //                         onFinished: () => read(),
    //                         onChanged: (_) {
    //                           state.changeSearch(_searchcontroller.text);
    //                         },
    //                       ),
    //                     ],
    //                   ),
    //                   const SizedBox(height: 8),
    //                   Expanded(
    //                     child: CustomTable(
    //                       onTap: (item) {
    //                         state.changeSelectedItems((item as VendasModel?)?.id ?? '');
    //                       },
    //                       onDoubleTap: (item) {
    //                         navigateToInsertPage((item as VendasModel?)?.id ?? '', clone: false);
    //                       },
    //                       data: context.watch<VendasState>().data,
    //                       columns: (item, constraints) {
    //                         final width = constraints.maxWidth - 470;
    //                         final stateWatch = context.watch<VendasState>();

    //                         final checkboxIsSelected = stateWatch.selectedItems.length == stateWatch.data.length ||
    //                             stateWatch.selectedItems.contains(
    //                               item?.id ?? '',
    //                             );

    //                         return [
    //                           ColumnModel(
    //                             label: '',
    //                             width: 50,
    //                             value: (item as VendasModel?)?.id ?? '',
    //                             alignment: Alignment.center,
    //                             actions: [
    //                               Container(
    //                                 decoration: BoxDecoration(
    //                                   border: Border.all(
    //                                     color: Colors.black45,
    //                                     width: 0,
    //                                   ),
    //                                   borderRadius: BorderRadius.circular(5),
    //                                 ),
    //                                 child: Column(
    //                                   children: [
    //                                     const SizedBox(height: 3),
    //                                     CustomMenuActionButton(
    //                                       onTap: () {
    //                                         navigateToInsertPage(item?.id ?? '', clone: false);
    //                                       },
    //                                       label: 'editar',
    //                                     ),
    //                                     CustomMenuActionButton(
    //                                       onTap: () {
    //                                         navigateToInsertPage(item?.id ?? '', clone: true);
    //                                       },
    //                                       label: 'Clonar',
    //                                     ),
    //                                     CustomMenuActionButton(
    //                                       onTap: () {
    //                                         context.go(ClientRoutes.dashboardVendasFinalizar(id: item?.id ?? ''));
    //                                       },
    //                                       label: 'Finalizar',
    //                                     ),
    //                                     const SizedBox(height: 2),
    //                                     const Divider(
    //                                       color: Colors.black26,
    //                                       thickness: 0,
    //                                       height: 0,
    //                                     ),
    //                                     const SizedBox(height: 2),
    //                                     CustomMenuActionButton(
    //                                       onTap: () => delete([item?.id ?? '']),
    //                                       label: 'Excluir',
    //                                       color: Colors.red,
    //                                     ),
    //                                     const SizedBox(height: 2),
    //                                   ],
    //                                 ),
    //                               )
    //                             ],
    //                           ),
    //                           ColumnModel(
    //                             label: '',
    //                             width: 50,
    //                             value: item?.id ?? '',
    //                             alignment: Alignment.center,
    //                             checkbox: Transform.scale(
    //                               scale: .75,
    //                               child: Checkbox(
    //                                 splashRadius: 10,
    //                                 value: checkboxIsSelected,
    //                                 onChanged: (value) {
    //                                   state.changeSelectedItems(item?.id ?? '', selectAll: item == null);
    //                                 },
    //                               ),
    //                             ),
    //                           ),
    //                           ColumnModel(
    //                             label: 'ID',
    //                             width: 70,
    //                             value: item?.id ?? '',
    //                             alignment: Alignment.centerLeft,
    //                           ),
    //                           ColumnModel(
    //                             label: 'Cliente',
    //                             width: width < 100 ? 100 : width,
    //                             value: item?.nomeClientes ?? '',
    //                             alignment: Alignment.centerLeft,
    //                           ),
    //                           ColumnModel(
    //                             label: 'Valor Total',
    //                             width: 100,
    //                             value: item?.valorTotal ?? '',
    //                             alignment: Alignment.centerLeft,
    //                           ),
    //                           ColumnModel(
    //                             label: 'Data',
    //                             width: 100,
    //                             value: item?.dataModificacao ?? '',
    //                             alignment: Alignment.centerLeft,
    //                           ),
    //                           ColumnModel(
    //                             label: 'Status',
    //                             width: 100,
    //                             value: formatStatus(item?.status ?? ''),
    //                             alignment: Alignment.centerLeft,
    //                           ),
    //                         ];
    //                       },
    //                     ),
    //                   ),
    //                   const SizedBox(height: 5),
    //                   Row(
    //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                     children: [
    //                       // const CustomDropdownMenu(
    //                       //   initialSelection: '10',
    //                       //   dropdownMenuEntries: [
    //                       //     DropdownMenuEntry(value: '10', label: '10'),
    //                       //     DropdownMenuEntry(value: '20', label: '20'),
    //                       //     DropdownMenuEntry(value: '50', label: '50'),
    //                       //   ],
    //                       // ),
    //                       const SizedBox(),
    //                       Text(context.watch<VendasState>().recorsRange),
    //                       Row(
    //                         children: [
    //                           IconButton(
    //                             onPressed: context.watch<VendasState>().page <= 1
    //                                 ? null
    //                                 : () {
    //                                     state.changePage(increment: false);

    //                                     read();
    //                                   },
    //                             icon: const Icon(Icons.arrow_back_ios_new_rounded),
    //                           ),
    //                           const SizedBox(width: 5),
    //                           Text(context.watch<VendasState>().page.toString()),
    //                           const SizedBox(width: 5),
    //                           IconButton(
    //                             onPressed: context.watch<VendasState>().page >= context.watch<VendasState>().numberOfPages
    //                                 ? null
    //                                 : () {
    //                                     state.changePage(increment: true);

    //                                     read();
    //                                   },
    //                             icon: const Icon(Icons.arrow_forward_ios_rounded),
    //                           ),
    //                         ],
    //                       )
    //                     ],
    //                   ),
    //                 ],
    //               ),
    //             ),
    //           ),
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }
}
