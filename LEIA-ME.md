# SkillMatch: Backend (frente 4)

Responsável: Laisa Costa

API em **Node.js + Express** com banco de dados **PostgreSQL** hospedado no **Supabase**, e a API publicada no **Render**.

👉 Para colocar no ar, siga o **PASSO-A-PASSO.md**.

## Arquivos

| Arquivo | Para que serve |
|---|---|
| `banco.sql` | Cria as tabelas e insere os dados (é colado no Supabase) |
| `server.js` | A API: busca os dados no banco e entrega ao frontend |
| `package.json` | Lista as bibliotecas usadas (express e pg) |
| `dados.json` | Cópia dos mesmos dados em JSON (reserva, caso o grupo desista do banco) |
| `.env.exemplo` | Modelo do arquivo com o endereço do banco, para rodar localmente |
| `.gitignore` | Impede que a senha do banco (`.env`) vá para o GitHub |

## Estrutura do banco

- **habilidades** (`id`, `nome`, `categoria`): lista padronizada. O `id` é um texto fixo, ex.: `sql`.
- **vagas** (`id`, `titulo`, `empresa`, `descricao`): 5 vagas fictícias.
- **vaga_requisitos** (`vaga_id`, `habilidade_id`): quais habilidades cada vaga exige. A chave primária dupla impede requisito repetido.
- **recursos** (`id`, `habilidade_id`, `titulo`, `url`): cursos gratuitos de cada habilidade.

## Rotas da API

| Rota | O que retorna |
|---|---|
| `GET /` | Mensagem confirmando que a API está no ar |
| `GET /api/habilidades` | Todas as habilidades padronizadas |
| `GET /api/vagas` | Lista de vagas (id, título, empresa) |
| `GET /api/vagas/:id` | Uma vaga com descrição e requisitos (ex.: `/api/vagas/3`) |
| `GET /api/recursos` | Todos os recursos de aprendizagem |
| `GET /api/recursos?habilidade=sql` | Recursos de uma habilidade específica |

## Validação e tratamento de erros

- `/api/vagas/abc` ou `/api/vagas/0`: erro 400 ("O id da vaga deve ser um número.")
- `/api/vagas/99`: erro 404 ("Vaga não encontrada.")
- Endereço inexistente: erro 404
- Falha no banco: erro 500 ("Erro interno no servidor."), com o detalhe registrado nos logs
- As consultas usam parâmetros (`$1`), o que protege contra SQL injection (requisito de segurança RNF04)

## Como isso se conecta com as outras partes

- **Frontend (Lara):** busca habilidades e vagas nas rotas acima usando o link da API no Render.
- **Lógica (Carol):** recebe as habilidades escolhidas pelo usuário e os `requisitos` da vaga e calcula o percentual. Como os dois usam os mesmos `id`, a comparação não sofre com diferenças de escrita (maiúsculas, acentos).
- **Recursos:** para cada lacuna encontrada, o frontend chama `/api/recursos?habilidade=<id>`.

## Pendências

- Conferir com a Carol se o formato dos dados serve para a função dela.
- Conferir os links dos recursos antes da validação com usuários.
- Revisar com o grupo as vagas e habilidades de exemplo.
