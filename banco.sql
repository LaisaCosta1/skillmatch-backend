-- SkillMatch: criação do banco de dados (PostgreSQL)
-- Cole este arquivo inteiro no SQL Editor do Supabase e clique em Run.
-- Pode rodar de novo quando quiser: ele apaga e recria tudo.

DROP TABLE IF EXISTS recursos;
DROP TABLE IF EXISTS vaga_requisitos;
DROP TABLE IF EXISTS vagas;
DROP TABLE IF EXISTS habilidades;

-- Lista padronizada de habilidades
CREATE TABLE habilidades (
  id        TEXT PRIMARY KEY,          -- ex.: 'sql', 'excel'
  nome      TEXT NOT NULL,             -- ex.: 'SQL', 'Excel'
  categoria TEXT NOT NULL
);

-- Vagas demonstrativas
CREATE TABLE vagas (
  id        SERIAL PRIMARY KEY,
  titulo    TEXT NOT NULL,
  empresa   TEXT NOT NULL,
  descricao TEXT NOT NULL
);

-- Quais habilidades cada vaga exige (liga vagas e habilidades)
CREATE TABLE vaga_requisitos (
  vaga_id       INTEGER NOT NULL REFERENCES vagas(id) ON DELETE CASCADE,
  habilidade_id TEXT    NOT NULL REFERENCES habilidades(id),
  PRIMARY KEY (vaga_id, habilidade_id)  -- impede requisito repetido
);

-- Cursos e materiais gratuitos para cada habilidade
CREATE TABLE recursos (
  id            SERIAL PRIMARY KEY,
  habilidade_id TEXT NOT NULL REFERENCES habilidades(id),
  titulo        TEXT NOT NULL,
  url           TEXT NOT NULL
);

-- ===== Dados =====

INSERT INTO habilidades (id, nome, categoria) VALUES
  ('html', 'HTML', 'Tecnologia'),
  ('css', 'CSS', 'Tecnologia'),
  ('javascript', 'JavaScript', 'Tecnologia'),
  ('git', 'Git e GitHub', 'Tecnologia'),
  ('sql', 'SQL', 'Tecnologia'),
  ('python', 'Python', 'Tecnologia'),
  ('excel', 'Excel', 'Ferramentas'),
  ('pacote-office', 'Pacote Office', 'Ferramentas'),
  ('power-bi', 'Power BI', 'Ferramentas'),
  ('redes-sociais', 'Gestão de redes sociais', 'Marketing'),
  ('canva', 'Canva', 'Ferramentas'),
  ('redacao', 'Redação e escrita', 'Comunicação'),
  ('comunicacao', 'Comunicação', 'Comportamental'),
  ('trabalho-equipe', 'Trabalho em equipe', 'Comportamental'),
  ('organizacao', 'Organização', 'Comportamental'),
  ('resolucao-problemas', 'Resolução de problemas', 'Comportamental'),
  ('atendimento', 'Atendimento ao cliente', 'Comportamental'),
  ('ingles', 'Inglês básico', 'Idiomas'),
  ('manutencao-pc', 'Manutenção de computadores', 'Tecnologia'),
  ('redes', 'Redes de computadores', 'Tecnologia');

INSERT INTO vagas (id, titulo, empresa, descricao) VALUES
  (1, 'Desenvolvedor(a) Front-end Júnior', 'Empresa fictícia A', 'Criar e manter páginas web responsivas junto com a equipe de desenvolvimento.'),
  (2, 'Assistente Administrativo(a)', 'Empresa fictícia B', 'Apoiar a rotina do escritório, organizar documentos e controlar planilhas.'),
  (3, 'Analista de Dados Júnior', 'Empresa fictícia C', 'Coletar, organizar e apresentar dados em relatórios e painéis.'),
  (4, 'Técnico(a) de Suporte (Help Desk)', 'Empresa fictícia D', 'Atender chamados, resolver problemas de computadores e orientar usuários.'),
  (5, 'Auxiliar de Marketing Digital', 'Empresa fictícia E', 'Produzir conteúdos e acompanhar o desempenho das redes sociais da empresa.');

-- Faz o próximo id automático continuar depois do 5
SELECT setval('vagas_id_seq', (SELECT MAX(id) FROM vagas));

INSERT INTO vaga_requisitos (vaga_id, habilidade_id) VALUES
  (1, 'html'),
  (1, 'css'),
  (1, 'javascript'),
  (1, 'git'),
  (1, 'trabalho-equipe'),
  (2, 'excel'),
  (2, 'pacote-office'),
  (2, 'organizacao'),
  (2, 'comunicacao'),
  (2, 'atendimento'),
  (3, 'sql'),
  (3, 'excel'),
  (3, 'power-bi'),
  (3, 'python'),
  (3, 'resolucao-problemas'),
  (4, 'manutencao-pc'),
  (4, 'redes'),
  (4, 'atendimento'),
  (4, 'resolucao-problemas'),
  (4, 'comunicacao'),
  (5, 'redes-sociais'),
  (5, 'canva'),
  (5, 'redacao'),
  (5, 'comunicacao'),
  (5, 'ingles');

INSERT INTO recursos (habilidade_id, titulo, url) VALUES
  ('html', 'Guia de HTML (MDN)', 'https://developer.mozilla.org/pt-BR/docs/Learn/HTML'),
  ('css', 'Guia de CSS (MDN)', 'https://developer.mozilla.org/pt-BR/docs/Learn/CSS'),
  ('javascript', 'Guia de JavaScript (MDN)', 'https://developer.mozilla.org/pt-BR/docs/Learn/JavaScript'),
  ('git', 'Livro Pro Git (gratuito)', 'https://git-scm.com/book/pt-br/v2'),
  ('sql', 'Curso de SQL - freeCodeCamp', 'https://www.freecodecamp.org/'),
  ('python', 'Curso de Python - Curso em Vídeo', 'https://www.cursoemvideo.com/'),
  ('excel', 'Excel - Fundação Bradesco (Escola Virtual)', 'https://www.ev.org.br/'),
  ('pacote-office', 'Cursos de Office - Fundação Bradesco (Escola Virtual)', 'https://www.ev.org.br/'),
  ('power-bi', 'Treinamentos de Power BI - Microsoft Learn', 'https://learn.microsoft.com/pt-br/training/powerplatform/power-bi'),
  ('redes-sociais', 'Marketing digital - Google Ateliê Digital', 'https://grow.google/intl/pt-br/'),
  ('canva', 'Canva Design School', 'https://www.canva.com/pt_br/aprenda/'),
  ('redacao', 'Cursos de comunicação escrita - Fundação Bradesco', 'https://www.ev.org.br/'),
  ('comunicacao', 'Cursos de comunicação - Fundação Bradesco', 'https://www.ev.org.br/'),
  ('trabalho-equipe', 'Cursos comportamentais - Fundação Bradesco', 'https://www.ev.org.br/'),
  ('organizacao', 'Cursos de gestão do tempo - Fundação Bradesco', 'https://www.ev.org.br/'),
  ('resolucao-problemas', 'Cursos comportamentais - Fundação Bradesco', 'https://www.ev.org.br/'),
  ('atendimento', 'Cursos de atendimento - Fundação Bradesco', 'https://www.ev.org.br/'),
  ('ingles', 'Duolingo (gratuito)', 'https://www.duolingo.com/'),
  ('manutencao-pc', 'Cursos de informática - Fundação Bradesco', 'https://www.ev.org.br/'),
  ('redes', 'Cursos de redes - Cisco Networking Academy', 'https://www.netacad.com/');

-- Segurança: bloqueia o acesso às tabelas pela API automática do Supabase.
-- A nossa API (server.js) continua funcionando, porque conecta como dono do banco.
ALTER TABLE habilidades     ENABLE ROW LEVEL SECURITY;
ALTER TABLE vagas           ENABLE ROW LEVEL SECURITY;
ALTER TABLE vaga_requisitos ENABLE ROW LEVEL SECURITY;
ALTER TABLE recursos        ENABLE ROW LEVEL SECURITY;
