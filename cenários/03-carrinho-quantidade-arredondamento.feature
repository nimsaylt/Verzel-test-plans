# language: pt
@carrinho
Funcionalidade: Carrinho, limite de quantidade e arredondamento (VZS-142)
  Como cliente da Verzel Store
  Quero montar meu carrinho com valores corretos
  Para saber exatamente quanto vou pagar

  Contexto:
    Dado que estou na Verzel Store com o carrinho vazio

  @CT-19 @CA10 @ui @api
  Cenário: Cinco unidades do mesmo produto são permitidas
    Dado que adicionei ao carrinho 5 unidades de "Garrafa Térmica 750ml"
    Então a quantidade de "Garrafa Térmica 750ml" é 5
    E o subtotal exibido é "R$ 250,00"
    E o total exibido é "R$ 250,00"

  @CT-20 @CA10 @ui @ambiguidade @AMB-06
  Cenário: A sexta unidade do mesmo produto não é aceita na interface
    Dado que adicionei ao carrinho 5 unidades de "Garrafa Térmica 750ml"
    Quando tento aumentar a quantidade de "Garrafa Térmica 750ml"
    Então a quantidade de "Garrafa Térmica 750ml" continua 5
    E o subtotal exibido continua "R$ 250,00"
    # Registrar se há mensagem ou o botão fica desabilitado

  @CT-21 @CA10 @ui @ambiguidade @AMB-06
  Cenário: Adições repetidas pela lista de produtos respeitam o limite acumulado
    Quando clico 6 vezes em "Adicionar ao carrinho" do produto "Boné Aba Curva"
    Então a quantidade de "Boné Aba Curva" no carrinho é 5
    E o subtotal exibido é "R$ 249,50"

  @CT-22 @CA10 @ui
  Cenário: O limite de 5 unidades vale por produto, não pelo carrinho todo
    Dado que adicionei ao carrinho 5 unidades de "Garrafa Térmica 750ml"
    Quando adiciono 5 unidades de "Kit 3 Pares de Meias"
    Então o carrinho contém 5 unidades de "Garrafa Térmica 750ml" e 5 unidades de "Kit 3 Pares de Meias"
    E o subtotal exibido é "R$ 399,50"

  @CT-23 @ui
  Cenário: Alterar a quantidade ou remover um item atualiza os valores
    Dado que adicionei ao carrinho 2 unidades de "Mochila Urbana 20L" e 1 unidade de "Boné Aba Curva"
    Quando reduzo a quantidade de "Mochila Urbana 20L" para 1
    Então o subtotal exibido é "R$ 149,90"
    Quando removo "Boné Aba Curva" do carrinho
    Então o subtotal exibido é "R$ 100,00"
    E o total exibido é "R$ 119,90"

  # Em ponto flutuante: 139.9*3 = 419.70000000000005 e 29.9*3 = 89.69999999999999
  @CT-24 @CA11 @ui @api
  Esquema do Cenário: Valores sem cupom têm 2 casas decimais, sem resíduos de ponto flutuante
    Dado que adicionei ao carrinho 3 unidades de "<produto>"
    Então o subtotal exibido é "<subtotal>"
    E o total exibido é "<total>"
    E nenhum valor monetário da resposta da API possui mais de 2 casas decimais

    Exemplos:
      | produto               | subtotal  | total     |
      | Calça Jeans Slim      | R$ 419,70 | R$ 419,70 |
      | Kit 3 Pares de Meias  | R$ 89,70  | R$ 109,60 |

  @CT-24 @CA11 @ui @api
  Esquema do Cenário: Valores com cupom têm 2 casas decimais, sem resíduos de ponto flutuante
    Dado que adicionei ao carrinho 3 unidades de "<produto>"
    Quando aplico o cupom "BEMVINDO10"
    Então o subtotal exibido é "<subtotal>"
    E o desconto exibido é "<desconto>"
    E o total exibido é "<total>"
    E nenhum valor monetário da resposta da API possui mais de 2 casas decimais

    Exemplos:
      | produto               | subtotal  | desconto | total     |
      | Calça Jeans Slim      | R$ 419,70 | R$ 41,97 | R$ 377,73 |
      | Kit 3 Pares de Meias  | R$ 89,70  | R$ 8,97  | R$ 100,63 |

  @CT-25 @ui @ambiguidade @AMB-16
  Cenário: O contador do menu "Carrinho" reflete o conteúdo do carrinho
    Dado que o contador do menu "Carrinho" mostra 0
    Quando adiciono 2 unidades de "Boné Aba Curva" e 1 unidade de "Camiseta Essencial"
    Então o contador do menu "Carrinho" mostra 3
    # Interpretação: soma de unidades; registrar se mostra 2 (produtos distintos)

  @CT-26 @ui @ambiguidade @AMB-15
  Cenário: O carrinho persiste ao recarregar a mesma aba e começa vazio em outra aba
    Dado que adicionei ao carrinho 1 unidade de "Camiseta Essencial"
    Quando recarrego a página
    Então o carrinho continua com 1 unidade de "Camiseta Essencial"
    Quando abro a loja em outra aba do navegador
    Então o carrinho está vazio
    
  @CT-27 @ui @api
  Cenário: O catálogo exibe os 8 produtos com nome e preço corretos
    Quando acesso a página de produtos
    Então vejo 8 produtos
    E cada produto exibe nome e preço iguais aos do endpoint "GET /api/produtos"
    E os preços são exibidos no formato "R$ 59,90"
