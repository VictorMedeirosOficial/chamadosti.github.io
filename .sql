-- ============================================================================
-- SCRIPT DE BANCO DE DADOS MYSQL - PORTAL HELPDESK TI (LOCALHOST & REDE LOCAL)
-- Compatível com MySQL 5.7+ / 8.0+ / MariaDB (XAMPP, WAMP, Laragon, Workbench)
-- ============================================================================

CREATE DATABASE IF NOT EXISTS helpdesk_ti
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE helpdesk_ti;

-- 1. Tabela de Configurações e Perfil do Técnico de TI
CREATE TABLE IF NOT EXISTS configuracoes_ti (
  id INT PRIMARY KEY DEFAULT 1,
  nome_tecnico VARCHAR(120) NOT NULL DEFAULT 'Lucas Silva',
  cargo_tecnico VARCHAR(120) NOT NULL DEFAULT 'Analista de Suporte TI',
  ramal_tecnico VARCHAR(40) NOT NULL DEFAULT '2044',
  horario_expediente VARCHAR(60) NOT NULL DEFAULT '08:00 às 18:00',
  intervalo_almoco VARCHAR(60) NOT NULL DEFAULT '11:00 às 13:00',
  foto_ti LONGTEXT NULL,
  senha_pin VARCHAR(100) NOT NULL DEFAULT '1234',
  atualizado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT IGNORE INTO configuracoes_ti (id, nome_tecnico, cargo_tecnico, ramal_tecnico, senha_pin)
VALUES (1, 'Lucas Silva', 'Analista de Suporte TI', '2044', '1234');

-- 2. Tabela de Colaboradores / Ajudantes que auxiliam na resolução dos chamados
CREATE TABLE IF NOT EXISTS colaboradores (
  id VARCHAR(50) PRIMARY KEY,
  nome VARCHAR(120) NOT NULL,
  funcao VARCHAR(100) DEFAULT 'Colaborador / Ajudante',
  setor VARCHAR(100) DEFAULT 'Suporte / Apoio',
  ramal VARCHAR(40) DEFAULT '',
  cor_badge VARCHAR(40) DEFAULT 'blue',
  ativo TINYINT(1) DEFAULT 1,
  criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT IGNORE INTO colaboradores (id, nome, funcao, setor, ramal, cor_badge) VALUES
('COL-01', 'Rafael Costa', 'Ajudante de Redes & Infra', 'TI / Infraestrutura', '2045', 'indigo'),
('COL-02', 'Beatriz Santos', 'Especialista ERP / Sistemas', 'Sistemas', '2046', 'emerald'),
('COL-03', 'Diego Almeida', 'Apoio Técnico de Hardware', 'Manutenção', '2048', 'amber'),
('COL-04', 'Camila Rocha', 'Colaboradora de Apoio N1', 'HelpDesk', '2050', 'purple');

-- 3. Tabela Principal de Chamados (Setor aberto para digitação, Descrição opcional, Sem SLA fixo)
CREATE TABLE IF NOT EXISTS chamados (
  id VARCHAR(40) PRIMARY KEY,
  setor VARCHAR(150) NOT NULL,
  responsavel VARCHAR(150) NOT NULL,
  categoria ENUM('Equipamento', 'Sistema', 'Internet') NOT NULL,
  urgencia ENUM('Normal', 'Alta', 'Urgente') NOT NULL DEFAULT 'Normal',
  descricao TEXT NULL,
  status ENUM('aberto', 'espera', 'concluido') NOT NULL DEFAULT 'aberto',
  resultado ENUM('resolvido', 'nao_resolvido') NULL DEFAULT NULL,
  parecer_tecnico TEXT NULL,
  ajudantes_json JSON NULL,
  comentarios_json JSON NULL,
  data_abertura VARCHAR(40) NOT NULL,
  data_resolucao VARCHAR(40) NULL DEFAULT NULL,
  criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  atualizado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 4. Tabela Relacional Chamado <-> Ajudantes (Normalizada para consultas SQL e relatórios)
CREATE TABLE IF NOT EXISTS chamado_ajudantes (
  id INT AUTO_INCREMENT PRIMARY KEY,
  chamado_id VARCHAR(40) NOT NULL,
  nome_ajudante VARCHAR(120) NOT NULL,
  funcao_ajudante VARCHAR(100) NULL,
  adicionado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_ca_chamado FOREIGN KEY (chamado_id) REFERENCES chamados(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 5. Dados Iniciais de Exemplo
INSERT IGNORE INTO chamados (id, setor, responsavel, categoria, urgencia, descricao, status, resultado, parecer_tecnico, ajudantes_json, comentarios_json, data_abertura, data_resolucao)
VALUES
('CHAM-2026-001', 'Financeiro / Contabilidade', 'Fernanda Lima (Ramal 104)', 'Internet', 'Urgente', '[Erro na Tela]: Sem conexão com gateway 192.168.1.1
O computador perdeu o link de rede durante a conciliação bancária.', 'aberto', NULL, '', '["Rafael Costa"]', '[{"autor":"Fernanda Lima","texto":"Preciso enviar a remessa bancária ainda hoje.","hora":"08:32"}]', '15/10/2026 08:30', NULL),
('CHAM-2026-002', 'Recursos Humanos (Sala 02)', 'Carlos Mendonça (Ramal 210)', 'Equipamento', 'Normal', '[Nº Patrimônio/Máquina]: PAT-TI-8841
Impressora multifuncional atola papel na bandeja 2.', 'aberto', NULL, '', '["Diego Almeida"]', '[]', '15/10/2026 09:15', NULL),
('CHAM-2026-003', 'Comercial & Vendas', 'Juliana Costa (Ramal 305)', 'Sistema', 'Alta', '[Erro na Tela]: Erro 403 - Permissão insuficiente no módulo de faturamento.', 'espera', NULL, '', '["Beatriz Santos", "Camila Rocha"]', '[{"autor":"Beatriz Santos","texto":"Já estou verificando o perfil de acesso no banco de dados.","hora":"09:45"}]', '15/10/2026 09:40', NULL),
('CHAM-2026-004', 'Logística & Expedição', 'Roberto Souza (Ramal 412)', 'Equipamento', 'Normal', 'Leitor de código de barras USB parou de ler etiquetas.', 'concluido', 'resolvido', 'Cabo USB substituído e leitor recalibrado com sucesso.', '["Diego Almeida"]', '[]', '14/10/2026 15:20', '14/10/2026 17:10');
```[cite: 6]
