# language: pt
@pedido
Funcionalidade: Finalização do pedido e validação dos dados do cliente
  Como cliente da Verzel Store
  Quero confirmar meu pedido com cupom e frete calculados
  Para receber minha compra pagando na entrega

  # Regras pré-existentes: nome com sobrenome, e-mail válido, CEP com 8 dígitos (com ou sem hífen).
  # Pagamento na entrega; não há pagamento online nem consulta de pedidos (fora do escopo).

  Contexto:
    Dado que estou na Verzel Store com o carrinho vazio

  @CT-28 @ui @smoke
  Cenário: Confirmar um pedido válido sem cupom
    Dado que adicionei ao carrinho 1 unidade de "Mochila Urbana 20L"
    Quando finalizo o pedido com nome "Maria Silva", e-mail "maria@exemplo.com" e CEP "01310-100"
    Então vejo a confirmação do pedido com número no formato "VZ-" seguido de 6 dígitos
    E o resumo exibido tem subtotal "R$ 100,00", frete "R$ 19,90" e total "R$ 119,90"

  @CT-29 @api @CA01 @CA09 @automatizar
  Cenário: Criar pedido via API com cupom devolve o mesmo resumo do cálculo
    Quando envio POST "/api/pedidos" com o corpo:
      """
      {
        "cliente": { "nome": "Maria Silva", "email": "maria@exemplo.com", "cep": "01310-100" },
        "itens": [ { "produtoId": "P005", "quantidade": 1 } ],
        "cupom": "BEMVINDO10"
      }
      """
    Então o status da resposta é 201
    E "numero" segue o formato "^VZ-[0-9]{6}$"
    E "criadoEm" é uma data e hora no formato ISO 8601
    E "cliente.cep" é "01310100"
    E "subtotal" é 100 e "desconto" é 10
    E "frete" é 19.9 e "freteGratis" é false
    E "valorFaltanteFreteGratis" é 100
    E "total" é 109.9
    E "cupom.aplicado" é true

  @CT-30 @ui @api @ambiguidade @AMB-10   BUG
  Esquema do Cenário: Nome sem sobrenome é rejeitado
    Dado que adicionei ao carrinho 1 unidade de "Mochila Urbana 20L"
    Quando finalizo o pedido com nome "<nome>", e-mail "maria@exemplo.com" e CEP "01310-100"
    Então o pedido é rejeitado com erro de validação no campo "nome"

    Exemplos:
      | nome    |
      | Maria   |
      | Maria␣  |
      | (vazio) |

  @CT-31 @ui @api @ambiguidade @AMB-11
  Cenário: E-mail com formato válido é aceito
    Dado que adicionei ao carrinho 1 unidade de "Mochila Urbana 20L"
    Quando finalizo o pedido com nome "Maria Silva", e-mail "maria@exemplo.com" e CEP "01310-100"
    Então o pedido é confirmado

  @CT-31 @ui @api @ambiguidade @AMB-11
  Esquema do Cenário: E-mail com formato inválido é rejeitado
    Dado que adicionei ao carrinho 1 unidade de "Mochila Urbana 20L"
    Quando finalizo o pedido com nome "Maria Silva", e-mail "<email>" e CEP "01310-100"
    Então o pedido é rejeitado com erro de validação no campo "email"

    Exemplos:
      | email             |
      | maria.exemplo.com |
      | maria@            |
      | @exemplo.com      |
      | maria@exemplo     |

  @CT-32 @ui @api
  Esquema do Cenário: CEP com 8 dígitos, com ou sem hífen, é aceito
    Dado que adicionei ao carrinho 1 unidade de "Mochila Urbana 20L"
    Quando finalizo o pedido com nome "Maria Silva", e-mail "maria@exemplo.com" e CEP "<cep>"
    Então o pedido é confirmado

    Exemplos:
      | cep       |
      | 01310-100 |
      | 01310100  |

  @CT-32 @ui @api
  Esquema do Cenário: CEP que não tem exatamente 8 dígitos é rejeitado
    Dado que adicionei ao carrinho 1 unidade de "Mochila Urbana 20L"
    Quando finalizo o pedido com nome "Maria Silva", e-mail "maria@exemplo.com" e CEP "<cep>"
    Então o pedido é rejeitado com erro de validação no campo "cep"

    Exemplos:
      | cep       |
      | 0131010   |
      | 013101000 |
      | 0131010A  |

  @CT-32 @ui @api @ambiguidade @AMB-12
  Cenário: CEP com hífen fora da posição esperada é rejeitado
    Dado que adicionei ao carrinho 1 unidade de "Mochila Urbana 20L"
    Quando finalizo o pedido com nome "Maria Silva", e-mail "maria@exemplo.com" e CEP "013101-00"
    Então o pedido é rejeitado com erro de validação no campo "cep"

  @CT-33 @api @CA03 @CA04
  Esquema do Cenário: Pedido com cupom inexistente ou expirado é rejeitado (diferente do cálculo)
    Quando envio um pedido com cliente válido, 1 unidade de "P005" e o cupom "<cupom>"
    Então o status da resposta é 422
    E "erro.codigo" é "<codigo>"

    Exemplos:
      | cupom      | codigo         |
      | DESCONTO50 | CUPOM_INVALIDO |
      | VERAO2026  | CUPOM_EXPIRADO |

  # Convenção: "␣" representa um espaço em branco
  @CT-34 @api @CA02 @ambiguidade @AMB-04
  Esquema do Cenário: Pedido aceita o cupom sem diferenciar caixa e ignorando espaços nas pontas
    Quando envio um pedido com cliente válido, 1 unidade de "P005" e o cupom "<cupom>"
    Então o status da resposta é 201
    E "desconto" é 10
    E "total" é 109.9

    Exemplos:
      | cupom        |
      | bemvindo10   |
      | ␣␣BEMVINDO10␣ |

  @CT-35 @ui @api @ambiguidade @AMB-14
  Cenário: Não é possível finalizar um pedido com o carrinho vazio
    Quando tento finalizar o pedido na UI com o carrinho vazio
    Então a finalização não é permitida
    Quando envio POST "/api/pedidos" com cliente válido e "itens" vazio
    Então o status da resposta é 422
    E "erro.codigo" é "ITENS_OBRIGATORIOS"

  # "(nenhum)" significa que nenhum cupom é informado
  @CT-36 @ui @api @smoke
  Esquema do Cenário: UI e API exibem os mesmos valores para o mesmo carrinho
    Dado que adicionei ao carrinho <itens> na interface
    E que o cupom informado é "<cupom>"
    Quando envio POST "/api/carrinho/calcular" com os mesmos itens e cupom
    Então subtotal, desconto, frete, valor faltante e total da API são iguais aos exibidos no carrinho

    Exemplos:
      | itens                               | cupom      |
      | 1 unidade de "Mochila Urbana 20L"   | BEMVINDO10 |
      | 4 unidades de "Boné Aba Curva"      | (nenhum)   |
      | 1 unidade de "Jaqueta Corta-Vento"  | BEMVINDO10 |

  @CT-37 @ui
  Cenário: O fluxo não tem etapa de pagamento online
    Dado que adicionei ao carrinho 1 unidade de "Mochila Urbana 20L"
    Quando finalizo o pedido com dados válidos
    Então não é solicitado nenhum dado de pagamento
    E a confirmação do pedido é exibida
