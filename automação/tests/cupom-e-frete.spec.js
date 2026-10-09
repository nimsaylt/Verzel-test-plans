// @ts-check
// VZS-142 - Cupom de desconto e frete grátis (Verzel Store, versão 2.3.0)
// Cada teste roda em um contexto novo do navegador, então o carrinho
// (guardado no sessionStorage da aba) sempre começa vazio.

const { test, expect } = require('@playwright/test');

// ---------- Ações de apoio ----------

async function adicionarAoCarrinho(page, nomeProduto, quantidade = 1) {
  const botao = page
    .getByRole('article', { name: nomeProduto })
    .getByRole('button', { name: 'Adicionar ao carrinho' });

  for (let i = 1; i <= quantidade; i++) {
    await botao.click();
    await expect(page.locator('.contador-carrinho')).toHaveText(String(i));
  }
}

async function abrirCarrinho(page) {
  await page.locator('a.link-carrinho').click();
  await expect(page).toHaveURL(/\/carrinho$/);
  await expect(page.getByRole('heading', { level: 1, name: 'Carrinho' })).toBeVisible();
}

async function aplicarCupom(page, codigo) {
  await page.getByLabel('Cupom de desconto').fill(codigo);
  await page.getByRole('button', { name: 'Aplicar cupom' }).click();
}

// Valores do "Resumo do pedido"
const resumo = (page, campo) => page.locator(`.resumo [data-valor="${campo}"]`);

// ---------- Cenários ----------

test.describe('VZS-142 | Cupom de desconto e frete grátis', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto('https://verzel-store.qa-test-verzel-store.workers.dev');
    await expect(page.getByRole('article').first()).toBeVisible();
  });

  test('CT01 - Aplicar cupom BEMVINDO10 reduz 10% do subtotal (CA01, CA09)', async ({page}) => {
    // Calça Jeans Slim R$ 139,90: subtotal abaixo de R$ 200,00, então há frete de R$ 19,90.
    // Isso permite provar que o desconto NÃO incide sobre o frete (CA09):
    //   correto  -> 10% de 139,90          = R$ 13,99
    //   errado   -> 10% de (139,90 + 19,90) = R$ 15,98
    await adicionarAoCarrinho(page, 'Calça Jeans Slim');
    await abrirCarrinho(page);

    await expect(resumo(page, 'subtotal')).toHaveText('R$ 139,90');
    await expect(resumo(page, 'desconto')).toHaveText('R$ 0,00');

    await aplicarCupom(page, 'BEMVINDO10');

    await expect(page.locator('.cupom-aplicado')).toContainText('Cupom BEMVINDO10 aplicado.');
    await expect(page.locator('.resumo dt', { hasText: 'Desconto' })).toHaveText('Desconto (BEMVINDO10)');

    // CA01: 10% sobre o subtotal dos produtos
    await expect(resumo(page, 'subtotal')).toHaveText('R$ 139,90');
    await expect(resumo(page, 'desconto')).toHaveText('- R$ 13,99');

    // CA09: frete continua cheio e o total segue total = subtotal - desconto + frete
    await expect(resumo(page, 'frete')).toHaveText('R$ 19,90');
    await expect(resumo(page, 'total')).toHaveText('R$ 145,81');
  });

  test('CT06 - Cupom expirado exibe "Cupom expirado." e não aplica desconto (CA04)', async ({ page }) => {
    // VERAO2026: 15%, expirado em 31/03/2026
    await adicionarAoCarrinho(page, 'Mochila Urbana 20L');
    await abrirCarrinho(page);

    await expect(resumo(page, 'total')).toHaveText('R$ 119,90');

    await aplicarCupom(page, 'VERAO2026');

    const mensagem = page.locator('#mensagem-cupom');
    await expect(mensagem).toHaveText('Cupom expirado.');
    await expect(page.getByLabel('Cupom de desconto')).toHaveAttribute('aria-invalid', 'true');

    // Nenhum desconto aplicado: valores iguais aos de antes do cupom
    await expect(page.locator('.cupom-aplicado')).toHaveCount(0);
    await expect(page.locator('.resumo dt', { hasText: 'Desconto' })).toHaveText('Desconto');
    await expect(resumo(page, 'subtotal')).toHaveText('R$ 100,00');
    await expect(resumo(page, 'desconto')).toHaveText('R$ 0,00');
    await expect(resumo(page, 'frete')).toHaveText('R$ 19,90');
    await expect(resumo(page, 'total')).toHaveText('R$ 119,90');
  });

  test('CT13 - Subtotal exatamente R$ 200,00 tem frete grátis (CA06)', async ({ page }) => {
    test.setTimeout(60_000);
    test.info().annotations.push({
      type: 'bug',
      description:
        'Defeito conhecido: com subtotal = R$ 200,00 o sistema cobra frete de R$ 19,90 ' +
        '(só zera acima de R$ 200,00) e ainda mostra "Faltam R$ 0,00 para o frete grátis." ' +
        'Este teste deve FALHAR até a correção.',
    });

    // 2 x Mochila Urbana 20L (R$ 100,00) = R$ 200,00, limite exato da regra
    await adicionarAoCarrinho(page, 'Mochila Urbana 20L', 2);
    await abrirCarrinho(page);

    await expect(page.getByRole('group', { name: 'Quantidade de Mochila Urbana 20L' }).locator('output')).toHaveText('2');
    await expect(resumo(page, 'subtotal')).toHaveText('R$ 200,00');

    await expect.soft(resumo(page, 'frete'), 'CA06: frete deve ser grátis a partir de R$ 200,00, inclusive').toHaveText('Grátis');
    await expect.soft(resumo(page, 'total'), 'Total = 200,00 - 0,00 + 0,00').toHaveText('R$ 200,00');
    await expect.soft(page.locator('.aviso-frete'), 'Não deve haver aviso de valor faltante').toHaveCount(0);
  });
});
