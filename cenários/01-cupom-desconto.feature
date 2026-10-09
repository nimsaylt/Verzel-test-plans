# language: pt
@cupom
Funcionalidade: Cupom de desconto no carrinho (VZS-142)
  Como cliente da Verzel Store
  Quero aplicar um cupom de desconto no carrinho
  Para pagar menos nas minhas compras

  # Cupons: BEMVINDO10 (10%, válido) e VERAO2026 (15%, expirado em 31/03/2026)

  Contexto:
    Dado que estou na Verzel Store com o carrinho vazio

  @CT-01 @CA01 @CA09 @ui @smoke @automatizar
  Cenário: Aplicar BEMVINDO10 reduz 10% do subtotal dos produtos
    Dado que adicionei ao carrinho 1 unidade de "Calça Jeans Slim" e 2 unidades de "Boné Aba Curva"
    Quando aplico o cupom "BEMVINDO10"
    Então o subtotal exibido é "R$ 239,70"
    E o desconto exibido é "R$ 23,97"
    E o frete exibido é "Grátis"
    E o total exibido é "R$ 215,73"
    E a mensagem do cupom informa que foi aplicado

  @CT-02 @CA01 @CA09 @ui @api
  Cenário: O desconto do cupom não incide sobre o frete
    Dado que adicionei ao carrinho 1 unidade de "Mochila Urbana 20L"
    Quando aplico o cupom "BEMVINDO10"
    Então o subtotal exibido é "R$ 100,00"
    E o desconto exibido é "R$ 10,00"
    E o frete exibido é "R$ 19,90"
    E o total exibido é "R$ 109,90"

  @CT-03 @CA02 @ui @api
  Esquema do Cenário: O código do cupom não diferencia maiúsculas de minúsculas
    Dado que adicionei ao carrinho 1 unidade de "Mochila Urbana 20L"
    Quando aplico o cupom "<codigo>"
    Então o desconto exibido é "R$ 10,00"
    E o total exibido é "R$ 109,90"

    Exemplos:
      | codigo     |
      | bemvindo10 |
      | BemVindo10 |
      | bEmViNdO10 |

  # Convenção: "␣" representa um espaço em branco nos exemplos
  @CT-04 @CA02 @ui @api
  Esquema do Cenário: Espaços no início e no fim do código são ignorados
    Dado que adicionei ao carrinho 1 unidade de "Mochila Urbana 20L"
    Quando aplico o cupom "<codigo>"
    Então o desconto exibido é "R$ 10,00"
    E o total exibido é "R$ 109,90"

    Exemplos:
      | codigo         |
      | ␣␣BEMVINDO10   |
      | BEMVINDO10␣␣   |
      | ␣␣bemvindo10␣␣ |

  @CT-05 @CA03 @ui @api
  Esquema do Cenário: Cupom inexistente exibe "Cupom inválido." e não aplica desconto
    Dado que adicionei ao carrinho 1 unidade de "Mochila Urbana 20L"
    Quando aplico o cupom "<codigo>"
    Então a mensagem do cupom é "Cupom inválido."
    E o desconto exibido é "R$ 0,00"
    E o total exibido é "R$ 119,90"

    Exemplos:
      | codigo      |
      | DESCONTO50  |
      | BEMVINDO    |
      | BEMVINDO100 |

  @CT-06 @CA04 @ui @api @automatizar
  Esquema do Cenário: Cupom expirado exibe "Cupom expirado." e não aplica desconto
    Dado que adicionei ao carrinho 1 unidade de "Mochila Urbana 20L"
    Quando aplico o cupom "<codigo>"
    Então a mensagem do cupom é "Cupom expirado."
    E o desconto exibido é "R$ 0,00"
    E o total exibido é "R$ 119,90"

    Exemplos:
      | codigo    |
      | VERAO2026 |
      | verao2026 |

  @CT-07 @CA05 @ui @ambiguidade @AMB-01
  Cenário: Não é possível aplicar um segundo cupom sem remover o atual
    Dado que adicionei ao carrinho 1 unidade de "Mochila Urbana 20L"
    E que apliquei o cupom "BEMVINDO10"
    Quando tento aplicar o segundo cupom "VERAO2026" sem remover o atual
    Então a interface não permite 
    E o cupom "BEMVINDO10" continua aplicado
    E o desconto exibido continua "R$ 10,00"
  

  @CT-08 @CA05 @ui
  Cenário: Remover o cupom atual e aplicar outro
    Dado que adicionei ao carrinho 1 unidade de "Mochila Urbana 20L"
    E que apliquei o cupom "BEMVINDO10"
    Quando removo o cupom atual
    Então o desconto exibido é "R$ 0,00"
    E o total exibido é "R$ 119,90"
    Quando aplico o cupom "VERAO2026"
    Então a mensagem do cupom é "Cupom expirado."
    E o desconto exibido é "R$ 0,00"

  @CT-09 @CA03 @ui
  Cenário: Um cupom inválido não impede aplicar um cupom válido em seguida
    Dado que adicionei ao carrinho 1 unidade de "Mochila Urbana 20L"
    E que tentei aplicar o cupom "DESCONTO50" e recebi "Cupom inválido."
    Quando aplico o cupom "BEMVINDO10"
    Então o desconto exibido é "R$ 10,00"
    E o total exibido é "R$ 109,90"

  @CT-10 @CA01 @CA06 @ui   BUG
  Cenário: O desconto e o frete são recalculados ao alterar o carrinho com cupom aplicado
    Dado que adicionei ao carrinho 1 unidade de "Mochila Urbana 20L"
    E que apliquei o cupom "BEMVINDO10"
    Quando aumento a quantidade de "Mochila Urbana 20L" para 2
    Então o subtotal exibido é "R$ 200,00"
    E o desconto exibido é "R$ 20,00"
    E o frete exibido é "R$ 0,00"
    E o total exibido é "R$ 180,00"
    Quando reduzo a quantidade de "Mochila Urbana 20L" para 1
    Então o desconto exibido é "R$ 10,00"
    E o frete exibido é "R$ 19,90"
    E o total exibido é "R$ 109,90"

  @CT-11 @CA02 @CA03 @ui @api @ambiguidade @AMB-02
  Cenário: Espaço no meio do código não é ignorado
    Dado que adicionei ao carrinho 1 unidade de "Mochila Urbana 20L"
    Quando aplico o cupom "BEM VINDO10"
    Então a mensagem do cupom é "Cupom inválido."
    E o desconto exibido é "R$ 0,00"
    E o total exibido é "R$ 119,90"

  @CT-53 @CA03 @ui @api @ambiguidade @AMB-03
  Esquema do Cenário: Código vazio ou só com espaços equivale a não informar cupom
    Dado que adicionei ao carrinho 1 unidade de "Mochila Urbana 20L"
    Quando aplico o cupom "<codigo>"
    Então nenhum cupom é aplicado
    E o desconto exibido é "R$ 0,00"
    E o total exibido é "R$ 119,90"
    E nenhum erro de servidor é exibido

