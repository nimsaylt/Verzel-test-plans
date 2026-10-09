# Verzel Store — Teste técnico QA Júnior (VZS-142)

> Validação da entrega **VZS-142 — Cupom de desconto e frete grátis** (versão 2.3.0) da Verzel Store, feita como
> no dia a dia de um time de desenvolvimento: cenários em Gherkin, execução manual e exploratória, report de bugs,
> evidências, testes de API em Postman e automação de UI com Playwright.
> O plano de testes completo (escopo, estratégia baseada em risco, casos de teste, fases e riscos) está em
> [`docs/TEST_PLAN.md`](docs/TEST_PLAN.md).

## Resumo para o avaliador

- **Rodar a automação:** `npm install` → `npx playwright install chromium` → `npm test` (instruções completas
  [abaixo](#como-rodar-a-automação-playwright)).
- **Resultado esperado:** 3 testes de UI. **CT-01** e **CT-06** passam. **CT-13 falha de propósito**: ele documenta o
  [BUG-003](bugs/BUG-003.md), que ainda existe na loja (frete cobrado com subtotal exatamente R$ 200,00).
- **Onde está cada entrega:** tabela [Entregas e onde encontrar cada uma](#entregas-e-onde-encontrar-cada-uma).

## Aplicações-alvo

| Camada      | Aplicação                       | URL                                                                   |
| ----------- | ------------------------------- | --------------------------------------------------------------------- |
| UI          | Verzel Store                    | <https://verzel-store.qa-test-verzel-store.workers.dev/>              |
| Documentação | Documentação da entrega VZS-142 | <https://verzel-store.qa-test-verzel-store.workers.dev/documentacao>  |
| API         | API da loja (`/api`)            | <https://verzel-store.qa-test-verzel-store.workers.dev/api>           |

O ambiente é fictício e **compartilhado** com outros candidatos. Por isso não há testes de carga, estresse ou
segurança, e a automação roda com poucos workers e sem repetição em volume.

## Entregas e onde encontrar cada uma

| Entrega pedida                                   | Onde está                                                                                                   |
| ------------------------------------------------ | ----------------------------------------------------------------------------------------------------------- |
| Cenários de teste (Gherkin)                      | [`cenarios/`](cenarios/): 5 arquivos `.feature` (53 cenários, CT-01 a CT-53) e a [matriz de rastreabilidade](cenarios/MATRIZ_RASTREABILIDADE.md) |
| Plano de testes                                  | [`docs/TEST_PLAN.md`](docs/TEST_PLAN.md)                                                                     |
| Execução dos testes, com o resultado de cada cenário | [`execucao/EXECUCAO_TESTES.md`](execucao/EXECUCAO_TESTES.md)                                             |
| Report de bugs                                   | [`bugs/`](bugs/) (um arquivo por bug, no [template de 16 campos](docs/BUG_REPORT_TEMPLATE.md))|
| Documento com as evidências da execução          | [`evidencias/EVIDENCIAS.md`](evidencias/EVIDENCIAS.md) e os arquivos em [`evidencias/`](evidencias/)          |
| Automação com Playwright (3 cenários)            | [`tests/`](tests/): CT-01, CT-06 e CT-13                                                                     |

## Stack

- **Playwright + TypeScript** — automação de UI (Page Object Model)
- **Gherkin (`.feature`)** — cenários de teste
- **Playwright HTML Reporter** — relatório de execução

## Estrutura do projeto

```
├── docs/
│   ├── TEST_PLAN.md                  # Plano de testes completo
│   ├── PREMISSAS_E_AMBIGUIDADES.md   # Interpretações adotadas e massa de dados
│   └── BUG_REPORT_TEMPLATE.md        # Template de 16 campos para documentar bugs (CTFL)
├── cenarios/                         # Cenários em Gherkin + matriz de rastreabilidade
├── execucao/                         # Resultado da execução de cada cenário
├── bugs/                             # Um arquivo por bug (.md) 
├── evidencias/                       # Prints, respostas de API e documento de evidências
├── tests/
│   ├── ui/                           # Testes de UI (CT-01, CT-06, CT-13)
│   │   └── pages/LojaPage.ts         # Page Object: seletores da loja
│   └── support/data.ts               # Massa de dados e cálculo esperado (em centavos)
├── playwright.config.ts
├── package.json
```

## Como rodar a automação (Playwright)

**Pré-requisitos:** [Node.js](https://nodejs.org/) 20 ou superior e acesso à internet (a loja é pública).

```bash
git clone <URL-DESTE-REPOSITORIO>
cd <pasta-do-repositorio>

npm install
npx playwright install chromium     # no Linux, use: npx playwright install --with-deps chromium


npm test                            # roda os 3 cenários de UI
npm run test:stable                 # roda sem o teste do BUG-003 (CT-01 e CT-06)
npm run test:bug                    # roda só o teste do BUG-003 (CT-13)
npm run report                      # abre o relatório HTML da última execução
```


### O que esperar da execução

| Cenário | Teste | Resultado esperado |
| ------- | ----- | ------------------ |
| CT-01 | Aplicar BEMVINDO10 reduz 10% do subtotal (R$ 239,70 → total R$ 215,73) | Passa |
| CT-06 | Cupom expirado exibe "Cupom expirado." e não aplica desconto | Passa |
| CT-13 | Subtotal exatamente R$ 200,00 deve ter frete grátis (CA06) | **Falha** — documenta o [BUG-001](bugs/BUG-003.md) |

O CT-13 fica vermelho de propósito: ele reproduz o defeito (a loja cobra R$ 19,90 de frete e informa
"Faltam R$ 0,00 para o frete grátis") e passa sozinho quando o bug for corrigido. Em caso de falha, o Playwright
guarda trace, screenshot em `test-results/`, e o relatório HTML em `playwright-report/`.

### Observações

- **Rastreabilidade:** o título e as tags de cada teste citam o cenário (`@CT-13`) e o bug (`@BUG-003`).
- **Seletores:** ficam centralizados em [`tests/ui/pages/LojaPage.ts`](tests/ui/pages/LojaPage.ts).
- **Isolamento:** cada teste abre um contexto de navegador novo, com carrinho vazio, e o ambiente compartilhado
  não é afetado (2 workers, sem repetição).

## Como rodar a coleção Postman

1. No Postman, use **Import** e selecione os dois arquivos de [`postman/`](postman/):
   `Verzel_Store_API.postman_collection.json` e `Verzel_Store.postman_environment.json`.
2. Escolha o ambiente **Verzel Store — Teste Técnico**.
3. Abra a coleção, clique em **Run** e execute com **1 iteração**.

Pela linha de comando (com [Newman](https://www.npmjs.com/package/newman)):

```bash
npm install -g newman
newman run postman/Verzel_Store_API.postman_collection.json \
  -e postman/Verzel_Store.postman_environment.json \
  --delay-request 200
```

Os requests marcados com **[BUG-001]** devem falhar até a correção do bug. Mais detalhes em
[`postman/README.md`](postman/README.md).

## Bugs encontrados

| ID | Título | Severidade | Prioridade | Cenários |
| -- | ------ | ---------- | ---------- | -------- |
| [BUG-001](bugs/BUG-001.md) | Frete de R$ 19,90 é cobrado quando o subtotal é exatamente R$ 200,00 (deveria ser grátis, CA06) | Alta | Alta | CT-13, CT-16 (e provável CT-10) |

## Premissas e ambiguidades

Onde a documentação é ambígua, a interpretação adotada está registrada em
[`docs/PREMISSAS_E_AMBIGUIDADES.md`](docs/PREMISSAS_E_AMBIGUIDADES.md) (21 itens). Alguns exemplos:

- **Segundo cupom sem remover o atual (CA05):** o segundo não é aplicado e o atual permanece.
- **Arredondamento (CA11):** com os preços do catálogo o desconto de 10% nunca gera fração de centavo, então
  valida-se a ausência de resíduos de ponto flutuante.
- **CEP "com ou sem hífen":** a posição do hífen não é definida; só `99999-999` e `99999999` são tratados como válidos.


