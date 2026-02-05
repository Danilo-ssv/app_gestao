import 'package:app_gestao/src/modules/vendas/models/insert_vendas_model.dart';
import 'package:app_gestao/src/modules/vendas/state/vendas_state.dart';
import 'package:app_gestao/src/shared/functions/currency_formatter_function.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DetailsVendasPage extends StatefulWidget {
  final String id;
  const DetailsVendasPage({super.key, required this.id});

  @override
  State<DetailsVendasPage> createState() => _DetailsVendasPageState();
}

class _DetailsVendasPageState extends State<DetailsVendasPage> {
  final ValueNotifier<InsertVendasModel?> insertVendasModel = ValueNotifier(null);

  @override
  void initState() {
    super.initState();

    readById();
  }

  void readById() async {
    insertVendasModel.value = await context.read<VendasState>().readForDetails(context, widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes do Produto'),
      ),
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: ValueListenableBuilder(
          valueListenable: insertVendasModel,
          builder: (context, value, child) {
            if (value == null) return const Center(child: CircularProgressIndicator());

            return ListView(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              children: [
                const SizedBox(height: 15),
                Text(
                  value.nomeClientes,
                  style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    const Text('Valor Total: '),
                    const Spacer(),
                    Text(CurrencyFormatterFunction.format(value.valorTotal, showSymbol: true),
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                const Divider(),
                ...value.listaItensVendas.map(
                  (item) => InkWell(
                    onTap: () {
                      // int? indexCategoria;
                      // int? indexProduto;
                      // ProdutosListaCategoriasVendasModel? produto;

                      // for (int indexC = 0; indexC < state.listaCategorias.length; indexC++) {
                      //   if (indexCategoria != null) break;

                      //   final categoria = state.listaCategorias[indexC];

                      //   for (int indexP = 0; indexP < categoria.produtos.length; indexP++) {
                      //     if (categoria.produtos[indexP].id == item.value.idProdutos) {
                      //       indexCategoria = indexC;
                      //       indexProduto = indexP;
                      //       produto = categoria.produtos[indexP];
                      //       break;
                      //     }
                      //   }
                      // }

                      // if (indexCategoria == null || indexProduto == null || produto == null) return;

                      // addProduct(indexCategoria, indexProduto, produto, item);
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
                                  '${item.quantidade}x ${item.nomeProdutos} ',
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
                                item.valor,
                                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black54),
                              ),
                            ],
                          ),
                          Text(
                            CurrencyFormatterFunction.format(
                              (int.parse(item.quantidade) * double.parse(item.valor)).toStringAsFixed(2),
                              showSymbol: true,
                            ),
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black54),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
