# SkillMatch: como colocar o banco e a API no ar

Tempo estimado: 1 a 2 horas na primeira vez. Use um **computador**, porque pelo celular fica difícil.

No fim você terá:
- o **banco de dados** no Supabase (de graça);
- a **API** no Render (de graça), com um link que o front da Lara pode usar.

Caminho: **Supabase (banco) → GitHub (código) → Render (API no ar)**

---

## Parte 1: Criar o banco no Supabase (uns 20 min)

1. Acesse **https://supabase.com** e clique em **Start your project**.
2. Entre com sua conta do **GitHub**. Se não tiver uma, crie em https://github.com, porque ela também vai ser usada nas Partes 2 e 3.
3. Clique em **New project** e preencha:
   - **Name:** `skillmatch`
   - **Database Password:** crie uma senha **sem caracteres especiais** (só letras e números, ex.: `Skillmatch2026abc`). **Anote essa senha**, porque você vai precisar dela.
   - **Region:** escolha **South America (São Paulo)**.
   - Clique em **Create new project** e espere uns 2 minutos.
4. No menu da esquerda, clique em **SQL Editor**.
5. Abra o arquivo **banco.sql** (no Bloco de Notas mesmo), copie **tudo** e cole no editor.
6. Clique em **Run**. Deve aparecer "Success" e uma pequena tabela com `setval 5`.
7. Para conferir, clique em **Table Editor** no menu da esquerda. Devem aparecer as 4 tabelas: `habilidades` (20 linhas), `vagas` (5), `vaga_requisitos` (25) e `recursos` (20).

📸 **Tire um print do Table Editor.** É evidência para o relatório.

### Pegar o endereço do banco
8. No topo da página do projeto, clique em **Connect**.
9. Escolha a opção **Session pooler**. ⚠️ **Não use "Direct connection"**, porque ela não funciona no Render.
10. Copie o endereço (URI). Ele tem este formato:
    ```
    postgresql://postgres.abcdefgh:[YOUR-PASSWORD]@aws-0-sa-east-1.pooler.supabase.com:5432/postgres
    ```
11. Troque `[YOUR-PASSWORD]` pela sua senha do passo 3 (**apague os colchetes também**).
12. Guarde esse endereço num lugar seguro. **Não mande no grupo nem coloque no GitHub**, porque é como a chave da casa.

---

## Parte 2: Colocar o código no GitHub (uns 15 min)

1. Entre em **https://github.com**, clique no **+** no canto de cima e depois em **New repository**.
2. **Repository name:** `skillmatch-backend`. Deixe como **Public** e clique em **Create repository**.
3. Na página que abrir, clique no link **uploading an existing file**.
4. Arraste estes arquivos da pasta (descompactada) para a página:
   - `server.js`
   - `package.json`
   - `banco.sql`
   - `dados.json`
   - `LEIA-ME.md`
   - `PASSO-A-PASSO.md`
   - `.gitignore`
   - `.env.exemplo`

   ⚠️ **Nunca envie um arquivo `.env`**, porque ele tem a senha do banco.

   Os arquivos que começam com ponto podem ficar escondidos no seu computador. Se não aparecerem, tudo bem: o essencial são os 6 primeiros.
5. Embaixo, clique em **Commit changes**.

📸 **Print da página do repositório.**

> Se o grupo já tiver um repositório do projeto, pergunte ao David se você deve subir os arquivos numa pasta `backend/` lá dentro. Nesse caso, no Render (Parte 3) preencha **Root Directory** com `backend`.

---

## Parte 3: Colocar a API no ar no Render (uns 20 min)

1. Acesse **https://render.com**, clique em **Get Started** e entre com o **GitHub**.
2. Clique em **New +** e depois em **Web Service**.
3. Escolha o repositório `skillmatch-backend`. Se ele não aparecer, clique em **Configure account** e dê acesso a ele.
4. Preencha:
   - **Name:** `skillmatch-api`
   - **Language:** `Node`
   - **Branch:** `main`
   - **Build Command:** `npm install`
   - **Start Command:** `npm start`
   - **Instance Type:** **Free**
5. Em **Environment Variables**, clique em **Add Environment Variable**:
   - **Key:** `DATABASE_URL`
   - **Value:** o endereço do Supabase da Parte 1 (com a sua senha)
6. Clique em **Deploy Web Service** e espere uns 3 a 5 minutos. Quando aparecer **Live** em verde, está no ar.
7. No topo aparece o link da sua API, algo como `https://skillmatch-api-xxxx.onrender.com`.

### Testar
Abra no navegador (trocando pelo seu link):
- `https://skillmatch-api-xxxx.onrender.com/` deve mostrar "API do SkillMatch funcionando."
- `.../api/vagas` mostra a lista das 5 vagas
- `.../api/vagas/3` mostra a vaga de Analista de Dados com os requisitos
- `.../api/recursos?habilidade=sql` mostra o curso de SQL
- `.../api/vagas/99` deve dar "Vaga não encontrada." (é o teste de erro)

📸 **Print de cada teste.** São evidências para o relatório e para os testes técnicos da Mikaelle.

**Mande para a Lara só o link da API**, nunca o endereço do banco.

---

## Cuidados importantes

- **A API "dorme".** No plano grátis, o Render desliga a API depois de 15 minutos sem uso, e ela leva cerca de 1 minuto para voltar. **Antes de cada teste com usuários, abra o link da API e espere carregar.**
- **O banco pausa.** No Supabase grátis, projetos sem uso por 1 semana são pausados. Se acontecer, entre no painel do Supabase e clique em **Restore project**. Durante as semanas de testes, abra a API de vez em quando.
- **Para mudar vagas ou habilidades:** edite direto no **Table Editor** do Supabase, ou mude o `banco.sql` e rode de novo no SQL Editor. ⚠️ Rodar o `banco.sql` de novo **apaga tudo e recria** com o que está no arquivo.

---

## Se der erro

Olhe a aba **Logs** no Render e me mande um print. Os erros mais comuns:

| Mensagem no log | O que fazer |
|---|---|
| `DATABASE_URL não foi definida` | Faltou o passo 5 da Parte 3 |
| `password authentication failed` | Senha errada no endereço, ou faltou apagar os colchetes `[ ]` |
| `ENETUNREACH` ou `connect ETIMEDOUT` | Você copiou a "Direct connection". Use a **Session pooler** |
| `Tenant or user not found` | Endereço copiado errado. Copie de novo pelo botão **Connect** |
| `Cannot find module` | Algum arquivo não foi para o GitHub. Confira o `package.json` e o `server.js` |

---

## (Opcional) Rodar no seu computador

1. Instale o **Node.js** (versão LTS) em https://nodejs.org.
2. Na pasta do projeto, faça uma cópia de `.env.exemplo` com o nome `.env` e cole nele o endereço do banco.
3. No terminal, dentro da pasta, rode:
   ```
   npm install
   npm run local
   ```
4. Abra http://localhost:3000/api/vagas
