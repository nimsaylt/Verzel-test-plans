# language: pt
@api
Funcionalidade: Contrato da API e códigos de erro
  Como QA
  Quero validar o contrato da API da Verzel Store
  Para garantir que cálculos, validações e erros seguem a documentação

  # Base: /api  |  Content-Type: application/json  |  Valores monetários em reais (59.9 = R$ 59,90)
  # Formato de erro: { "erro": { "codigo": "...", "mensagem": "...", "campo": "..." } }

  @CT-38 @smoke
  Cenário: Listar produtos
    Quando envio GET "/api/produtos"
    Então o status da resposta é 200
    E a resposta é uma lista com 8 produtos
    E cada produto possui "id", "nome", "descricao", "categoria" e "preco"
    E os preços de P001 a P008 são 59.9, 139.9, 189.9, 49.9, 100, 29.9, 229.9 e 50

  @CT-39
  Cenário: Consultar produto existente
    Quando envio GET "/api/produtos/P001"
    Então o status da resposta é 200
    E "nome" é "Camiseta Essencial" e "preco" é 59.9

  @CT-40 @ambiguidade @AMB-19
  Esquema do Cenário: Consultar produto inexistente
    Quando envio GET "/api/produtos/<id>"
    Então o status da resposta é <status>
    E "erro.codigo" é "<codigo>"

    Exemplos:
      | id   | status | codigo                |
      | P999 | 404    | PRODUTO_NAO_ENCONTRADO |
      | P000 | 404    | PRODUTO_NAO_ENCONTRADO |

    # Variante a registrar sem classificar como bug: GET /api/produtos/p001 (minúsculo)

  @CT-41 @CA03 @CA04
  Esquema do Cenário: Cálculo com cupom inválido ou expirado não gera erro
    Quando envio POST "/api/carrinho/calcular" com 1 unidade de "P005" e cupom "<cupom>"
    Então o status da resposta é 200
    E "desconto" é 0 e "total" é 119.9
    E "cupom.aplicado" é false
    E "cupom.mensagem" é "<mensagem>"

    Exemplos:
      | cupom      | mensagem          |
      | DESCONTO50 | Cupom inválido.   |
      | VERAO2026  | Cupom expirado.   |

  @CT-42 @CA10 @automatizar
  Cenário: Cinco unidades do mesmo produto são aceitas pela API
    Quando envio POST "/api/carrinho/calcular" com 5 unidades de "P008"
    Então o status da resposta é 200
    E "subtotal" é 250
    E "frete" é 0
    E "total" é 250

  @CT-42 @CA10 @automatizar
  Esquema do Cenário: Mais de 5 unidades do mesmo produto são rejeitadas pela API
    Quando envio POST "/api/carrinho/calcular" com <quantidade> unidades de "P008"
    Então o status da resposta é 422
    E "erro.codigo" é "QUANTIDADE_MAXIMA_EXCEDIDA"
    E "erro.campo" é "itens[0].quantidade"

    Exemplos:
      | quantidade |
      | 6          |
      | 100        |

  @CT-42 @CA10
  Cenário: O limite de 5 unidades também vale na confirmação do pedido
    Quando envio um pedido com cliente válido e 6 unidades de "P008"
    Então o status da resposta é 422
    E "erro.codigo" é "QUANTIDADE_MAXIMA_EXCEDIDA"

  @CT-43 @ambiguidade @AMB-08
  Esquema do Cenário: Quantidade que não é inteiro maior ou igual a 1
    Quando envio POST "/api/carrinho/calcular" com "quantidade" igual a <valor> para "P001"
    Então o status da resposta é 422
    E "erro.codigo" é "QUANTIDADE_INVALIDA"
    E "erro.campo" é "itens[0].quantidade"

    Exemplos:
      | valor           |
      | 0               |
      | -1              |
      | 1.5             |
      | "2" (texto)     |
      | null            |
      | (campo ausente) |

  @CT-44
  Esquema do Cenário: Lista de itens ausente ou vazia
    Quando envio POST "/api/carrinho/calcular" com <corpo>
    Então o status da resposta é 422
    E "erro.codigo" é "ITENS_OBRIGATORIOS"

    Exemplos:
      | corpo                          |
      | { "itens": [] }                |
      | { "cupom": "BEMVINDO10" }      |

  @CT-45
  Esquema do Cenário: Item que não é um objeto com produtoId e quantidade
    Quando envio POST "/api/carrinho/calcular" com itens igual a <itens>
    Então o status da resposta é 422
    E "erro.codigo" é "ITEM_INVALIDO"

    Exemplos:
      | itens                            |
      | ["P001"]                         |
      | [{ "quantidade": 1 }]            |
      | [{ "produtoId": "P001" }]        |

  @CT-46
  Cenário: Item com produto inexistente
    Quando envio POST "/api/carrinho/calcular" com 1 unidade de "P999"
    Então o status da resposta é 422
    E "erro.codigo" é "PRODUTO_NAO_ENCONTRADO"
    # Atenção: aqui é 422, enquanto GET /api/produtos/P999 retorna 404 (CT-40)

  @CT-47
  Cenário: Mesmo produto repetido na lista de itens
    Quando envio POST "/api/carrinho/calcular" com os itens P001 x2 e P001 x1
    Então o status da resposta é 422
    E "erro.codigo" é "ITEM_DUPLICADO"

  @CT-48 @ambiguidade @AMB-18
  Esquema do Cenário: Corpo da requisição que não é um JSON válido
    Quando envio POST "/api/carrinho/calcular" com o corpo <corpo>
    Então o status da resposta é 400
    E "erro.codigo" é "JSON_INVALIDO"

    # Observação: sem o cabeçalho Content-Type, registrar o comportamento (qualquer 5xx seria bug)
    Exemplos:
      | corpo                    |
      | { itens: [ }             |
      | texto simples            |

  @CT-49
  Esquema do Cenário: Método HTTP não permitido em rota existente
    Quando envio <metodo> "<rota>"
    Então o status da resposta é 405
    E "erro.codigo" é "METODO_NAO_PERMITIDO"

    Exemplos:
      | metodo | rota                    |
      | GET    | /api/carrinho/calcular  |
      | GET    | /api/pedidos            |
      | POST   | /api/produtos           |
      | DELETE | /api/produtos/P001      |

  @CT-50
  Cenário: Rota inexistente
    Quando envio GET "/api/rota-que-nao-existe"
    Então o status da resposta é 404
    E "erro.codigo" é "ROTA_NAO_ENCONTRADA"

  @CT-51 @ambiguidade @AMB-13
  Cenário: Erro de validação de item segue o formato padrão
    Quando envio POST "/api/carrinho/calcular" com 6 unidades de "P008"
    Então o status da resposta é 422
    E a resposta contém "erro.codigo", "erro.mensagem" e "erro.campo"

  @CT-51 @ambiguidade @AMB-13
  Cenário: Erro de dados do cliente informa os detalhes em "campos"
    Quando envio POST "/api/pedidos" com cliente de nome "Maria", e-mail "maria@exemplo.com", CEP "01310-100" e 1 unidade de "P005"
    Então o status da resposta é 422
    E "erro.codigo" é "DADOS_INVALIDOS"
    E "erro.mensagem" não está vazia
    E os detalhes dos dados inválidos vêm em "campos"

  @CT-52
  Cenário: O cálculo não grava nada e repetir a mesma chamada devolve o mesmo resultado
    Dado que enviei POST "/api/carrinho/calcular" com 1 unidade de "P005" e cupom "BEMVINDO10"
    Quando envio exatamente a mesma requisição novamente
    Então a resposta é idêntica à anterior
    E nenhum número de pedido é gerado pelo cálculo
