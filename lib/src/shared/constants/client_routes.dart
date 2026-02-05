class ClientRoutes {
  static String login() => '/login';
  static String dashboardHome() => '/dashboard/home';
  static String dashboardClientes() => '/dashboard/clientes';
  static String dashboardClientesInserir({
    required String? id,
    bool clone = false,
  }) {
    if (id == null) return '/dashboard/clientes/inserir';
    return '/dashboard/clientes/inserir?id=$id&clone=$clone';
  }

  static String dashboardProdutos() => '/dashboard/produtos';
  static String dashboardProdutosInserir({
    required String? id,
    bool clone = false,
  }) {
    if (id == null) return '/dashboard/produtos/inserir';
    return '/dashboard/produtos/inserir?id=$id&clone=$clone';
  }
  // agenda
  // agenda
  // agenda
  // agenda
  // agenda
  // agenda
  // agenda
  // static String dashboardProdutos() => '/dashboard/produtos';
  // static String dashboardProdutosInserir({
  //   required String? id,
  //   bool clone = false,
  // }) {
  //   if (id == null) return '/dashboard/produtos/inserir';
  //   return '/dashboard/produtos/inserir?id=$id&clone=$clone';
  // }

  static String dashboardUsuarios() => '/dashboard/usuarios';
  static String dashboardUsuariosInserir({
    required String? id,
    bool clone = false,
  }) {
    if (id == null) return '/dashboard/usuarios/inserir';
    return '/dashboard/usuarios/inserir?id=$id&clone=$clone';
  }

  static String dashboardFornecedores() => '/dashboard/fornecedores';
  static String dashboardFornecedoresInserir({
    required String? id,
    bool clone = false,
  }) {
    if (id == null) return '/dashboard/fornecedores/inserir';
    return '/dashboard/fornecedores/inserir?id=$id&clone=$clone';
  }

  static String dashboardCategoriasProdutos() => '/dashboard/categorias_produtos';
  static String dashboardCategoriasProdutosInserir({
    required String? id,
    bool clone = false,
  }) {
    if (id == null) return '/dashboard/categorias_produtos/inserir';
    return '/dashboard/categorias_produtos/inserir?id=$id&clone=$clone';
  }

  static String dashboardDespesas() => '/dashboard/despesas';
  static String dashboardDespesasInserir({
    required String? id,
    bool clone = false,
  }) {
    if (id == null) return '/dashboard/despesas/inserir';
    return '/dashboard/despesas/inserir?id=$id&clone=$clone';
  }

  static String dashboardContasPagar() => '/dashboard/contas_pagar';
  static String dashboardContasPagarInserir({
    required String? id,
    bool clone = false,
  }) {
    if (id == null) return '/dashboard/contas_pagar/inserir';
    return '/dashboard/contas_pagar/inserir?id=$id&clone=$clone';
  }
  static String dashboardContasPagarDarBaixa({
    required String? id,
  }) {
    if (id == null) return '/dashboard/contas_pagar/dar_baixa';
    return '/dashboard/contas_pagar/dar_baixa?id=$id';
  }
  static String dashboardContasPagarParcelar({
    required String? id,
  }) {
    if (id == null) return '/dashboard/contas_receber/parcelar';
    return '/dashboard/contas_receber/parcelar?id=$id';
  }

  static String dashboardContasReceber() => '/dashboard/contas_receber';
  static String dashboardContasReceberInserir({
    required String? id,
    bool clone = false,
  }) {
    if (id == null) return '/dashboard/contas_receber/inserir';
    return '/dashboard/contas_receber/inserir?id=$id&clone=$clone';
  }
  static String dashboardContasReceberDarbaixa({
    required String? id,
  }) {
    if (id == null) return '/dashboard/contas_receber/dar_baixa';
    return '/dashboard/contas_receber/dar_baixa?id=$id';
  }
  static String dashboardContasReceberParcelar({
    required String? id,
  }) {
    if (id == null) return '/dashboard/contas_receber/parcelar';
    return '/dashboard/contas_receber/parcelar?id=$id';
  }

  static String dashboardVendas() => '/dashboard/vendas';
  static String dashboardVendasInserir({
    required String? id,
    bool clone = false,
  }) {
    if (id == null) return '/dashboard/vendas/inserir';
    return '/dashboard/vendas/inserir?id=$id&clone=$clone';
  }
  static String dashboardVendasFinalizar({
    required String? id,
  }) {
    if (id == null) return '/dashboard/vendas/finalizar';
    return '/dashboard/vendas/finalizar?id=$id';
  }
}
