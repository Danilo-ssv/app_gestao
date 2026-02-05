import 'dart:io';

import 'package:app_gestao/src/shared/components/modals/insert_marcas_produtos_modal.dart';
import 'package:app_gestao/src/shared/functions/currency_formatter_function.dart';
import 'package:app_gestao/src/shared/models/file_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:app_gestao/src/modules/produtos/models/insert_produtos_model.dart';
import 'package:app_gestao/src/modules/produtos/state/produtos_state.dart';
import 'package:app_gestao/src/shared/functions/show_error_message.dart';
import 'package:app_gestao/src/shared/providers/global_provider.dart';
import 'package:app_gestao/src/shared/components/modals/insert_categorias_produtos_modal.dart';
import 'package:provider/provider.dart';

class InsertProdutosPage extends StatefulWidget {
  final String id;
  final bool clone;
  final Function onSave;
  final String? codigoBarra;
  final String? nome;
  final String? preco;

  const InsertProdutosPage({
    super.key,
    required this.id,
    required this.clone,
    required this.onSave,
    this.codigoBarra,
    this.nome,
    this.preco,
  });

  @override
  State<InsertProdutosPage> createState() => _InsertProdutosPageState();
}

class _InsertProdutosPageState extends State<InsertProdutosPage> with TickerProviderStateMixin {
  late final TabController _tabController;

  String _id = '';
  final _codigoBarraController = TextEditingController();
  final _codigoController = TextEditingController();
  final _nomeController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _precoController = TextEditingController();
  final _custoController = TextEditingController();
  final _estoqueController = TextEditingController();
  final _idMarcasProdutosController = TextEditingController(text: '0');
  final _nomeMarcasProdutosController = TextEditingController(text: 'Selecione uma Marca de Produtos');
  final _idCategoriasProdutosController = TextEditingController(text: '0');
  final _nomeCategoriasProdutosController = TextEditingController(text: 'Selecione uma Categoria de Produtos');
  final _alertaEstoqueMinimoController = TextEditingController();
  final _generoController = TextEditingController(text: ProdutosGenero.$1.formatToString());
  final ValueNotifier<FileModel?> _image = ValueNotifier(null);

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, vsync: this);

    _codigoBarraController.text = widget.codigoBarra ?? '';
    // _codigoBarraController.text = widget.codigoBarra ?? '7908132275446';
    _nomeController.text = widget.nome ?? '';
    _precoController.text = widget.preco ?? '';

    if (widget.id.isNotEmpty) {
      readById();
    }
  }

  void readById() async {
    final res = await context.read<ProdutosState>().readById(
          context,
          widget.id,
          widget.codigoBarra ?? '',
        );

    setState(() {
      _id = widget.clone ? '' : (res?.id ?? '');
      _codigoBarraController.text = res?.codigoBarra ?? '';
      _codigoController.text = res?.codigo ?? '';
      _nomeController.text = res?.nome ?? '';
      _descricaoController.text = res?.descricao ?? '';
      _precoController.text = res?.preco ?? '';
      _custoController.text = res?.custo ?? '';
      _estoqueController.text = res?.estoque ?? '';
      _idMarcasProdutosController.text = res?.idMarcasProdutos ?? '';
      _nomeMarcasProdutosController.text = res?.nomeMarcasProdutos ?? '';
      _idCategoriasProdutosController.text = res?.idCategoriasProdutos ?? '';
      _nomeCategoriasProdutosController.text = res?.nomeCategoriasProdutos ?? '';
      _alertaEstoqueMinimoController.text = res?.alertaEstoqueMinimo ?? '';
      _generoController.text = (res?.genero ?? ProdutosGenero.$1).formatToString();
      _image.value = res?.image;
    });
  }

  void insert() async {
    if (_nomeController.text.isEmpty) {
      showErrorMessage(context, message: 'Nome do Produto é Obrigatório!', success: false);
      return;
    }

    final res = await context.read<ProdutosState>().insert(
          context,
          InsertProdutosModel(
            id: _id,
            codigoBarra: _codigoBarraController.text,
            codigo: _codigoController.text,
            nome: _nomeController.text,
            descricao: _descricaoController.text,
            preco: _precoController.text.replaceAll('.', '').replaceAll(',', '.'),
            custo: _custoController.text.replaceAll('.', '').replaceAll(',', '.'),
            estoque: _estoqueController.text,
            idMarcasProdutos: _idMarcasProdutosController.text,
            nomeMarcasProdutos: '',
            idCategoriasProdutos: _idCategoriasProdutosController.text,
            nomeCategoriasProdutos: '',
            alertaEstoqueMinimo: _alertaEstoqueMinimoController.text,
            genero: ProdutosGenero.$1.formatToEnum(_generoController.text),
            image: _image.value,
          ),
        );

    if (res) {
      widget.onSave();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inserir Produto'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            const Tab(child: Text('Dados Gerais')),
            const Tab(child: Text('Fotos')),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => insert(),
        label: const Row(
          children: [
            Text('Salvar'),
            SizedBox(width: 10),
            Icon(Icons.check),
          ],
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: TabBarView(
          controller: _tabController,
          children: [
            _buildTab1(),
            _buildTab2(),
          ],
        ),
      ),
    );
  }

  Widget _buildTab1() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      children: [
        const SizedBox(height: 15),
        Row(
          children: [
            Expanded(
              child: TextField(
                maxLength: 50,
                controller: _codigoController,
                decoration: const InputDecoration(
                  label: Text('Código'),
                  counterText: '',
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                maxLength: 150,
                controller: _codigoBarraController,
                decoration: InputDecoration(
                  label: const Text('Código de Barra'),
                  counterText: '',
                  suffixIcon: IconButton(
                    onPressed: () async {
                      if (_codigoBarraController.text.isEmpty) return;

                      final res = await context.read<ProdutosState>().readByBarsCode(context, _codigoBarraController.text);

                      if (!context.mounted) return;

                      _nomeController.text = res?.nome ?? '';
                      _precoController.text = res?.preco ?? '';
                    },
                    icon: const Icon(Icons.qr_code_2),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        TextField(
          maxLength: 150,
          controller: _nomeController,
          decoration: const InputDecoration(
            label: Text('Nome do Produto'),
            counterText: '',
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: SearchAnchor(
                builder: (context, controller) {
                  return TextField(
                    controller: _nomeMarcasProdutosController,
                    decoration: InputDecoration(
                      label: const Text('Marcas de Produtos'),
                      suffixIcon: _idMarcasProdutosController.text == '0'
                          ? IconButton(
                              onPressed: () => controller.openView(),
                              icon: const Icon(Icons.arrow_drop_down),
                            )
                          : IconButton(
                              onPressed: () {
                                setState(() {
                                  _idMarcasProdutosController.text = '0';
                                  _nomeMarcasProdutosController.text = 'Selecione uma Marca de Produtos';
                                  controller.clear();
                                });
                              },
                              icon: const Tooltip(
                                message: 'Limpar campo de Marca de Produtos!',
                                child: Icon(Icons.delete_outline),
                              ),
                            ),
                    ),
                    readOnly: true,
                    onTap: () => controller.openView(),
                  );
                },
                suggestionsBuilder: (context, controller) async {
                  final search = controller.text;

                  final res = await context.read<GlobalProvider>().readMarcasProdutos(context, search);

                  return [
                    if (search == '') ...[
                      ListTile(
                        onTap: () {
                          _idMarcasProdutosController.text = '0';
                          _nomeMarcasProdutosController.text = 'Selecione uma Marca de Produtos';
                          controller.closeView('');
                        },
                        leading: const SizedBox(),
                        title: const Text('Selecione uma Marca de Produtos', maxLines: 1, overflow: TextOverflow.ellipsis),
                      ),
                    ],
                    ...(res ?? []).map(
                      (e) => ListTile(
                        onTap: () {
                          _idMarcasProdutosController.text = e.id;
                          _nomeMarcasProdutosController.text = e.nome;
                          controller.closeView(e.nome);
                        },
                        leading: const Icon(Icons.sell_outlined),
                        title: Text(e.nome),
                        subtitle: Text('#${e.id}'),
                      ),
                    ),
                  ];
                },
              ),
            ),
            const SizedBox(width: 5),
            Tooltip(
              message: 'Inserir nova Marca de Produtos!',
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Theme.of(context).colorScheme.primary, width: 1.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Material(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  child: InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => InsertMarcasProdutosModal(
                          onSave: (id, nome) {
                            _idMarcasProdutosController.text = id;
                            _nomeMarcasProdutosController.text = nome;
                          },
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                      child: Icon(Icons.add, size: 26, color: Theme.of(context).colorScheme.primary),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: SearchAnchor(
                builder: (context, controller) {
                  return TextField(
                    controller: _nomeCategoriasProdutosController,
                    decoration: InputDecoration(
                      label: const Text('Categorias de Produtos'),
                      suffixIcon: _idCategoriasProdutosController.text == '0'
                          ? IconButton(
                              onPressed: () => controller.openView(),
                              icon: const Icon(Icons.arrow_drop_down),
                            )
                          : IconButton(
                              onPressed: () {
                                setState(() {
                                  _idCategoriasProdutosController.text = '0';
                                  _nomeCategoriasProdutosController.text = 'Selecione uma Categoria de Produtos';
                                  controller.clear();
                                });
                              },
                              icon: const Tooltip(
                                message: 'Limpar campo de Categoria de Produtos!',
                                child: Icon(Icons.delete_outline),
                              ),
                            ),
                    ),
                    readOnly: true,
                    onTap: () => controller.openView(),
                  );
                },
                suggestionsBuilder: (context, controller) async {
                  final search = controller.text;

                  final res = await context.read<GlobalProvider>().readCategoriasProdutos(context, search);

                  return [
                    if (search == '') ...[
                      ListTile(
                        onTap: () {
                          _idCategoriasProdutosController.text = '0';
                          _nomeCategoriasProdutosController.text = 'Selecione uma Categoria de Produtos';
                          controller.closeView('');
                        },
                        leading: const SizedBox(),
                        title: const Text('Selecione uma Categoria de Produtos', maxLines: 1, overflow: TextOverflow.ellipsis),
                      ),
                    ],
                    ...(res ?? []).map(
                      (e) => ListTile(
                        onTap: () {
                          _idCategoriasProdutosController.text = e.id;
                          _nomeCategoriasProdutosController.text = e.nome;
                          controller.closeView(e.nome);
                        },
                        leading: const Icon(Icons.style_outlined),
                        title: Text(e.nome),
                        subtitle: Text('#${e.id}'),
                      ),
                    ),
                  ];
                },
              ),
            ),
            const SizedBox(width: 5),
            Tooltip(
              message: 'Inserir nova Categoria de Produtos!',
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Theme.of(context).colorScheme.primary, width: 1.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Material(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  child: InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => InsertCategoriasProdutosModal(
                          onSave: (id, nome) {
                            _idCategoriasProdutosController.text = id;
                            _nomeCategoriasProdutosController.text = nome;
                          },
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                      child: Icon(Icons.add, size: 26, color: Theme.of(context).colorScheme.primary),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _precoController,
                decoration: const InputDecoration(
                  label: Text('Preço'),
                  prefixText: 'R\$ ',
                ),
                onChanged: (value) {
                  _precoController.text = CurrencyFormatterFunction.format(value);
                },
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                controller: _custoController,
                decoration: const InputDecoration(
                  label: Text('Custo'),
                  prefixText: 'R\$ ',
                ),
                onChanged: (value) {
                  _custoController.text = CurrencyFormatterFunction.format(value);
                },
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _estoqueController,
                decoration: const InputDecoration(
                  label: Text('Estoque'),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                controller: _alertaEstoqueMinimoController,
                decoration: const InputDecoration(
                  label: Text('Alerta Estoque Mínimo'),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        DropdownMenu(
          width: MediaQuery.of(context).size.width - 20,
          label: const Text('Gênero'),
          initialSelection: _generoController.text,
          onSelected: (value) => _generoController.text = value ?? ProdutosGenero.$1.formatToString(),
          dropdownMenuEntries: [
            DropdownMenuEntry(value: ProdutosGenero.$1.formatToString(), label: 'Masculino'),
            DropdownMenuEntry(value: ProdutosGenero.$2.formatToString(), label: 'Feminino'),
          ],
        ),
        const SizedBox(height: 10),
        TextField(
          maxLength: 150,
          controller: _descricaoController,
          decoration: const InputDecoration(
            label: Text('Descrição'),
            counterText: '',
            constraints: BoxConstraints(maxHeight: 120),
          ),
          maxLines: 4,
        ),
        const SizedBox(height: 100),
      ],
    );
  }

  Widget _buildTab2() {
    return ValueListenableBuilder(
      valueListenable: _image,
      builder: (context, value, child) => SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 15),
            InkWell(
              onTap: () async {
                try {
                  FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.image, allowMultiple: false);

                  if (result == null) return;

                  if (result.files.single.path == null) return;

                  _image.value = FileModel(fileOrigin: FileOrigin.local, urlPath: null, path: result.files.single.path);
                } catch (_) {}
              },
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                child: Container(
                  color: const Color(0x998a8b8d),
                  child: buildImage(value),
                ),
              ),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget buildImage(FileModel? image) {
    final height = (MediaQuery.of(context).size.width - 40) * 9 / 16;
    final width = (MediaQuery.of(context).size.width - 40);

    if (image?.fileOrigin == FileOrigin.network) {
      return CachedNetworkImage(
        height: height,
        width: width,
        imageUrl: image!.urlPath!,
        fit: BoxFit.fitHeight,
        placeholder: (context, url) => const Align(
          alignment: Alignment.center,
          child: CircularProgressIndicator(
            strokeWidth: 3,
          ),
        ),
        errorWidget: (context, url, error) => const Icon(Icons.error_outline),
      );
    }

    if (image?.fileOrigin == FileOrigin.local) {
      return Image.file(
        File(image!.path!),
        height: height,
        width: width,
        fit: BoxFit.fitHeight,
      );
    }

    return Image.asset(
      'assets/no_image.png',
      height: height,
      width: width,
      fit: BoxFit.fitHeight,
    );
  }
}
