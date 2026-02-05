class ApiRoutes {
  // AUTHENTICATION
  static String login() => '/login';
  static String logout() => '/logout';
  // GLOBAL
  static String globalReadMunicipios(String search, String uf) => '/global_read_municipios?search=$search&uf=$uf';
  static String globalReadFornecedores(String search) => '/global_read_fornecedores?search=$search';
  static String globalReadCategoriasProdutos(String search) => '/global_read_categorias_produtos?search=$search';
  static String globalReadDespesas(String search) => '/global_read_despesas?search=$search';
  static String globalReadClientes(String search) => '/global_read_clientes?search=$search';
  static String globalReadHfEscolas(String search) => '/global_read_hf_escolas?search=$search';
  static String globalReadMarcasProdutos(String search) => '/global_read_marcas_produtos?search=$search';
  static String globalInsertFornecedores() => '/global_insert_fornecedores';
  static String globalInsertCategoriasProdutos() => '/global_insert_categorias_produtos';
  static String globalInsertDespesas() => '/global_insert_despesas';
  static String globalInsertClientes() => '/global_insert_clientes';
  static String globalInsertHfEscolas() => '/global_insert_hf_escolas';
  static String globalInsertMarcasProdutos() => '/global_insert_marcas_produtos';
  // HOME
  static String home() => '/home';
  // CLIENTES
  static String clientesRead(String search, int page, int limit) => '/clientes/read?search=$search&page=$page&limit=$limit';
  static String clientesInsert() => '/clientes/insert';
  static String clientesDelete() => '/clientes/delete';
  static String clientesReadById(String id) => '/clientes/read_by_id?id=$id';
  // PRODUTOS
  static String produtosRead(String search, int page, int limit) => '/produtos/read?search=$search&page=$page&limit=$limit';
  static String produtosInsert() => '/produtos/insert';
  static String produtosDelete() => '/produtos/delete';
  static String produtosReadById(String id) => '/produtos/read_by_id?id=$id';
  static String produtosInsertBaixaEstoque() => '/produtos/insert_baixa_estoque';
  static String produtosReadByBarsCode() => '/produtos/read_by_bars_code';
  // AGENDA
  static String agendaRead(String search, int page, int limit) => '/agenda/read?search=$search&page=$page&limit=$limit';
  static String agendaInsert() => '/agenda/insert';
  static String agendaDelete() => '/agenda/delete';
  static String agendaReadById(String id) => '/agenda/read_by_id?id=$id';
  // USUARIOS
  static String usuariosRead(String search, int page, int limit) => '/usuarios/read?search=$search&page=$page&limit=$limit';
  static String usuariosInsert() => '/usuarios/insert';
  static String usuariosDelete() => '/usuarios/delete';
  static String usuariosReadById(String id) => '/usuarios/read_by_id?id=$id';
  // FORNECEDORES
  static String fornecedoresRead(String search, int page, int limit) => '/fornecedores/read?search=$search&page=$page&limit=$limit';
  static String fornecedoresInsert() => '/fornecedores/insert';
  static String fornecedoresDelete() => '/fornecedores/delete';
  static String fornecedoresReadById(String id) => '/fornecedores/read_by_id?id=$id';
  // CATEGORIAS PRODUTOS
  static String categoriasProdutosRead(String search, int page, int limit) => '/categorias_produtos/read?search=$search&page=$page&limit=$limit';
  static String categoriasProdutosInsert() => '/categorias_produtos/insert';
  static String categoriasProdutosDelete() => '/categorias_produtos/delete';
  static String categoriasProdutosReadById(String id) => '/categorias_produtos/read_by_id?id=$id';
  // DESPESAS
  static String despesasRead(String search, int page, int limit) => '/despesas/read?search=$search&page=$page&limit=$limit';
  static String despesasInsert() => '/despesas/insert';
  static String despesasDelete() => '/despesas/delete';
  static String despesasReadById(String id) => '/despesas/read_by_id?id=$id';
  // Contas a Pagar
  static String contasPagarRead(String search, int page, int limit, String startDate, String endDate, String status) =>
      '/contas_pagar/read?search=$search&page=$page&limit=$limit&start_date=$startDate&end_date=$endDate&status=$status';
  static String contasPagarInsert() => '/contas_pagar/insert';
  static String contasPagarDelete() => '/contas_pagar/delete';
  static String contasPagarReadById(String id) => '/contas_pagar/read_by_id?id=$id';
  static String contasPagarWriteOff() => '/contas_pagar/write_off';
  static String contasPagarParcelling() => '/contas_pagar/parcelling';
  // Contas a Receber
  static String contasReceberRead(String search, int page, int limit, String startDate, String endDate, String status) =>
      '/contas_receber/read?search=$search&page=$page&limit=$limit&start_date=$startDate&end_date=$endDate&status=$status';
  static String contasReceberInsert() => '/contas_receber/insert';
  static String contasReceberDelete() => '/contas_receber/delete';
  static String contasReceberReadById(String id) => '/contas_receber/read_by_id?id=$id';
  static String contasReceberWriteOff() => '/contas_receber/write_off';
  static String contasReceberParcelling() => '/contas_receber/parcelling';
  // MARCAS PRODUTOS
  static String marcasProdutosRead(String search, int page, int limit) => '/marcas_produtos/read?search=$search&page=$page&limit=$limit';
  static String marcasProdutosInsert() => '/marcas_produtos/insert';
  static String marcasProdutosDelete() => '/marcas_produtos/delete';
  static String marcasProdutosReadById(String id) => '/marcas_produtos/read_by_id?id=$id';
  // VENDAS
  static String vendasRead(String search, int page, int limit, String startDate, String endDate, String status, String idClientes) =>
      '/vendas/read?search=$search&page=$page&limit=$limit&start_date=$startDate&end_date=$endDate&status=$status&id_clientes=$idClientes';
  static String vendasInsert() => '/vendas/insert';
  static String vendasDelete() => '/vendas/delete';
  static String vendasReadById(String id) => '/vendas/read_by_id?id=$id';
  static String vendasReadForFinalize(String id) => '/vendas/read_for_finalize?id=$id';
  static String vendasFinalize() => '/vendas/finalize';
  static String vendasReadForDetails(String id) => '/vendas/read_for_details?id=$id';
}
