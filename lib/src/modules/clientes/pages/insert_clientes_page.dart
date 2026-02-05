import 'package:intl/intl.dart';
import 'package:app_gestao/src/shared/functions/show_error_message.dart';
import 'package:provider/provider.dart';
import 'package:app_gestao/src/modules/clientes/models/insert_clientes_model.dart';
import 'package:app_gestao/src/modules/clientes/state/clientes_state.dart';
import 'package:app_gestao/src/shared/providers/global_provider.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InsertClientesPage extends StatefulWidget {
  final String id;
  final bool clone;
  final Function onSave;
  const InsertClientesPage({super.key, required this.id, required this.clone, required this.onSave});

  @override
  State<InsertClientesPage> createState() => _InsertClientesPageState();
}

class _InsertClientesPageState extends State<InsertClientesPage> {
  String _id = '';
  final _nomeController = TextEditingController();
  final _estadoCivilController = TextEditingController(text: ClientesEstadoCivil.$1.formatToString());
  final _generoController = TextEditingController(text: ClientesGenero.$1.formatToString());
  final _entidadeController = TextEditingController(text: ClientesEntidade.$1.formatToString());
  final _aniversarioController = TextEditingController();
  final _docController = TextEditingController();
  final _rgController = TextEditingController();
  final _celularController = TextEditingController();
  final _emailController = TextEditingController();
  final _cepController = TextEditingController();
  final _enderecoController = TextEditingController();
  final _numeroController = TextEditingController();
  final _idMunicipiosController = TextEditingController(text: '0');
  final _nomeMunicipiosController = TextEditingController(text: 'Selecione um Município');
  final _obsController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.id.isNotEmpty) {
      readById();
    }
  }

  void readById() async {
    final res = await context.read<ClientesState>().readById(
          context,
          widget.id,
        );

    setState(() {
      _id = widget.clone ? '' : (res?.id ?? '');
      _nomeController.text = res?.nome ?? '';
      _estadoCivilController.text = (res?.estadoCivil ?? ClientesEstadoCivil.$1).formatToString();
      _generoController.text = (res?.genero ?? ClientesGenero.$1).formatToString();
      _entidadeController.text = (res?.entidade ?? ClientesEntidade.$1).formatToString();
      _aniversarioController.text = res?.aniversario ?? '';
      _docController.text = res?.doc ?? '';
      _rgController.text = res?.rg ?? '';
      _celularController.text = res?.celular ?? '';
      _emailController.text = res?.email ?? '';
      _cepController.text = res?.cep ?? '';
      _enderecoController.text = res?.endereco ?? '';
      _numeroController.text = res?.numero ?? '';
      _idMunicipiosController.text = res?.idMunicipios ?? '';
      _nomeMunicipiosController.text = res?.nomeMunicipios ?? '';
      _obsController.text = res?.obs ?? '';
    });
  }

  void insert() async {
    if (_nomeController.text.isEmpty) {
      showErrorMessage(context, message: 'Nome Completo é Obrigatório!', success: false);
      return;
    }

    final aniversario = _aniversarioController.text.split('/');

    final res = await context.read<ClientesState>().insert(
          context,
          InsertClientesModel(
            id: _id,
            nome: _nomeController.text,
            estadoCivil: ClientesEstadoCivil.$1.formatToEnum(_estadoCivilController.text),
            genero: ClientesGenero.$1.formatToEnum(_generoController.text),
            entidade: ClientesEntidade.$1.formatToEnum(_entidadeController.text),
            aniversario: aniversario.length != 3 ? '' : '${aniversario[2]}-${aniversario[1]}-${aniversario[0]}',
            doc: _docController.text,
            rg: _rgController.text,
            celular: _celularController.text,
            email: _emailController.text,
            cep: _cepController.text,
            endereco: _enderecoController.text,
            numero: _numeroController.text,
            idMunicipios: _idMunicipiosController.text,
            nomeMunicipios: '',
            obs: _obsController.text,
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
        title: const Text('Inserir Cliente'),
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
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          children: [
            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    maxLength: 150,
                    controller: _nomeController,
                    decoration: const InputDecoration(
                      label: Text('Nome Completo'),
                      counterText: '',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                DropdownMenu(
                  width: MediaQuery.of(context).size.width / 2 - 15,
                  label: const Text('Tipo de Pessoa'),
                  initialSelection: _entidadeController.text,
                  onSelected: (value) => _entidadeController.text = value ?? ClientesEntidade.$1.formatToString(),
                  dropdownMenuEntries: [
                    DropdownMenuEntry(value: ClientesEntidade.$1.formatToString(), label: 'Pessoa Física'),
                    DropdownMenuEntry(value: ClientesEntidade.$2.formatToString(), label: 'Pessoa Jurídica'),
                  ],
                ),
                const SizedBox(width: 10),
                DropdownMenu(
                  width: MediaQuery.of(context).size.width / 2 - 15,
                  label: const Text('Estado Civil'),
                  initialSelection: _estadoCivilController.text,
                  onSelected: (value) => _estadoCivilController.text = value ?? ClientesEstadoCivil.$1.formatToString(),
                  dropdownMenuEntries: [
                    DropdownMenuEntry(value: ClientesEstadoCivil.$1.formatToString(), label: 'Solteiro(a)'),
                    DropdownMenuEntry(value: ClientesEstadoCivil.$2.formatToString(), label: 'Casado(a)'),
                    DropdownMenuEntry(value: ClientesEstadoCivil.$3.formatToString(), label: 'Separado(a)'),
                    DropdownMenuEntry(value: ClientesEstadoCivil.$4.formatToString(), label: 'Divorciado(a)'),
                    DropdownMenuEntry(value: ClientesEstadoCivil.$5.formatToString(), label: 'Viúvo(a)'),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                DropdownMenu(
                  width: MediaQuery.of(context).size.width / 2 - 15,
                  label: const Text('Gênero'),
                  initialSelection: _generoController.text,
                  onSelected: (value) => _generoController.text = value ?? ClientesGenero.$1.formatToString(),
                  dropdownMenuEntries: [
                    DropdownMenuEntry(value: ClientesGenero.$1.formatToString(), label: 'Masculino'),
                    DropdownMenuEntry(value: ClientesGenero.$2.formatToString(), label: 'Feminino'),
                    DropdownMenuEntry(value: ClientesGenero.$3.formatToString(), label: 'Não declarar'),
                  ],
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _docController,
                    decoration: const InputDecoration(
                      label: Text('CPF/CNPJ'),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      CpfOuCnpjFormatter(),
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
                    maxLength: 20,
                    controller: _rgController,
                    decoration: const InputDecoration(
                      label: Text('RG'),
                      counterText: '',
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _aniversarioController,
                    decoration: const InputDecoration(
                      label: Text('Data de Aniversário'),
                      prefixIcon: Icon(Icons.calendar_month),
                    ),
                    readOnly: true,
                    onTap: () async {
                      final aniversario = _aniversarioController.text.split('/');

                      final DateTime? time = await showDatePicker(
                        context: context,
                        firstDate: DateTime(1950),
                        lastDate: DateTime(2100),
                        initialDate:
                            aniversario.length == 3 ? DateTime.tryParse('${aniversario[2]}-${aniversario[1]}-${aniversario[0]}') : DateTime.now(),
                      );

                      if (mounted && time != null) {
                        _aniversarioController.text = DateFormat('dd/MM/yyyy').format(time);
                      }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _celularController,
                    decoration: const InputDecoration(
                      label: Text('Celular'),
                    ),
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      TelefoneInputFormatter(),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    maxLength: 150,
                    controller: _emailController,
                    decoration: const InputDecoration(
                      label: Text('E-mail'),
                      counterText: '',
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Text(
              'Detalhes de Endereço',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _cepController,
                    decoration: const InputDecoration(
                      label: Text('CEP'),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      CepInputFormatter(),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  width: 100,
                  child: TextField(
                    maxLength: 20,
                    controller: _numeroController,
                    decoration: const InputDecoration(
                      label: Text('Número'),
                      counterText: '',
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
                    maxLength: 150,
                    controller: _enderecoController,
                    decoration: const InputDecoration(
                      label: Text('Endereço'),
                      counterText: '',
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
                        controller: _nomeMunicipiosController,
                        decoration: InputDecoration(
                          label: const Text('Município'),
                          suffixIcon: _idMunicipiosController.text == '0'
                              ? IconButton(
                                  onPressed: () => controller.openView(),
                                  icon: const Icon(Icons.arrow_drop_down),
                                )
                              : IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _idMunicipiosController.text = '0';
                                      _nomeMunicipiosController.text = 'Selecione um Município';
                                      controller.clear();
                                    });
                                  },
                                  icon: const Tooltip(
                                    message: 'Limpar campo de Município!',
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

                      final res = await context.read<GlobalProvider>().readMunicipios(
                            context,
                            search,
                            '',
                          );

                      return [
                        if (search == '') ...[
                          ListTile(
                            onTap: () {
                              _idMunicipiosController.text = '0';
                              _nomeMunicipiosController.text = 'Selecione um Município';
                              controller.closeView('');
                            },
                            leading: const SizedBox(),
                            title: const Text('Selecione um Município', maxLines: 1, overflow: TextOverflow.ellipsis),
                          ),
                        ],
                        ...(res ?? []).map(
                          (e) => ListTile(
                            onTap: () {
                              _idMunicipiosController.text = e.id;
                              _nomeMunicipiosController.text = e.nome;
                              controller.closeView(e.nome);
                            },
                            leading: const Icon(Icons.location_on_outlined),
                            title: Text(e.nome, maxLines: 1, overflow: TextOverflow.ellipsis),
                            subtitle: Text(e.uf),
                          ),
                        ),
                      ];
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    maxLines: 4,
                    maxLength: 200,
                    controller: _obsController,
                    decoration: const InputDecoration(
                      label: Text('Observações'),
                      constraints: BoxConstraints(minHeight: 100),
                      alignLabelWithHint: true,
                      counterText: '',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
