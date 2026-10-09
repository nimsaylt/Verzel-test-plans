# Plano de Testes — Verzel Store (VZS-142: Cupom de desconto e frete grátis)

## 1. Contexto e objetivo

Este plano cobre o teste técnico de QA Júnior da Verzel. A Verzel Store é uma loja fictícia que recebeu uma nova
entrega, o card **VZS-142 — Cupom de desconto e frete grátis**. O objetivo é validar essa entrega como se fosse o dia a dia de um time de desenvolvimento: levantar cenários a partir da documentação, executá-los, reportar os bugs encontrados, documentar as evidências e automatizar pelo menos 3 cenários com Playwright.


**Aplicações-alvo:**

- **UI** — Verzel Store: https://verzel-store.qa-test-verzel-store.workers.dev/
- **Documentação da entrega** — https://verzel-store.qa-test-verzel-store.workers.dev/documentacao
- **API** — https://verzel-store.qa-test-verzel-store.workers.dev/api 

**Critérios de aceite sob teste:** CA01 a CA11 da documentação

## 2. Escopo

### Dentro do escopo

- Aplicação de cupom no carrinho: BEMVINDO10 (válido), VERAO2026 (expirado) e códigos inexistentes — UI e API
- Regras do código do cupom: caixa, espaços nas pontas, um cupom por vez, remoção e troca — UI
- Frete fixo de R$ 19,90, frete grátis a partir de R$ 200,00 e valor faltante — UI e API
- Frete calculado sobre o subtotal antes do cupom e desconto que não incide sobre o frete — UI e API
- Limite de 5 unidades por produto — UI e API
- Arredondamento dos valores em 2 casas decimais — UI e API
- Confirmação de pedido e validações pré-existentes do cliente (nome e sobrenome, e-mail, CEP) — UI e API
- Catálogo e carrinho (adicionar, alterar quantidade, remover, contador)
- Contrato da API: status, corpo, formato e códigos de erro
- Consistência entre os valores exibidos na UI e os calculados pela API

### Fora do escopo

- Testes de carga, estresse e segurança (regra do teste: o ambiente é compartilhado com outros candidatos)
- Login, cadastro de clientes, pagamento online e consulta de pedidos (fora do escopo da entrega)
- Testes cross-browser e de dispositivos móveis
- Comportamentos listados em "Sobre este ambiente" da documentação, por serem simplificações propositais e
  portanto **não são bugs**: carrinho só na aba, pedidos não armazenados, sem e-mail nem cobrança, produtos e
  cupons fixos sem estoque e API sem estado

## 3. Estratégia de testes (baseada em risco)

A prioridade segue impacto x probabilidade de falha. Erro em valor cobrado ao cliente tem o maior impacto, por isso
os cálculos recebem a maior cobertura. Como a regra está na API (rápida e estável), ela concentra a validação das
regras de negócio; a UI cobre o que o usuário realmente percorre e a consistência com a API.

| Área                                           | Risco (impacto x probabilidade) | Tipo de teste           | Por quê                                                       |
| ---------------------------------------------- | ------------------------------- | ----------------------- | ------------------------------------------------------------- |
| Cálculo de subtotal, desconto, frete e total   | Alto                            | API + E2E (UI)          | Define o valor cobrado; erro afeta todos os pedidos           |
| Limite de frete grátis (R$ 200,00, inclusive)  | Alto                            | API + E2E (UI)          | Regra de borda, propensa a erro de `>` contra `>=`            |
| Cupom: validade, caixa, espaços e troca        | Alto                            | API + E2E (UI)          | Regra central da entrega, com muitas variações de entrada     |
| Frete sobre subtotal antes do cupom (CA08)     | Alto                            | API + E2E (UI)          | Regra sutil, fácil de implementar do jeito errado             |
| Limite de 5 unidades por produto               | Alto                            | API + E2E (UI)          | Regra que deve valer nas duas camadas                         |
| Arredondamento a 2 casas decimais              | Médio                           | API + E2E (UI)          | Risco de resíduos de ponto flutuante nos valores              |
| Confirmação do pedido e erros de cupom         | Alto                            | API + E2E (UI)          | Comportamento diferente do cálculo (422 em vez de 200)        |
| Validação de dados do cliente (pré-existente)  | Médio                           | API + E2E (UI)          | Regressão de regras que já existiam                           |
| Contrato e códigos de erro da API              | Médio                           | API                     | Garante previsibilidade para quem consome a API               |
| Catálogo e carrinho (contador, persistência)   | Baixo                           | E2E (UI)                | Fluxo de apoio; falhas aqui têm menor impacto financeiro      |

**Técnicas aplicadas:** partição de equivalência (cupom válido, expirado e inexistente; quantidades válidas
e inválidas), análise de valor limite (R$ 200,00 e R$ 199,80 / 199,60; 5 e 6 unidades), tabela de decisão
(subtotal x cupom x frete) e teste exploratório por charters para o que a documentação não define.

**Pirâmide de testes:** a maior parte da cobertura fica na API. A UI cobre os caminhos que o
cliente percorre e a consistência com a API. Os cenários são escritos em Gherkin (`cenarios/*.feature`);

## 4. Casos de teste

Os cenários completos, em Gherkin, estão em `cenarios/`. A matriz critério de aceite → cenário está em
`cenarios/MATRIZ_RASTREABILIDADE.md`.

| ID    | Camada  | Cenário                                                                     | Prioridade |
| ----- | ------- | --------------------------------------------------------------------------- | ---------- |
| CT-01 | UI      | Aplicar BEMVINDO10 reduz 10% do subtotal (CA01)                             | Alta       |
| CT-02 | UI/API  | O desconto do cupom não incide sobre o frete (CA09)                         | Alta       |
| CT-03 | UI/API  | O código do cupom não diferencia maiúsculas de minúsculas (CA02)           | Média      |
| CT-04 | UI/API  | Espaços no início e no fim do código são ignorados (CA02)                  | Média      |
| CT-05 | UI/API  | Cupom inexistente exibe "Cupom inválido." e não aplica desconto (CA03)     | Alta       |
| CT-06 | UI/API  | Cupom expirado exibe "Cupom expirado." e não aplica desconto (CA04)        | Alta       |
| CT-07 | UI      | Segundo cupom sem remover o atual não é aplicado (CA05)                     | Média      |
| CT-08 | UI      | Remover o cupom atual e aplicar outro (CA05)                                | Média      |
| CT-09 | UI      | Cupom inválido não impede aplicar um válido em seguida                      | Baixa      |
| CT-10 | UI      | Desconto e frete recalculados ao alterar o carrinho com cupom               | Alta       |
| CT-11 | UI/API  | Espaço no meio do código é tratado como cupom inválido                      | Baixa      |
| CT-12 | UI/API  | Abaixo de R$ 200,00 cobra R$ 19,90 e informa o valor faltante (CA07)       | Alta       |
| CT-13 | API/UI  | Subtotal exatamente R$ 200,00 tem frete grátis (limite inclusivo, CA06)    | Alta       |
| CT-14 | API/UI  | Logo abaixo do limite (R$ 199,80 e R$ 199,60) ainda cobra frete            | Alta       |
| CT-15 | UI/API  | Acima de R$ 200,00 o frete é grátis                                        | Média      |
| CT-16 | API/UI  | O frete grátis usa o subtotal antes do cupom (CA08)                        | Alta       |
| CT-17 | API/UI  | Valor faltante calculado sobre o subtotal antes do desconto                 | Média      |
| CT-18 | UI      | O aviso de frete muda ao cruzar o limite e volta ao reduzir o carrinho     | Média      |
| CT-19 | UI/API  | Cinco unidades do mesmo produto são permitidas (CA10)                       | Alta       |
| CT-20 | UI      | A sexta unidade do mesmo produto não é aceita na interface (CA10)          | Alta       |
| CT-21 | UI      | Adições repetidas pela lista de produtos respeitam o limite acumulado       | Média      |
| CT-22 | UI      | O limite de 5 unidades vale por produto, não pelo carrinho todo             | Média      |
| CT-23 | UI      | Alterar a quantidade ou remover um item atualiza os valores                 | Média      |
| CT-24 | UI/API  | Valores com 2 casas decimais, sem resíduo de ponto flutuante (CA11)        | Alta       |
| CT-25 | UI      | O contador do menu "Carrinho" reflete o conteúdo                            | Baixa      |
| CT-26 | UI      | O carrinho persiste ao recarregar a aba e começa vazio em outra aba         | Baixa      |
| CT-27 | UI/API  | O catálogo exibe os 8 produtos com nome e preço corretos                    | Média      |
| CT-28 | UI      | Confirmar um pedido válido sem cupom                                        | Alta       |
| CT-29 | API     | Criar pedido com cupom devolve o mesmo resumo do cálculo e número VZ-000000 | Alta       |
| CT-30 | UI/API  | Nome do cliente precisa ter nome e sobrenome                                | Média      |
| CT-31 | UI/API  | E-mail precisa ter formato válido                                           | Média      |
| CT-32 | UI/API  | CEP precisa ter 8 dígitos, com ou sem hífen                                 | Média      |
| CT-33 | API     | Pedido com cupom inexistente ou expirado retorna 422                        | Alta       |
| CT-34 | API     | Pedido aceita o cupom sem diferenciar caixa e ignorando espaços             | Média      |
| CT-35 | UI/API  | Não é possível finalizar um pedido com carrinho vazio                       | Média      |
| CT-36 | UI/API  | UI e API exibem os mesmos valores para o mesmo carrinho                     | Alta       |
| CT-37 | UI      | O fluxo não tem etapa de pagamento online                                   | Baixa      |
| CT-38 | API     | Listar produtos (`GET /api/produtos`)                                       | Média      |
| CT-39 | API     | Consultar produto existente                                                 | Baixa      |
| CT-40 | API     | Consultar produto inexistente retorna 404                                   | Média      |
| CT-41 | API     | Cálculo com cupom inválido ou expirado retorna 200 sem desconto             | Alta       |
| CT-42 | API     | Limite de 5 unidades por produto no cálculo e no pedido                     | Alta       |
| CT-43 | API     | Quantidade que não é inteiro maior ou igual a 1                             | Média      |
| CT-44 | API     | Lista de itens ausente ou vazia                                             | Média      |
| CT-45 | API     | Item que não é objeto com produtoId e quantidade                            | Média      |
| CT-46 | API     | Item com produto inexistente retorna 422                                    | Média      |
| CT-47 | API     | Mesmo produto repetido na lista de itens                                    | Média      |
| CT-48 | API     | Corpo que não é um JSON válido retorna 400                                  | Média      |
| CT-49 | API     | Método HTTP não permitido em rota existente retorna 405                     | Baixa      |
| CT-50 | API     | Rota inexistente retorna 404                                                | Baixa      |
| CT-51 | API     | Erros seguem o formato padrão da documentação                               | Média      |
| CT-52 | API     | O cálculo não grava nada e é repetível                                      | Baixa      |
| CT-53 | UI/API  | Código de cupom vazio ou só com espaços equivale a não informar cupom       | Baixa      |

Na automação, a rastreabilidade fica junto ao código de cada teste, como comentário `// covers: CT-01`, para não
duplicar manutenção em dois lugares.

## 5. Ambientes e dados de teste

- **Ambiente:** ambiente público e compartilhado da Verzel Store, usado por outros candidatos ao mesmo tempo. As
  URLs ficam configuráveis via `.env` (`UI_BASE_URL`, `API_BASE_URL`).
- **Isolamento:** o carrinho fica guardado apenas na aba do navegador e a API não guarda estado, então um teste
  não interfere no de outro candidato. Na automação, cada teste abre um contexto de navegador novo.
- **Dados:** catálogo fixo de 8 produtos (P001 a P008) e 2 cupons (BEMVINDO10 válido e VERAO2026 expirado). 
- **Credenciais:** não se aplica (login está fora do escopo).
- **Navegador:** Chrome (execução manual e inspeção de DOM/rede) e Chromium do Playwright (automação).
- **Volume:** apenas requisições simples e pontuais, sem repetição em volume.

## 6. Critérios de entrada e saída

**Entrada:**

- Documentação da entrega VZS-142 lida por completo, incluindo "Sobre este ambiente"
- Loja e API respondendo (smoke: home carrega e `GET /api/produtos` retorna 200)
- Ambiguidades iniciais registradas em `docs/PREMISSAS_E_AMBIGUIDADES.md`

**Saída:**

- Todos os cenários da seção 4 executados, com resultado registrado em `execucao/`
- Todos os bugs encontrados reportados no template com evidência
- Documento de evidências da execução concluído
- Pelo menos 3 cenários automatizados com Playwright, com relatório HTML gerado
- README documentando como rodar a automação e onde está cada entrega
- Tudo em um único repositório público no GitHub

## 7. Ferramentas

| Camada               | Ferramenta                                                                          |
| -------------------- | ----------------------------------------------------------------------------------- |
| Cenários             | Gherkin em português (arquivos `.feature`)                                          |
| Execução manual      | Navegador com DevTools (inspeção de DOM e rede)                                     |
| API (manual)         | Cliente HTTP (Postman)                                                              |
| Automação UI + API   | Playwright + TypeScript (fixture `request` para a API)                              |
| Relatórios           | Playwright HTML Reporter                                                            |
| Evidências           | Prints, vídeo ou trace do Playwright                                                |
| Documentação de bugs | ver `docs/BUG_REPORT_TEMPLATE.md`                                                   |

