-- ============================================================================
-- SCRIPT DE BANCO DE DADOS MYSQL - HELPDESK TI (INTEGRAÇÃO GITHUB + DB LOCAL)
-- Copywriting: Feito pelo Victor da Recepção e o João Victor da TI, feito com amor ❤️ (2026 em diante)
-- Compatível com MySQL 5.7+ / 8.0+ / MariaDB (XAMPP, WAMP, Laragon, Workbench)
-- ============================================================================

CREATE DATABASE IF NOT EXISTS helpdesk_ti
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE helpdesk_ti;

-- 1. Tabela de Configurações e Perfil do Técnico de TI (Sem Ramal)
CREATE TABLE IF NOT EXISTS configuracoes_ti (
  id INT PRIMARY KEY DEFAULT 1,
  nome_tecnico VARCHAR(120) NOT NULL DEFAULT 'João Victor',
  cargo_tecnico VARCHAR(120) NOT NULL DEFAULT 'Analista de Suporte TI',
  horario_expediente VARCHAR(60) NOT NULL DEFAULT '08:00 às 18:00',
  intervalo_almoco VARCHAR(60) NOT NULL DEFAULT '11:00 às 13:00',
  foto_ti LONGTEXT NULL,
  senha_pin VARCHAR(100) NOT NULL DEFAULT 'POLTI2026',
  atualizado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT IGNORE INTO configuracoes_ti (id, nome_tecnico, cargo_tecnico, senha_pin)
VALUES (1, 'João Victor', 'Analista de Suporte TI', 'POLTI2026');

-- 2. Tabela de Colaboradores / Ajudantes da Equipe (Sem Ramal)
CREATE TABLE IF NOT EXISTS colaboradores (
  id VARCHAR(50) PRIMARY KEY,
  nome VARCHAR(120) NOT NULL,
  funcao VARCHAR(120) DEFAULT 'Colaborador TI',
  ativo TINYINT(1) DEFAULT 1,
  criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT IGNORE INTO colaboradores (id, nome, funcao) VALUES
('COL-01', 'Victor (Recepção)', 'Recepção & Triagem de Chamados'),
('COL-02', 'Rafael Costa', 'Ajudante de Redes & Infra'),
('COL-03', 'Beatriz Santos', 'Especialista ERP / Sistemas'),
('COL-04', 'Diego Almeida', 'Apoio Técnico de Hardware');

-- 3. Tabela Principal de Chamados
CREATE TABLE IF NOT EXISTS chamados (
  id VARCHAR(40) PRIMARY KEY,
  setor VARCHAR(150) NOT NULL,
  responsavel VARCHAR(150) NOT NULL,
  categoria ENUM('Equipamento', 'Sistema', 'Internet') NOT NULL,
  descricao TEXT NULL,
  status ENUM('aberto', 'espera', 'concluido') NOT NULL DEFAULT 'aberto',
  resultado ENUM('resolvido', 'nao_resolvido') NULL DEFAULT NULL,
  parecer_tecnico TEXT NULL,
  ajudantes_json LONGTEXT NULL,
  comentarios_json LONGTEXT NULL,
  data_abertura VARCHAR(40) NOT NULL,
  data_resolucao VARCHAR(40) NULL DEFAULT NULL,
  criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  atualizado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 4. Dados Iniciais de Exemplo
INSERT IGNORE INTO chamados (id, setor, responsavel, categoria, descricao, status, resultado, parecer_tecnico, ajudantes_json, comentarios_json, data_abertura, data_resolucao)
VALUES
('CHAM-2026-001', 'Financeiro / Contabilidade', 'Fernanda Lima', 'Internet', 'Sem conexão com gateway 192.168.1.1. O computador perdeu o link de rede durante a conciliação bancária.', 'aberto', NULL, '', '["Victor (Recepção)", "Rafael Costa"]', '[{"autor":"Fernanda Lima","texto":"Preciso enviar o arquivo bancário até o fim do turno.","hora":"08:32"}]', '16/10/2026 08:30', NULL),
('CHAM-2026-002', 'Recursos Humanos (Sala 02)', 'Carlos Mendonça', 'Equipamento', 'Impressora multifuncional atola papel na bandeja 2 ao imprimir folha de ponto.', 'aberto', NULL, '', '["Diego Almeida"]', '[]', '16/10/2026 09:15', NULL),
('CHAM-2026-003', 'Comercial / Vendas', 'Juliana Costa', 'Sistema', 'Erro 403 - Permissão insuficiente no módulo de emissão de notas fiscais.', 'espera', NULL, '', '["Beatriz Santos"]', '[{"autor":"Beatriz Santos","texto":"Verificando permissões da tabela de faturamento no banco de dados.","hora":"09:44"}]', '16/10/2026 09:40', NULL),
('CHAM-2026-004', 'Logística & Estoque', 'Roberto Souza', 'Equipamento', 'Leitor de código de barras USB parou de ler etiquetas na expedição.', 'concluido', 'resolvido', 'Cabo USB substituído e leitor calibrado com código de fábrica com apoio do Diego Almeida.', '["Diego Almeida"]', '[]', '15/10/2026 15:20', '15/10/2026 17:10');
