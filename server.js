// SkillMatch - API (backend) conectada ao banco PostgreSQL (Supabase)

const express = require("express");
const { Pool } = require("pg");

// O endereço do banco vem da variável de ambiente DATABASE_URL
// (no Render ela é configurada no painel; no seu computador, no arquivo .env)
if (!process.env.DATABASE_URL) {
  console.error("Erro: a variável DATABASE_URL não foi definida.");
  process.exit(1);
}

const banco = new Pool({
  connectionString: process.env.DATABASE_URL,
  ssl: { rejectUnauthorized: false }, // o Supabase exige conexão segura
});

const app = express();
const PORTA = process.env.PORT || 3000; // o Render define a porta sozinho

// Permite que o frontend (aberto em outro endereço) acesse a API
app.use((req, res, next) => {
  res.setHeader("Access-Control-Allow-Origin", "*");
  next();
});

// Página inicial: só confirma que a API está no ar
app.get("/", (req, res) => {
  res.json({ mensagem: "API do SkillMatch funcionando." });
});

// Lista todas as habilidades padronizadas
app.get("/api/habilidades", async (req, res, next) => {
  try {
    const r = await banco.query(
      "SELECT id, nome, categoria FROM habilidades ORDER BY categoria, nome"
    );
    res.json(r.rows);
  } catch (erro) {
    next(erro);
  }
});

// Lista todas as vagas, já com os requisitos (nomes iguais aos do site)
app.get("/api/vagas", async (req, res, next) => {
  try {
    const r = await banco.query(
      `SELECT v.id, v.titulo, v.empresa, v.tipo, v.modalidade, v.localizacao, v.descricao,
              COALESCE(json_agg(json_build_object('id', h.id, 'nome', h.nome) ORDER BY h.nome)
                       FILTER (WHERE h.id IS NOT NULL), '[]') AS requisitos
         FROM vagas v
         LEFT JOIN vaga_requisitos vr ON vr.vaga_id = v.id
         LEFT JOIN habilidades h ON h.id = vr.habilidade_id
        GROUP BY v.id
        ORDER BY v.id`
    );
    res.json(r.rows);
  } catch (erro) {
    next(erro);
  }
});

// Mostra uma vaga específica com seus requisitos
app.get("/api/vagas/:id", async (req, res, next) => {
  const id = Number(req.params.id);

  // Validação: o id precisa ser um número inteiro positivo
  if (!Number.isInteger(id) || id <= 0) {
    return res.status(400).json({ erro: "O id da vaga deve ser um número." });
  }

  try {
    const vaga = await banco.query(
      "SELECT id, titulo, empresa, tipo, modalidade, localizacao, descricao FROM vagas WHERE id = $1",
      [id]
    );
    if (vaga.rows.length === 0) {
      return res.status(404).json({ erro: "Vaga não encontrada." });
    }

    const requisitos = await banco.query(
      `SELECT h.id, h.nome
         FROM vaga_requisitos vr
         JOIN habilidades h ON h.id = vr.habilidade_id
        WHERE vr.vaga_id = $1
        ORDER BY h.nome`,
      [id]
    );

    res.json({ ...vaga.rows[0], requisitos: requisitos.rows });
  } catch (erro) {
    next(erro);
  }
});

// Lista recursos de aprendizagem (todos, ou só de uma habilidade)
// Exemplo: /api/recursos?habilidade=sql
app.get("/api/recursos", async (req, res, next) => {
  const { habilidade } = req.query;
  try {
    const r = habilidade
      ? await banco.query(
          "SELECT habilidade_id AS habilidade, titulo, fonte, tipo, url FROM recursos WHERE habilidade_id = $1",
          [habilidade]
        )
      : await banco.query(
          "SELECT habilidade_id AS habilidade, titulo, fonte, tipo, url FROM recursos ORDER BY habilidade_id"
        );
    res.json(r.rows);
  } catch (erro) {
    next(erro);
  }
});

// Qualquer outro endereço
app.use((req, res) => {
  res.status(404).json({ erro: "Endereço não encontrado." });
});

// Erros inesperados (por exemplo, banco fora do ar)
app.use((erro, req, res, next) => {
  console.error(erro);
  res.status(500).json({ erro: "Erro interno no servidor." });
});

app.listen(PORTA, () => {
  console.log(`API do SkillMatch rodando na porta ${PORTA}`);
});
