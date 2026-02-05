import 'package:app_gestao/src/shared/functions/currency_formatter_function.dart';
import 'package:app_gestao/src/shared/components/modals/insert_clientes_modal.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:app_gestao/src/modules/vendas/models/insert_vendas_model.dart';
import 'package:app_gestao/src/modules/vendas/models/itens_vendas_model.dart';
import 'package:app_gestao/src/modules/vendas/models/lista_categorias_vendas_model.dart';
import 'package:app_gestao/src/modules/vendas/state/vendas_state.dart';
import 'package:app_gestao/src/shared/functions/show_error_message.dart';
import 'package:app_gestao/src/shared/providers/global_provider.dart';
import 'package:app_gestao/src/shared/components/custom_image.dart';
import 'package:provider/provider.dart';

class InsertVendasPage extends StatefulWidget {
  final String id;
  final bool clone;
  final Function onSave;
  const InsertVendasPage({super.key, required this.id, required this.clone, required this.onSave});

  @override
  State<InsertVendasPage> createState() => _InsertVendasPageState();
}

class _InsertVendasPageState extends State<InsertVendasPage> {
  late final VendasState state;

  String _id = '';

  final _searchcontroller = TextEditingController();
  final _idClientesController = TextEditingController();
  final _nomeClientesController = TextEditingController();

  final ValueNotifier<List<ItensVendasModel>> listaItensVendas = ValueNotifier([]);

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      state = context.read<VendasState>();

      readById();
    });
  }

  @override
  void dispose() {
    state.listaCategorias = [];
    state.updatedProdutos = [];
    // state.readingInsertPage = true;

    super.dispose();
  }

  void readById() async {
    final res = await state.readById(
      context,
      widget.id,
    );

    setState(() {
      _id = widget.clone ? '' : (res?.id ?? '');
      _idClientesController.text = res?.idClientes ?? '';
      _nomeClientesController.text = res?.nomeClientes ?? '';
      listaItensVendas.value = res?.listaItensVendas ?? [];
    });
  }

  void insert() async {
    if (_idClientesController.text.isEmpty) {
      showErrorMessage(context, message: 'Selecione algum Cliente!', success: false);
      return;
    }

    if (listaItensVendas.value.isEmpty) {
      showErrorMessage(context, message: 'Selecione algum Produto!', success: false);
      return;
    }

    double valorTotal = 0;

    listaItensVendas.value.map((e) {
      if (!e.deleting) {
        valorTotal += int.parse(e.quantidade) *
            double.parse(
              e.valor.replaceAll('.', '').replaceAll(',', '.').replaceAll('R\$ ', ''),
            );
      }
    }).toList();

    final res = await state.insert(
      context,
      InsertVendasModel(
        id: _id,
        idClientes: _idClientesController.text,
        nomeClientes: '',
        valorTotal: valorTotal.toString(),
        listaItensVendas: [
          ...listaItensVendas.value.map((e) {
            return ItensVendasModel(
              id: e.id,
              idProdutos: e.idProdutos,
              nomeProdutos: e.nomeProdutos,
              quantidade: e.quantidade,
              valor: e.valor.replaceAll('.', '').replaceAll(',', '.').replaceAll('R\$ ', ''),
              isSelect: e.isSelect,
              deleting: e.deleting,
            );
          })
        ],
      ),
    );

    if (!mounted) return;

    Navigator.pop(context);

    if (res) {
      widget.onSave();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inserir Venda'),
      ),
      backgroundColor: const Color(0xfff5f6f8),
      floatingActionButton: ValueListenableBuilder(
        valueListenable: listaItensVendas,
        builder: (context, value, child) => value.isEmpty
            ? const SizedBox()
            : Badge(
                label: Text(value.length.toString(), style: const TextStyle(fontSize: 14)),
                child: FloatingActionButton(
                  shape: const CircleBorder(),
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (context) => _buildModalBottomSheet(),
                    );
                  },
                  child: const Icon(Icons.shopping_cart_outlined),
                ),
              ),
      ),
      body: Visibility(
        // visible: !context.watch<VendasState>().readingInsertPage,
        visible: !(context.watch<VendasState>().loading == Loading.loadInsertPage),
        replacement: const Center(child: CircularProgressIndicator()),
        child: Visibility(
          visible: context.watch<VendasState>().listaCategorias.isNotEmpty,
          replacement: const Center(child: Text('Não há Categorias Cadastradas')),
          child: DefaultTabController(
            length: context.watch<VendasState>().listaCategorias.length,
            child: Column(
              children: [
                TabBar(
                  tabAlignment: TabAlignment.start,
                  isScrollable: true,
                  tabs: context
                      .watch<VendasState>()
                      .listaCategorias
                      .map(
                        (categoria) => Tab(
                          text: categoria.nome,
                        ),
                      )
                      .toList(),
                ),
                Expanded(
                  child: TabBarView(
                    dragStartBehavior: DragStartBehavior.start,
                    children: context
                        .watch<VendasState>()
                        .listaCategorias
                        .asMap()
                        .entries
                        .map(
                          (categoria) => SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 5),
                              child: Column(
                                children: categoria.value.produtos
                                    .asMap()
                                    .entries
                                    .map(
                                      (produto) => Card(
                                        elevation: 4,
                                        child: SizedBox(
                                          height: 130,
                                          child: Material(
                                            color: Colors.white,
                                            borderRadius: const BorderRadius.all(Radius.circular(8)),
                                            child: InkWell(
                                              onTap: () {
                                                if (produto.value.estoque == '0') return;

                                                addProduct(categoria.key, produto.key, produto.value, null);
                                              },
                                              borderRadius: const BorderRadius.all(Radius.circular(8)),
                                              child: Padding(
                                                padding: const EdgeInsets.only(left: 8, right: 8, bottom: 5, top: 8),
                                                child: Row(
                                                  children: [
                                                    ClipRRect(
                                                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                                                      child: CustomImage(
                                                        onTap: null,
                                                        image: produto.value.image,
                                                        width: 110,
                                                        height: 110,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 10),
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        SizedBox(
                                                          width: MediaQuery.of(context).size.width - 160,
                                                          child: Text(
                                                            produto.value.nome,
                                                            maxLines: 2,
                                                            overflow: TextOverflow.ellipsis,
                                                            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                                                          ),
                                                        ),
                                                        const Spacer(),
                                                        Text(
                                                          produto.value.preco,
                                                          style: const TextStyle(
                                                            fontSize: 17,
                                                            fontWeight: FontWeight.w400,
                                                            color: Colors.green,
                                                          ),
                                                        ),
                                                        Align(
                                                          alignment: Alignment.centerLeft,
                                                          child: Text(
                                                            'Estoque: ${produto.value.estoque}',
                                                            style: const TextStyle(
                                                              fontSize: 15,
                                                              fontWeight: FontWeight.w400,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildModalBottomSheet() {
    return ValueListenableBuilder(
      valueListenable: listaItensVendas,
      builder: (context, value, child) => SizedBox(
        height: MediaQuery.of(context).size.height - 40,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(),
                    const Text('Itens Venda', style: TextStyle(fontSize: 18)),
                    Material(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(50),
                      child: InkWell(
                        onTap: () => Navigator.pop(context),
                        borderRadius: BorderRadius.circular(50),
                        child: const Padding(
                          padding: EdgeInsets.all(2),
                          child: Icon(Icons.close),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 10),
              SearchAnchor(
                builder: (context, controller) {
                  return TextField(
                    controller: _nomeClientesController,
                    decoration: InputDecoration(
                      label: const Text('Cliente'),
                      suffixIcon: IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => InsertClientesModal(
                              onSave: (id, nome) {
                                _idClientesController.text = id;
                                _nomeClientesController.text = nome;
                              },
                            ),
                          );
                        },
                        icon: const Icon(Icons.add),
                      ),
                    ),
                    onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
                    readOnly: true,
                    onTap: () {
                      controller.openView();
                    },
                  );
                },
                suggestionsBuilder: (context, controller) async {
                  final search = controller.text;

                  final res = await context.read<GlobalProvider>().readClientes(context, search);

                  return (res ?? [])
                      .map(
                        (e) => ListTile(
                          onTap: () {
                            _idClientesController.text = e.id;
                            _nomeClientesController.text = e.nome;
                            controller.closeView('');
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
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: value
                        .asMap()
                        .entries
                        .where((e) => !e.value.deleting)
                        .map(
                          (item) => InkWell(
                            onTap: () {
                              int? indexCategoria;
                              int? indexProduto;
                              ProdutosListaCategoriasVendasModel? produto;

                              for (int indexC = 0; indexC < state.listaCategorias.length; indexC++) {
                                if (indexCategoria != null) break;

                                final categoria = state.listaCategorias[indexC];

                                for (int indexP = 0; indexP < categoria.produtos.length; indexP++) {
                                  if (categoria.produtos[indexP].id == item.value.idProdutos) {
                                    indexCategoria = indexC;
                                    indexProduto = indexP;
                                    produto = categoria.produtos[indexP];
                                    break;
                                  }
                                }
                              }

                              if (indexCategoria == null || indexProduto == null || produto == null) return;

                              addProduct(indexCategoria, indexProduto, produto, item);
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: 270,
                                        child: Text(
                                          '${item.value.quantidade}x ${item.value.nomeProdutos} ',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          maxLines: 2,
                                        ),
                                      ),
                                      Text(
                                        item.value.valor,
                                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black54),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    CurrencyFormatterFunction.format(
                                      (int.parse(item.value.quantidade) *
                                              double.parse(
                                                item.value.valor.replaceAll('R\$ ', '').replaceAll('.', '').replaceAll(',', '.'),
                                              ))
                                          .toStringAsFixed(2),
                                      showSymbol: true,
                                    ),
                                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black54),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Material(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(4),
                child: InkWell(
                  onTap: () => insert(),
                  borderRadius: BorderRadius.circular(4),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Icon(
                        //   Icons.arrow_back,
                        //   color: Colors.white,
                        //   size: 18,
                        // ),
                        SizedBox(width: 5),
                        Text(
                          'Salvar',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  void addProduct(
    int indexCategoria,
    int indexProduto,
    ProdutosListaCategoriasVendasModel produto,
    MapEntry<int, ItensVendasModel>? itensVendas,
  ) {
    final ValueNotifier<int> quantity = ValueNotifier(1);

    if (itensVendas != null) {
      quantity.value = int.parse(itensVendas.value.quantidade);
    }

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, bottom: 10, top: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 230,
                      child: Text(
                        produto.nome,
                        style: const TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w300,
                          overflow: TextOverflow.ellipsis,
                        ),
                        maxLines: 2,
                      ),
                    ),
                    if (itensVendas != null) ...[
                      IconButton(
                        onPressed: () {
                          if (itensVendas.value.id == '') {
                            listaItensVendas.value = [
                              ...listaItensVendas.value.asMap().entries.where((e) => e.key != itensVendas.key).map((e) => e.value),
                            ];
                          } else {
                            listaItensVendas.value = [
                              ...listaItensVendas.value.map((e) {
                                if (e.id != itensVendas.value.id) return e;

                                return ItensVendasModel(
                                  id: itensVendas.value.id,
                                  idProdutos: itensVendas.value.idProdutos,
                                  nomeProdutos: itensVendas.value.nomeProdutos,
                                  quantidade: itensVendas.value.quantidade,
                                  valor: itensVendas.value.valor,
                                  isSelect: itensVendas.value.isSelect,
                                  deleting: true,
                                );
                              }),
                            ];
                          }

                          state.updateProdutoEstoque(
                            indexCategoria,
                            indexProduto,
                            produto.id,
                            (int.parse(produto.estoque) + int.parse(itensVendas.value.quantidade)).toString(),
                          );

                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.delete, color: Colors.red),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 10),
                ValueListenableBuilder(
                  valueListenable: quantity,
                  builder: (context, value, child) => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Material(
                        color: value <= 1 ? Colors.grey[200] : Colors.red,
                        borderRadius: BorderRadius.circular(4),
                        child: InkWell(
                          onTap: value <= 1
                              ? null
                              : () {
                                  quantity.value = value - 1;
                                },
                          borderRadius: BorderRadius.circular(4),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                            child: Icon(Icons.remove, color: value <= 1 ? Colors.black : Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Text(
                        value.toString(),
                        style: const TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 19,
                        ),
                      ),
                      const SizedBox(width: 15),
                      Material(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(4),
                        child: InkWell(
                          onTap: () {
                            if (value - int.parse(itensVendas?.value.quantidade ?? '0') < int.parse(produto.estoque)) {
                              quantity.value = value + 1;
                            }
                          },
                          borderRadius: BorderRadius.circular(4),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                            child: Icon(Icons.add, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancelar'),
                    ),
                    const SizedBox(width: 10),
                    TextButton(
                      onPressed: () {
                        if (itensVendas != null) {
                          listaItensVendas.value = [
                            ...listaItensVendas.value.asMap().entries.map((e) {
                              if (e.key != itensVendas.key) return e.value;

                              return ItensVendasModel(
                                id: e.value.id,
                                idProdutos: e.value.idProdutos,
                                nomeProdutos: e.value.nomeProdutos,
                                quantidade: quantity.value.toString(),
                                valor: e.value.valor,
                                isSelect: e.value.isSelect,
                                deleting: e.value.deleting,
                              );
                            }),
                          ];
                        } else {
                          listaItensVendas.value = [
                            ...listaItensVendas.value,
                            ItensVendasModel(
                              id: '',
                              idProdutos: produto.id,
                              nomeProdutos: produto.nome,
                              quantidade: quantity.value.toString(),
                              valor: produto.preco,
                              isSelect: false,
                              deleting: false,
                            ),
                          ];
                        }

                        state.updateProdutoEstoque(
                          indexCategoria,
                          indexProduto,
                          produto.id,
                          (int.parse(produto.estoque) - quantity.value + int.parse(itensVendas?.value.quantidade ?? '0')).toString(),
                        );
                        Navigator.pop(context);
                      },
                      child: const Text('Salvar'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
