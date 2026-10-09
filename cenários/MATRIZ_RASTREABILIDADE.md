# Matriz de rastreabilidade

Relaciona cada critério de aceite (CA) da entrega **VZS-142** aos cenários de teste, e lista todos os cenários com camada, prioridade e candidatos à automação.

## 1. Critério de aceite → cenários

| CA | Regra | Cenários |
|----|-------|----------|
| CA01 | BEMVINDO10 aplica 10% sobre o subtotal | CT-01, CT-02, CT-10, CT-29 |
| CA02 | Código sem diferenciar caixa; espaços nas pontas ignorados | CT-03, CT-04, CT-11, CT-34 |
| CA03 | Cupom inexistente: "Cupom inválido." | CT-05, CT-09, CT-11, CT-33, CT-41, CT-53 |
| CA04 | Cupom expirado: "Cupom expirado." | CT-06, CT-08, CT-33, CT-41 |
| CA05 | Um cupom por vez; trocar exige remover | CT-07, CT-08 |
| CA06 | Frete grátis a partir de R$ 200,00 (inclusive) | CT-10, CT-13, CT-14, CT-15, CT-18 |
| CA07 | Abaixo de R$ 200,00: frete R$ 19,90 e valor faltante | CT-12, CT-14, CT-17, CT-18 |
| CA08 | Frete considera o subtotal antes do cupom | CT-16, CT-17 |
| CA09 | Desconto não incide sobre o frete | CT-01, CT-02, CT-29 |
| CA10 | Máximo de 5 unidades por produto (UI e API) | CT-19, CT-20, CT-21, CT-22, CT-42 |
| CA11 | Valores arredondados em 2 casas | CT-24 |
| Pré-existentes | Nome, e-mail, CEP, pagamento na entrega | CT-30, CT-31, CT-32, CT-37 |
| API | Contrato, erros e formato | CT-38 a CT-52 |

## 2. Lista de cenários

Prioridade: 
Alta = regra de negócio da entrega ou fluxo principal; 
Média = validação ou borda; 
Baixa = comportamento não definido ou secundário.

| ID | Cenário | Camada | Prioridade | Arquivo | Automação |
|----|---------|--------|------------|---------|-----------|
| CT-01 | Aplicar BEMVINDO10 reduz 10% | UI | Alta | 01 | **Candidato** |
| CT-02 | Desconto não incide sobre o frete | UI/API | Alta | 01 | |
| CT-03 | Cupom sem diferenciar maiúsculas | UI/API | Média | 01 | |
| CT-04 | Espaços nas pontas do cupom | UI/API | Média | 01 | |
| CT-05 | Cupom inexistente | UI/API | Alta | 01 | |
| CT-06 | Cupom expirado | UI/API | Alta | 01 | **Candidato** |
| CT-07 | Segundo cupom sem remover o atual | UI | Média | 01 | |
| CT-08 | Remover cupom e aplicar outro | UI | Média | 01 | |
| CT-09 | Cupom inválido seguido de válido | UI | Baixa | 01 | |
| CT-10 | Recalcular ao alterar carrinho com cupom | UI | Alta | 01 | |
| CT-11 | Espaço no meio do código é inválido | UI/API | Baixa | 01 | |
| CT-12 | Frete fixo e valor faltante abaixo de R$ 200 | UI/API | Alta | 02 | |
| CT-13 | Limite exato de R$ 200,00 | API/UI | Alta | 02 | **Candidato** |
| CT-14 | Logo abaixo do limite (199,80 / 199,60) | API/UI | Alta | 02 | |
| CT-15 | Acima de R$ 200,00 | UI/API | Média | 02 | |
| CT-16 | Frete usa subtotal antes do cupom | API/UI | Alta | 02 | **Candidato** |
| CT-17 | Valor faltante com cupom | API/UI | Média | 02 | |
| CT-18 | Aviso de frete ao cruzar o limite | UI | Média | 02 | |
| CT-19 | 5 unidades permitidas | UI/API | Alta | 03 | |
| CT-20 | 6ª unidade bloqueada na UI | UI | Alta | 03 | |
| CT-21 | Adições repetidas respeitam o limite | UI | Média | 03 | |
| CT-22 | Limite é por produto | UI | Média | 03 | |
| CT-23 | Alterar quantidade / remover item | UI | Média | 03 | |
| CT-24 | Arredondamento sem resíduo de float | UI/API | Alta | 03 | |
| CT-25 | Contador do menu Carrinho | UI | Baixa | 03 | |
| CT-26 | Persistência do carrinho na aba | UI | Baixa | 03 | |
| CT-27 | Catálogo com 8 produtos | UI/API | Média | 03 | |
| CT-28 | Pedido válido sem cupom | UI | Alta | 04 | |
| CT-29 | Pedido via API com cupom | API | Alta | 04 | **Candidato** |
| CT-30 | Nome com sobrenome | UI/API | Média | 04 | |
| CT-31 | E-mail válido | UI/API | Média | 04 | |
| CT-32 | CEP com 8 dígitos | UI/API | Média | 04 | |
| CT-33 | Pedido com cupom inválido/expirado (422) | API | Alta | 04 | |
| CT-34 | Pedido com cupom em caixa/espaços | API | Média | 04 | |
| CT-35 | Finalizar com carrinho vazio | UI/API | Média | 04 | |
| CT-36 | UI e API consistentes | UI/API | Alta | 04 | |
| CT-37 | Sem etapa de pagamento online | UI | Baixa | 04 | |
| CT-38 | Listar produtos | API | Média | 05 | |
| CT-39 | Consultar produto existente | API | Baixa | 05 | |
| CT-40 | Consultar produto inexistente (404) | API | Média | 05 | |
| CT-41 | Cálculo com cupom inválido/expirado (200) | API | Alta | 05 | |
| CT-42 | Limite de 5 unidades na API e no pedido | API | Alta | 05 | **Candidato** |
| CT-43 | Quantidade inválida | API | Média | 05 | |
| CT-44 | Itens obrigatórios | API | Média | 05 | |
| CT-45 | Item inválido | API | Média | 05 | |
| CT-46 | Produto inexistente no item (422) | API | Média | 05 | |
| CT-47 | Item duplicado | API | Média | 05 | |
| CT-48 | JSON inválido | API | Média | 05 | |
| CT-49 | Método não permitido | API | Baixa | 05 | |
| CT-50 | Rota inexistente | API | Baixa | 05 | |
| CT-51 | Formato padrão de erro | API | Média | 05 | |
| CT-52 | Cálculo sem estado | API | Baixa | 05 | |
| CT-53 | Código de cupom vazio ou só com espaços | UI/API | Baixa | 01 | |


