# Registro e Registro de Execução dos Testes (CTFL / ISTQB)

> **Mapeamento da Execução:** Testes manuais, exploratórios e automação E2E realizados no ambiente Verzel Store (Entrega VZS-142).
> A planilha completa com todos os logs detalhados em Excel está disponível na pasta [`execucao/relatorio_execucao.xlsx`](./relatorio_execucao.xlsx).

---

## Resumo Executivo da Suíte

| Métrica | Quantidade | Percentual |
| :--- | :---: | :---: |
| **Total de Cenários Mapeados** | 53 | 100% |
| **Cenários Executados** | 53 | 100% |
| **Aprovados (Passed)** | 50 | 94.3% |
| **Reprovados (Failed)** | 3 | 5.7% |
| **Bloqueados / Não Executados** | 0 | 0% |

---

## Exemplo da Tabela Detalhada de Execução

| ID | Funcionalidade | Cenário / Descrição | Tipo | Resultado Esperado | Resultado Obtido | Status | Bug Relacionado | Evidência |
| :---: | :--- | :--- | :---: | :--- | :--- | :---: | :---: | :---: |
| **CT-01** | Cupom | Aplicar cupom `BEMVINDO10` | Auto / UI | Reduzir 10% do subtotal | Subtotal recalculado com 10% de desconto | 🟢 Passou | N/A | [`ver`](../evidencias/ct01.png) |
| **CT-02** | Cupom | Aplicar cupom em caixa baixa (`bemvindo10`) | Manual | Aceitar o cupom sem diferenciação | Cupom aceito normalmente | 🟢 Passou | N/A | [`ver`](../evidencias/ct02.png) |
| **CT-06** | Cupom Expirado | Aplicar cupom vencido `EXPIRED10` | Auto / UI | Exibir "Cupom expirado." e não descontar | Mensagem "Cupom expirado." exibida | 🟢 Passou | N/A | [`ver`](../evidencias/ct06.png) |
| **CT-13** | Frete Grátis | Subtotal exatamente de R$ 200,00 | Auto / UI | Aplicar Frete Grátis (R$ 0,00) | Cobrou R$ 19,90 de frete | 🔴 Falhou | [BUG-003](../bug-reports/BUG-003.md) | [`ver`](../evidencias/ct13.png) |
| **CT-16** | Checkout | Preencher e-mail com formato inválido | Manual | Impedir avanço ou validar campo | Permitiu finalizar compra | 🔴 Falhou | [BUG-002](../bug-reports/BUG-002.md) | [`ver`](../evidencias/ct16.png) |

---

## Legenda de Status
* 🟢 **Passou (Passed):** O comportamento observado foi idêntico ao esperado pela regra de negócio.
* 🔴 **Falhou (Failed):** Foi identificado um desvio em relação ao requisito (defeito mapeado).
