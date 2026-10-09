# Instructions

- Following Playwright test failed.
- Explain why, be concise, respect Playwright best practices.
- Provide a snippet of code with the fix, if possible.

# Test info

- Name: cupom-e-frete.spec.js >> VZS-142 | Cupom de desconto e frete grátis >> CT13 - Subtotal exatamente R$ 200,00 tem frete grátis (CA06)
- Location: tests\cupom-e-frete.spec.js:90:3

# Error details

```
Error: CA06: frete deve ser grátis a partir de R$ 200,00, inclusive

expect(locator).toHaveText(expected) failed

Locator:  locator('.resumo [data-valor="frete"]')
Expected: "Grátis"
Received: "R$ 19,90"
Timeout:  10000ms

Call log:
  - CA06: frete deve ser grátis a partir de R$ 200,00, inclusive locator('.resumo [data-valor="frete"]') with timeout 10000ms
  - waiting for locator('.resumo [data-valor="frete"]')
    23 × locator resolved to <dd data-valor="frete">R$ 19,90</dd>
       - unexpected value "R$ 19,90"

```

```yaml
- definition: R$ 19,90
```

```
Error: Total = 200,00 - 0,00 + 0,00

expect(locator).toHaveText(expected) failed

Locator:  locator('.resumo [data-valor="total"]')
Expected: "R$ 200,00"
Received: "R$ 219,90"
Timeout:  10000ms

Call log:
  - Total = 200,00 - 0,00 + 0,00 locator('.resumo [data-valor="total"]') with timeout 10000ms
  - waiting for locator('.resumo [data-valor="total"]')
    23 × locator resolved to <dd data-valor="total">R$ 219,90</dd>
       - unexpected value "R$ 219,90"

```

```yaml
- definition: R$ 219,90
```

```
Error: Não deve haver aviso de valor faltante

expect(locator).toHaveCount(expected) failed

Locator:  locator('.aviso-frete')
Expected: 0
Received: 1
Timeout:  10000ms

Call log:
  - Não deve haver aviso de valor faltante locator('.aviso-frete') with timeout 10000ms
  - waiting for locator('.aviso-frete')
    24 × locator resolved to 1 element
       - unexpected value "1"

```

# Test source

```ts
  11  |   const botao = page
  12  |     .getByRole('article', { name: nomeProduto })
  13  |     .getByRole('button', { name: 'Adicionar ao carrinho' });
  14  | 
  15  |   for (let i = 1; i <= quantidade; i++) {
  16  |     await botao.click();
  17  |     await expect(page.locator('.contador-carrinho')).toHaveText(String(i));
  18  |   }
  19  | }
  20  | 
  21  | async function abrirCarrinho(page) {
  22  |   await page.locator('a.link-carrinho').click();
  23  |   await expect(page).toHaveURL(/\/carrinho$/);
  24  |   await expect(page.getByRole('heading', { level: 1, name: 'Carrinho' })).toBeVisible();
  25  | }
  26  | 
  27  | async function aplicarCupom(page, codigo) {
  28  |   await page.getByLabel('Cupom de desconto').fill(codigo);
  29  |   await page.getByRole('button', { name: 'Aplicar cupom' }).click();
  30  | }
  31  | 
  32  | // Valores do "Resumo do pedido"
  33  | const resumo = (page, campo) => page.locator(`.resumo [data-valor="${campo}"]`);
  34  | 
  35  | // ---------- Cenários ----------
  36  | 
  37  | test.describe('VZS-142 | Cupom de desconto e frete grátis', () => {
  38  |   test.beforeEach(async ({ page }) => {
  39  |     await page.goto('https://verzel-store.qa-test-verzel-store.workers.dev');
  40  |     await expect(page.getByRole('article').first()).toBeVisible();
  41  |   });
  42  | 
  43  |   test('CT01 - Aplicar cupom BEMVINDO10 reduz 10% do subtotal (CA01, CA09)', async ({ page }) => {
  44  |     // Calça Jeans Slim R$ 139,90: subtotal abaixo de R$ 200,00, então há frete de R$ 19,90.
  45  |     // Isso permite provar que o desconto NÃO incide sobre o frete (CA09):
  46  |     //   correto  -> 10% de 139,90          = R$ 13,99
  47  |     //   errado   -> 10% de (139,90 + 19,90) = R$ 15,98
  48  |     await adicionarAoCarrinho(page, 'Calça Jeans Slim');
  49  |     await abrirCarrinho(page);
  50  | 
  51  |     await expect(resumo(page, 'subtotal')).toHaveText('R$ 139,90');
  52  |     await expect(resumo(page, 'desconto')).toHaveText('R$ 0,00');
  53  | 
  54  |     await aplicarCupom(page, 'BEMVINDO10');
  55  | 
  56  |     await expect(page.locator('.cupom-aplicado')).toContainText('Cupom BEMVINDO10 aplicado.');
  57  |     await expect(page.locator('.resumo dt', { hasText: 'Desconto' })).toHaveText('Desconto (BEMVINDO10)');
  58  | 
  59  |     // CA01: 10% sobre o subtotal dos produtos
  60  |     await expect(resumo(page, 'subtotal')).toHaveText('R$ 139,90');
  61  |     await expect(resumo(page, 'desconto')).toHaveText('- R$ 13,99');
  62  | 
  63  |     // CA09: frete continua cheio e o total segue total = subtotal - desconto + frete
  64  |     await expect(resumo(page, 'frete')).toHaveText('R$ 19,90');
  65  |     await expect(resumo(page, 'total')).toHaveText('R$ 145,81');
  66  |   });
  67  | 
  68  |   test('CT06 - Cupom expirado exibe "Cupom expirado." e não aplica desconto (CA04)', async ({ page }) => {
  69  |     // VERAO2026: 15%, expirado em 31/03/2026
  70  |     await adicionarAoCarrinho(page, 'Mochila Urbana 20L');
  71  |     await abrirCarrinho(page);
  72  | 
  73  |     await expect(resumo(page, 'total')).toHaveText('R$ 119,90');
  74  | 
  75  |     await aplicarCupom(page, 'VERAO2026');
  76  | 
  77  |     const mensagem = page.locator('#mensagem-cupom');
  78  |     await expect(mensagem).toHaveText('Cupom expirado.');
  79  |     await expect(page.getByLabel('Cupom de desconto')).toHaveAttribute('aria-invalid', 'true');
  80  | 
  81  |     // Nenhum desconto aplicado: valores iguais aos de antes do cupom
  82  |     await expect(page.locator('.cupom-aplicado')).toHaveCount(0);
  83  |     await expect(page.locator('.resumo dt', { hasText: 'Desconto' })).toHaveText('Desconto');
  84  |     await expect(resumo(page, 'subtotal')).toHaveText('R$ 100,00');
  85  |     await expect(resumo(page, 'desconto')).toHaveText('R$ 0,00');
  86  |     await expect(resumo(page, 'frete')).toHaveText('R$ 19,90');
  87  |     await expect(resumo(page, 'total')).toHaveText('R$ 119,90');
  88  |   });
  89  | 
  90  |   test('CT13 - Subtotal exatamente R$ 200,00 tem frete grátis (CA06)', async ({ page }) => {
  91  |     // 3 asserções soft que podem esperar até 10s cada quando falham
  92  |     test.setTimeout(60_000);
  93  |     test.info().annotations.push({
  94  |       type: 'bug',
  95  |       description:
  96  |         'Defeito conhecido: com subtotal = R$ 200,00 o sistema cobra frete de R$ 19,90 ' +
  97  |         '(só zera acima de R$ 200,00) e ainda mostra "Faltam R$ 0,00 para o frete grátis." ' +
  98  |         'Este teste deve FALHAR até a correção.',
  99  |     });
  100 | 
  101 |     // 2 x Mochila Urbana 20L (R$ 100,00) = R$ 200,00, limite exato da regra
  102 |     await adicionarAoCarrinho(page, 'Mochila Urbana 20L', 2);
  103 |     await abrirCarrinho(page);
  104 | 
  105 |     await expect(page.getByRole('group', { name: 'Quantidade de Mochila Urbana 20L' }).locator('output')).toHaveText('2');
  106 |     await expect(resumo(page, 'subtotal')).toHaveText('R$ 200,00');
  107 | 
  108 |     // Asserções "soft" para registrar todas as divergências do mesmo bug em uma execução
  109 |     await expect.soft(resumo(page, 'frete'), 'CA06: frete deve ser grátis a partir de R$ 200,00, inclusive').toHaveText('Grátis');
  110 |     await expect.soft(resumo(page, 'total'), 'Total = 200,00 - 0,00 + 0,00').toHaveText('R$ 200,00');
> 111 |     await expect.soft(page.locator('.aviso-frete'), 'Não deve haver aviso de valor faltante').toHaveCount(0);
      |                                                                                               ^ Error: Não deve haver aviso de valor faltante
  112 |   });
  113 | });
  114 | 
```