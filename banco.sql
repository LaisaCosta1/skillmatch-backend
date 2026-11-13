-- SkillMatch: banco de dados (PostgreSQL) - versão 2, igual ao site
-- Cole este arquivo inteiro no SQL Editor do Supabase e clique em Run.
-- Pode rodar de novo quando quiser: ele apaga e recria tudo.

DROP TABLE IF EXISTS recursos;
DROP TABLE IF EXISTS vaga_requisitos;
DROP TABLE IF EXISTS vagas;
DROP TABLE IF EXISTS habilidades;

-- Lista padronizada de habilidades
CREATE TABLE habilidades (
  id        TEXT PRIMARY KEY,          -- ex.: 'sql', 'banco-de-dados'
  nome      TEXT NOT NULL UNIQUE,      -- ex.: 'SQL', 'Banco de dados' (igual ao site)
  categoria TEXT NOT NULL
);

-- Vagas e projetos demonstrativos
CREATE TABLE vagas (
  id          SERIAL PRIMARY KEY,
  titulo      TEXT NOT NULL,
  empresa     TEXT NOT NULL,
  tipo        TEXT NOT NULL CHECK (tipo IN ('vaga', 'projeto')),
  modalidade  TEXT NOT NULL CHECK (modalidade IN ('remoto', 'hibrido', 'presencial')),
  localizacao TEXT NOT NULL,
  descricao   TEXT NOT NULL
);

-- Quais habilidades cada vaga exige (liga vagas e habilidades)
CREATE TABLE vaga_requisitos (
  vaga_id       INTEGER NOT NULL REFERENCES vagas(id) ON DELETE CASCADE,
  habilidade_id TEXT    NOT NULL REFERENCES habilidades(id),
  PRIMARY KEY (vaga_id, habilidade_id)  -- impede requisito repetido
);

-- Materiais gratuitos de estudo para cada habilidade
CREATE TABLE recursos (
  id            SERIAL PRIMARY KEY,
  habilidade_id TEXT NOT NULL REFERENCES habilidades(id),
  titulo        TEXT NOT NULL,
  fonte         TEXT NOT NULL,
  tipo          TEXT NOT NULL,
  url           TEXT NOT NULL
);

-- ===== Dados =====

INSERT INTO habilidades (id, nome, categoria) VALUES
  ('javascript', 'JavaScript', 'Tecnologia'),
  ('html', 'HTML', 'Tecnologia'),
  ('css', 'CSS', 'Tecnologia'),
  ('react', 'React', 'Tecnologia'),
  ('java', 'Java', 'Tecnologia'),
  ('spring', 'Spring', 'Tecnologia'),
  ('python', 'Python', 'Tecnologia'),
  ('sql', 'SQL', 'Dados'),
  ('banco-de-dados', 'Banco de dados', 'Dados'),
  ('analise-de-dados', 'Análise de dados', 'Dados'),
  ('redes', 'Redes', 'Tecnologia'),
  ('comunicacao', 'Comunicação', 'Comportamental'),
  ('organizacao', 'Organização', 'Comportamental');

INSERT INTO vagas (id, titulo, empresa, tipo, modalidade, localizacao, descricao) VALUES
  (1, 'Desenvolvedor Front-end Júnior', 'TechSolutions', 'vaga', 'remoto', 'Remoto', 'Construção de interfaces web responsivas com React em um time ágil.'),
  (2, 'Analista de Dados Júnior', 'DataBridge', 'vaga', 'hibrido', 'Campinas, SP', 'Análise de dados e criação de dashboards para áreas de negócio.'),
  (3, 'Desenvolvedor Back-end Júnior', 'CloudWorks', 'vaga', 'presencial', 'São Paulo, SP', 'APIs e integração com bancos de dados.'),
  (4, 'Projeto: Site para ONG local', 'Impacto Social', 'projeto', 'remoto', 'Remoto', 'Projeto voluntário para criar o site institucional de uma ONG.'),
  (5, 'Suporte Técnico N1', 'HelpDesk Pro', 'vaga', 'hibrido', 'São Paulo, SP', 'Atendimento e resolução de chamados de primeiro nível.');

-- Faz o próximo id automático continuar depois do último
SELECT setval('vagas_id_seq', (SELECT MAX(id) FROM vagas));

INSERT INTO vaga_requisitos (vaga_id, habilidade_id) VALUES
  (1, 'javascript'),
  (1, 'html'),
  (1, 'css'),
  (1, 'react'),
  (1, 'comunicacao'),
  (2, 'python'),
  (2, 'sql'),
  (2, 'analise-de-dados'),
  (3, 'java'),
  (3, 'spring'),
  (3, 'banco-de-dados'),
  (4, 'html'),
  (4, 'css'),
  (4, 'comunicacao'),
  (5, 'comunicacao'),
  (5, 'redes'),
  (5, 'organizacao');

INSERT INTO recursos (habilidade_id, titulo, fonte, tipo, url) VALUES
  ('javascript', 'JavaScript do zero', 'freeCodeCamp', 'Curso', 'https://www.freecodecamp.org/portuguese/news/o-manual-de-javascript-para-iniciantes/'),
  ('html', 'HTML para iniciantes', 'freeCodeCamp', 'Curso', 'https://youtu.be/sj0p9O85AIg?si=9Ni9pWihd790yzXz'),
  ('css', 'CSS responsivo', 'freeCodeCamp', 'Curso', 'https://www.freecodecamp.org/portuguese/news/como-tornar-seu-html-responsivo-adicionando-uma-unica-linha-de-css/'),
  ('react', 'React para iniciantes', 'YouTube', 'Vídeo', 'https://youtu.be/hd2B7XQAFls?si=qcji3uQvE7S79SwK'),
  ('comunicacao', 'Comunicação no trabalho', 'Gupy', 'Artigo', 'https://www.gupy.io/blog/comunicacao-no-trabalho'),
  ('python', 'Python básico', 'Curso gratuito', 'Curso', 'https://youtu.be/S9uPNppGsGo?si=Yc9Hqq4ulJYNuhmR'),
  ('sql', 'Introdução a SQL', 'Khan Academy', 'Curso', 'https://pt.khanacademy.org/search?referer=%2F&page_search_query=Introdu%C3%A7%C3%A3o+a+SQL'),
  ('analise-de-dados', 'Análise de dados básica', 'Curso gratuito', 'Curso', 'https://youtu.be/sxfYjczPOe8?si=5UoiUqxtxu2ym4kJ'),
  ('java', 'Java para iniciantes', 'Curso gratuito', 'Curso', 'https://www.freecodecamp.org/learn/javascript-v9/'),
  ('spring', 'Spring Boot primeiros passos', 'Documentação oficial', 'Guia', 'https://spring.io/guides/gs/spring-boot'),
  ('banco-de-dados', 'Modelagem de banco de dados', 'Curso gratuito', 'Curso', 'https://youtu.be/Q_KTYFgvu1s?si=RTV3axkMsUuCi-fu'),
  ('redes', 'Redes de computadores', 'Curso gratuito', 'Curso', 'https://youtu.be/QkMbqL8QD9w?si=xJf-CrdTl8SW5WN4'),
  ('organizacao', 'Gestão do tempo', 'Curso gratuito', 'Artigo', 'https://pepsic.bvsalud.org/pdf/psie/n47/n47a08.pdf');

-- Segurança: bloqueia o acesso às tabelas pela API automática do Supabase.
-- A nossa API (server.js) continua funcionando, porque conecta como dona do banco.
ALTER TABLE habilidades     ENABLE ROW LEVEL SECURITY;
ALTER TABLE vagas           ENABLE ROW LEVEL SECURITY;
ALTER TABLE vaga_requisitos ENABLE ROW LEVEL SECURITY;
ALTER TABLE recursos        ENABLE ROW LEVEL SECURITY;
