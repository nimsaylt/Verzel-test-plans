# language: pt
@frete
Funcionalidade: Frete fixo e frete grátis (VZS-142)
  Como cliente da Verzel Store
  Quero ganhar frete grátis em compras maiores
  Para pagar menos nas minhas compras

  # Regra: frete grátis com subtotal >= R$ 200,00 (antes do cupom); abaixo disso, R$ 19,90.

  Contexto:
    Dado que estou na Verzel Store com o carrinho vazio

  @CT-12 @CA07 @ui @api
  Esquema do Cenário: Abaixo de R$ 200,00 cobra frete fixo e informa quanto falta
    Dado que adicionei ao carrinho <itens>
    Então o subtotal exibido é "<subtotal>"
    E o frete exibido é "R$ 19,90"
    E o carrinho informa que faltam "<faltante>" para o frete grátis
    E o total exibido é "<total>"

    Exemplos:
      | itens                           | subtotal  | faltante  | total     |
      | 1 unidade de "Mochila Urbana 20L"     | R$ 100,00 | R$ 100,00 | R$ 119,90 |
      | 1 unidade de "Boné Aba Curva"         | R$ 49,90  | R$ 150,10 | R$ 69,80  |
      | 5 unidades de "Kit 3 Pares de Meias"  | R$ 149,50 | R$ 50,50  | R$ 169,40 |
      | 1 unidade de "Tênis Casual Urbano"    | R$ 189,90 | R$ 10,10  | R$ 209,80 |

  @CT-13 @CA06 @api @ui @automatizar    BUG
  Esquema do Cenário: Subtotal exatamente igual a R$ 200,00 tem frete grátis (limite inclusivo)
    Dado que adicionei ao carrinho <itens>
    Então o subtotal exibido é "R$ 200,00"
    E o frete exibido é "R$ 0,00"
    E o carrinho não informa valor faltante para o frete grátis
    E o total exibido é "R$ 200,00"

    Exemplos:
      | itens                                                              |
      | 2 unidades de "Mochila Urbana 20L"                                 |
      | 1 unidade de "Mochila Urbana 20L" e 2 unidades de "Garrafa Térmica 750ml" |
      | 4 unidades de "Garrafa Térmica 750ml"                              |

  @CT-14 @CA06 @CA07 @api @ui
  Esquema do Cenário: Logo abaixo do limite ainda cobra frete
    Dado que adicionei ao carrinho <itens>
    Então o subtotal exibido é "<subtotal>"
    E o frete exibido é "R$ 19,90"
    E o carrinho informa que faltam "<faltante>" para o frete grátis
    E o total exibido é "<total>"

    Exemplos:
      | itens                                                        | subtotal  | faltante | total     |
      | 1 unidade de "Camiseta Essencial" e 1 de "Calça Jeans Slim"  | R$ 199,80 | R$ 0,20  | R$ 219,70 |
      | 4 unidades de "Boné Aba Curva"                               | R$ 199,60 | R$ 0,40  | R$ 219,50 |

  @CT-15 @CA06 @ui @api
  Cenário: Acima de R$ 200,00 o frete é grátis
    Dado que adicionei ao carrinho 1 unidade de "Jaqueta Corta-Vento"
    Então o subtotal exibido é "R$ 229,90"
    E o frete exibido é "R$ 0,00"
    E o total exibido é "R$ 229,90"

  @CT-16 @CA08 @api @ui @automatizar
  Esquema do Cenário: O frete grátis considera o subtotal antes do desconto do cupom
    Dado que adicionei ao carrinho <itens>
    Quando aplico o cupom "BEMVINDO10"
    Então o subtotal exibido é "<subtotal>"
    E o desconto exibido é "<desconto>"
    E o frete exibido é "R$ 0,00"
    E o total exibido é "<total>"

    # Em ambos os casos o total final fica abaixo de R$ 200,00 e o frete continua grátis
    Exemplos:
      | itens                                                    | subtotal  | desconto | total     |
      | 1 unidade de "Tênis Casual Urbano" e 1 de "Kit 3 Pares de Meias" | R$ 219,80 | R$ 21,98 | R$ 197,82 |

  @CT-17 @CA07 @CA08 @api @ui
  Cenário: Abaixo do limite com cupom, o valor faltante usa o subtotal antes do desconto
    Dado que adicionei ao carrinho 4 unidades de "Boné Aba Curva"
    Quando aplico o cupom "BEMVINDO10"
    Então o subtotal exibido é "R$ 199,60"
    E o desconto exibido é "R$ 19,96"
    E o frete exibido é "R$ 19,90"
    E o carrinho informa que faltam "R$ 0,40" para o frete grátis
    E o total exibido é "R$ 199,54"

  @CT-18 @CA06 @CA07 @ui
  Cenário: O aviso de frete muda ao ultrapassar o limite e volta ao reduzir o carrinho
    Dado que adicionei ao carrinho 1 unidade de "Mochila Urbana 20L"
    E que o carrinho informa que faltam "R$ 100,00" para o frete grátis
    Quando adiciono mais 1 unidade de "Mochila Urbana 20L"
    Então o frete exibido é "R$ 0,00"
    E o carrinho não informa valor faltante para o frete grátis
    Quando removo 1 unidade de "Mochila Urbana 20L"
    Então o frete exibido é "R$ 19,90"
    E o carrinho informa que faltam "R$ 100,00" para o frete grátis
