@'
<h1 align="center">
  Verzel Store — Teste Técnico QA & Automação de Testes
</h1>

<p align="center">
  <b>Garantia de Qualidade e Automação E2E para a entrega VZS-142 (Cupom de Desconto e Frete Grátis)</b>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Playwright-2EAD33?style=for-the-badge&logo=Playwright&logoColor=white" alt="Playwright" />
  <img src="https://img.shields.io/badge/Node.js-339933?style=for-the-badge&logo=nodedotjs&logoColor=white" alt="Node.js" />
  <img src="https://img.shields.io/badge/JavaScript-F7DF1E?style=for-the-badge&logo=javascript&logoColor=black" alt="JavaScript" />
  <img src="https://img.shields.io/badge/Gherkin-2496ED?style=for-the-badge&logo=cucumber&logoColor=white" alt="Gherkin" />
</p>

---

## Tabela de Conteúdos

- [Sobre o Projeto](#-sobre-o-projeto)
- [Aplicações Alvo](#-aplicações-alvo)
- [Tecnologias Utilizadas](#-tecnologias-utilizadas)
- [Estrutura do Repositório](#-estrutura-do-repositório)
- [Como Executar a Automação](#-como-executar-a-automação)
- [Cenários de Teste Automatizados](#-cenários-de-teste-automatizados)
- [Relatórios de Execução](#-relatórios-de-execução)
- [Gestão de Bugs](#-gestão-de-bugs)

---

## Sobre o Projeto

Este repositório contém a estratégia completa de **Garantia de Qualidade (QA)** e a **Automação de Testes End-to-End (E2E)** para a aplicação **Verzel Store**, com foco na funcionalidade **VZS-142 — Cupom de desconto e frete grátis** (versão 2.3.0).

O projeto simulou a rotina completa de um time de desenvolvimento ágil:
1. **Planejamento:** Elaboração do Plano de Testes com estratégia baseada em riscos.
2. **Especificação:** Escrita de 53 cenários em BDD/Gherkin.
3. **Execução:** Testes manuais/exploratórios e automação E2E de UI com Playwright.
4. **Report:** Documentação detalhada de bugs e geração de evidências.

---

## Aplicações Alvo

| Camada | Descrição | URL |
| :--- | :--- | :--- |
| **UI** | Verzel Store (Loja) | [https://verzel-store.qa-test-verzel-store.workers.dev](https://verzel-store.qa-test-verzel-store.workers.dev/) |
| **Docs** | Documentação da entrega VZS-142 | [https://verzel-store.qa-test-verzel-store.workers.dev/documentacao](https://verzel-store.qa-test-verzel-store.workers.dev/documentacao) |
| **API** | API da loja (`/api`) | [https://verzel-store.qa-test-verzel-store.workers.dev/api](https://verzel-store.qa-test-verzel-store.workers.dev/api) |

---

## Tecnologias Utilizadas

- **[Playwright](https://playwright.dev/):** Automação de testes de interface gráfica (UI).
- **[Node.js](https://nodejs.org/):** Ambiente de execução JavaScript.
- **[Gherkin / BDD](https://cucumber.io/docs/gherkin/):** Padronização e escrita dos cenários de teste.
---

## Estrutura do Repositório

```text
.
├── automação/                  # Projeto de automação Playwright
│   ├── tests/                 # Scripts dos testes automatizados (CT-01, CT-06, CT-13)
│   ├── playwright.config.js   # Configuração global do Playwright
│   └── package.json           # Dependências do projeto
├── bug-reports/                # Relatórios detalhados dos bugs encontrados e reports HTML
├── cenários/                   # 5 arquivos .feature (53 cenários BDD) e Matriz de Rastreabilidade
├── docs/                       # Plano de Testes, Premissas e Templates de Bug Report
└── README.md                   # Documentação principal do repositório
```

## Como Executar a Automação
Pré-requisitos:
Node.js v20 ou superior
Git instalado

### Passo a passo

1. **Clonar o repositório:**
   git clone [https://github.com/nimsaylt/Verzel-test-plans.git](https://github.com/nimsaylt/Verzel-test-plans.git);
   cd Verzel-test-plans
2. **Acessar a pasta de automação:** cd automação
3. **Instalar as dependências do Node:** npm install
4. **Instalar o navegador Chromium no Playwright:** npx playwright install chromium
5. **Executar os testes:** npx playwright test


## Relatórios de Execução
Após a execução dos testes dentro da pasta automação, o relatório HTML é salvo automaticamente na pasta bug-reports/. Para visualizá-lo de forma interativa no navegador: npx playwright show-report ../bug-reports

## Cenários de Teste Automatizados

A suíte de automação cobre os principais fluxos de regressão e validação de regras de negócio:

| Código | Descrição do Cenário | Esperado | Status |
| :---: | :--- | :---: | :---: |
| **CT-01** | Aplicar cupom `BEMVINDO10` reduz 10% do subtotal | Passar | Passing |
| **CT-06** | Aplicar cupom expirado exibe mensagem "Cupom expirado." | Passar | Passing |
| **CT-13** | Subtotal exatamente R$ 200,00 deve aplicar Frete Grátis (CA06) | Falhar* | Bug |

> **Nota sobre o CT-13:** O teste do **CT-13** falha de propósito na suíte para evidenciar o **BUG-003**, onde a loja cobra frete de R$ 19,90 mesmo com o subtotal atingindo o valor exato de R$ 200,00.

