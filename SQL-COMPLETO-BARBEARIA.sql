-- =====================================================
-- SQL COMPLETO - BARBEARIA
-- Banco de Dados: Supabase PostgreSQL
-- Criado em: 2025-02-08
-- =====================================================
-- Este script cria TODAS as tabelas, políticas, permissões
-- e o cron job diário para manter o banco ativo
-- =====================================================

-- =====================================================
-- 1. LIMPAR TABELAS EXISTENTES (se houver)
-- =====================================================
-- DESCOMENTE AS LINHAS ABAIXO SE PRECISAR LIMPAR E RECOMEÇAR
-- DROP TABLE IF EXISTS public.agendamento_servicos CASCADE;
-- DROP TABLE IF EXISTS public.movimentos_financeiros CASCADE;
-- DROP TABLE IF EXISTS public.compras CASCADE;
-- DROP TABLE IF EXISTS public.agendamentos CASCADE;
-- DROP TABLE IF EXISTS public.login CASCADE;
-- DROP TABLE IF EXISTS public.configuracoes CASCADE;
-- DROP TABLE IF EXISTS public.planos CASCADE;
-- DROP TABLE IF EXISTS public.produtos CASCADE;
-- DROP TABLE IF EXISTS public.servicos CASCADE;
-- DROP TABLE IF EXISTS public.profissionais CASCADE;
-- DROP TABLE IF EXISTS public.clientes CASCADE;

-- =====================================================
-- 2. EXTENSÕES NECESSÁRIAS
-- =====================================================
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pg_cron";

-- =====================================================
-- 3. TABELA: clientes
-- =====================================================
CREATE TABLE IF NOT EXISTS public.clientes (
  id UUID NOT NULL DEFAULT gen_random_uuid(),
  telefone VARCHAR(20) NOT NULL UNIQUE,
  nome_completo VARCHAR(255) NOT NULL,
  email VARCHAR(255),
  senha VARCHAR(255),
  data_nascimento DATE,
  profissao VARCHAR(100),
  estado_civil VARCHAR(50),
  tem_filhos VARCHAR(10),
  nomes_filhos TEXT[],
  idades_filhos TEXT[],
  estilo_cabelo VARCHAR(100),
  preferencias_corte TEXT,
  tipo_bebida VARCHAR(100),
  alergias TEXT,
  frequencia_retorno VARCHAR(50),
  profissional_preferido VARCHAR(255),
  observacoes TEXT,
  is_vip BOOLEAN DEFAULT FALSE,
  data_cadastro TIMESTAMPTZ DEFAULT NOW(),
  como_soube VARCHAR(100),
  gosta_conversar VARCHAR(50),
  menory_long TEXT,
  tratamento VARCHAR(100),
  ultimo_servico VARCHAR(255),
  plano_id UUID,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  CONSTRAINT clientes_pkey PRIMARY KEY (id)
);

-- Índices para performance
CREATE INDEX IF NOT EXISTS idx_clientes_telefone ON public.clientes(telefone);
CREATE INDEX IF NOT EXISTS idx_clientes_email ON public.clientes(email);
CREATE INDEX IF NOT EXISTS idx_clientes_nome ON public.clientes(nome_completo);
CREATE INDEX IF NOT EXISTS idx_clientes_vip ON public.clientes(is_vip);

-- =====================================================
-- 4. TABELA: profissionais
-- =====================================================
CREATE TABLE IF NOT EXISTS public.profissionais (
  id UUID NOT NULL DEFAULT gen_random_uuid(),
  nome VARCHAR(255) NOT NULL,
  telefone VARCHAR(20),
  email VARCHAR(255),
  especialidade VARCHAR(100),
  especialidades TEXT[],
  ativo BOOLEAN DEFAULT TRUE,
  data_cadastro TIMESTAMPTZ DEFAULT NOW(),
  cor_calendario VARCHAR(7) DEFAULT '#3B82F6',
  id_agenda VARCHAR(255),
  foto_url TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  CONSTRAINT profissionais_pkey PRIMARY KEY (id)
);

-- Índices
CREATE INDEX IF NOT EXISTS idx_profissionais_ativo ON public.profissionais(ativo);
CREATE INDEX IF NOT EXISTS idx_profissionais_email ON public.profissionais(email);

-- =====================================================
-- 5. TABELA: profissionais_login (autenticação)
-- =====================================================
CREATE TABLE IF NOT EXISTS public.profissionais_login (
  id UUID NOT NULL DEFAULT gen_random_uuid(),
  profissional_id UUID NOT NULL UNIQUE,
  email VARCHAR(100) NOT NULL UNIQUE,
  senha TEXT NOT NULL,
  ultimo_acesso TIMESTAMPTZ,
  ativo BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  CONSTRAINT profissionais_login_pkey PRIMARY KEY (id),
  CONSTRAINT fk_profissional FOREIGN KEY (profissional_id) REFERENCES public.profissionais(id) ON DELETE CASCADE
);

-- =====================================================
-- 6. TABELA: servicos
-- =====================================================
CREATE TABLE IF NOT EXISTS public.servicos (
  id UUID NOT NULL DEFAULT gen_random_uuid(),
  nome VARCHAR(255) NOT NULL,
  descricao TEXT,
  preco NUMERIC(10, 2) NOT NULL,
  duracao_minutos INTEGER NOT NULL DEFAULT 30,
  categoria VARCHAR(100),
  executor VARCHAR(100),
  ativo BOOLEAN DEFAULT TRUE,
  data_cadastro TIMESTAMPTZ DEFAULT NOW(),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  CONSTRAINT servicos_pkey PRIMARY KEY (id)
);

CREATE INDEX IF NOT EXISTS idx_servicos_ativo ON public.servicos(ativo);

-- =====================================================
-- 7. TABELA: produtos
-- =====================================================
CREATE TABLE IF NOT EXISTS public.produtos (
  id UUID NOT NULL DEFAULT gen_random_uuid(),
  nome VARCHAR(255) NOT NULL,
  funcao TEXT,
  descricao TEXT,
  preco NUMERIC(10, 2) NOT NULL,
  beneficios TEXT,
  contra_indicacoes TEXT,
  categoria VARCHAR(100),
  ativo BOOLEAN DEFAULT TRUE,
  estoque INTEGER DEFAULT 0,
  data_cadastro TIMESTAMPTZ DEFAULT NOW(),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  CONSTRAINT produtos_pkey PRIMARY KEY (id)
);

CREATE INDEX IF NOT EXISTS idx_produtos_ativo ON public.produtos(ativo);
CREATE INDEX IF NOT EXISTS idx_produtos_categoria ON public.produtos(categoria);

-- =====================================================
-- 8. TABELA: planos
-- =====================================================
CREATE TABLE IF NOT EXISTS public.planos (
  id UUID NOT NULL DEFAULT gen_random_uuid(),
  nome VARCHAR(255) NOT NULL,
  itens_inclusos TEXT NOT NULL,
  valor_total NUMERIC(10, 2) NOT NULL,
  valor_original NUMERIC(10, 2) NOT NULL,
  economia NUMERIC(10, 2) NOT NULL,
  validade_dias INTEGER DEFAULT 30,
  ativo BOOLEAN DEFAULT TRUE,
  data_cadastro TIMESTAMPTZ DEFAULT NOW(),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  CONSTRAINT planos_pkey PRIMARY KEY (id)
);

CREATE INDEX IF NOT EXISTS idx_planos_ativo ON public.planos(ativo);

-- =====================================================
-- 9. TABELA: agendamentos
-- =====================================================
CREATE TABLE IF NOT EXISTS public.agendamentos (
  id UUID NOT NULL DEFAULT gen_random_uuid(),
  cliente_id UUID,
  profissional_id UUID,
  servico_id UUID,
  data_agendamento VARCHAR(20) NOT NULL, -- DD/MM/YYYY
  hora_inicio VARCHAR(5) NOT NULL, -- HH:MM
  status VARCHAR(50) DEFAULT 'agendado',
  observacoes TEXT,
  valor NUMERIC(10, 2),
  google_calendar_event_id VARCHAR(255),
  data_criacao TIMESTAMPTZ DEFAULT NOW(),
  nome_cliente VARCHAR(255),
  telefone VARCHAR(20),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  compareceu BOOLEAN,
  checkin_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  CONSTRAINT agendamentos_pkey PRIMARY KEY (id),
  CONSTRAINT fk_cliente FOREIGN KEY (cliente_id) REFERENCES public.clientes(id) ON DELETE SET NULL,
  CONSTRAINT fk_profissional FOREIGN KEY (profissional_id) REFERENCES public.profissionais(id) ON DELETE SET NULL,
  CONSTRAINT fk_servico FOREIGN KEY (servico_id) REFERENCES public.servicos(id) ON DELETE SET NULL
);

-- Índices para performance
CREATE INDEX IF NOT EXISTS idx_agendamentos_data ON public.agendamentos(data_agendamento);
CREATE INDEX IF NOT EXISTS idx_agendamentos_cliente ON public.agendamentos(cliente_id);
CREATE INDEX IF NOT EXISTS idx_agendamentos_telefone ON public.agendamentos(telefone);
CREATE INDEX IF NOT EXISTS idx_agendamentos_profissional ON public.agendamentos(profissional_id);
CREATE INDEX IF NOT EXISTS idx_agendamentos_status ON public.agendamentos(status);
CREATE INDEX IF NOT EXISTS idx_agendamentos_data_hora ON public.agendamentos(data_agendamento, hora_inicio);

-- =====================================================
-- 10. TABELA: agendamento_servicos (múltiplos serviços)
-- =====================================================
CREATE TABLE IF NOT EXISTS public.agendamento_servicos (
  id UUID NOT NULL DEFAULT gen_random_uuid(),
  agendamento_id UUID NOT NULL,
  servico_id UUID NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  CONSTRAINT agendamento_servicos_pkey PRIMARY KEY (id),
  CONSTRAINT fk_agendamento FOREIGN KEY (agendamento_id) REFERENCES public.agendamentos(id) ON DELETE CASCADE,
  CONSTRAINT fk_servico_rel FOREIGN KEY (servico_id) REFERENCES public.servicos(id) ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS idx_ag_servicos_agendamento ON public.agendamento_servicos(agendamento_id);

-- =====================================================
-- 11. TABELA: movimentos_financeiros
-- =====================================================
CREATE TABLE IF NOT EXISTS public.movimentos_financeiros (
  id UUID NOT NULL DEFAULT gen_random_uuid(),
  tipo VARCHAR(20) NOT NULL CHECK (tipo IN ('entrada', 'saida')),
  categoria VARCHAR(100),
  descricao TEXT,
  valor NUMERIC(10, 2) NOT NULL,
  data_movimento VARCHAR(20) NOT NULL, -- DD/MM/YYYY
  profissional_id UUID,
  agendamento_id UUID,
  metodo_pagamento VARCHAR(50),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  CONSTRAINT movimentos_financeiros_pkey PRIMARY KEY (id),
  CONSTRAINT fk_mov_profissional FOREIGN KEY (profissional_id) REFERENCES public.profissionais(id) ON DELETE SET NULL,
  CONSTRAINT fk_mov_agendamento FOREIGN KEY (agendamento_id) REFERENCES public.agendamentos(id) ON DELETE SET NULL
);

-- Índices
CREATE INDEX IF NOT EXISTS idx_movimentos_data ON public.movimentos_financeiros(data_movimento);
CREATE INDEX IF NOT EXISTS idx_movimentos_tipo ON public.movimentos_financeiros(tipo);
CREATE INDEX IF NOT EXISTS idx_movimentos_profissional ON public.movimentos_financeiros(profissional_id);

-- =====================================================
-- 12. TABELA: compras (produtos vendidos)
-- =====================================================
CREATE TABLE IF NOT EXISTS public.compras (
  id UUID NOT NULL DEFAULT gen_random_uuid(),
  cliente_id UUID,
  produto_id UUID,
  agendamento_id UUID,
  quantidade INTEGER DEFAULT 1,
  valor_unitario NUMERIC(10, 2),
  valor_total NUMERIC(10, 2),
  data_compra TIMESTAMPTZ DEFAULT NOW(),
  status VARCHAR(50) DEFAULT 'pendente',
  created_at TIMESTAMPTZ DEFAULT NOW(),
  CONSTRAINT compras_pkey PRIMARY KEY (id),
  CONSTRAINT fk_compra_cliente FOREIGN KEY (cliente_id) REFERENCES public.clientes(id) ON DELETE SET NULL,
  CONSTRAINT fk_compra_produto FOREIGN KEY (produto_id) REFERENCES public.produtos(id) ON DELETE SET NULL,
  CONSTRAINT fk_compra_agendamento FOREIGN KEY (agendamento_id) REFERENCES public.agendamentos(id) ON DELETE SET NULL
);

-- =====================================================
-- 13. TABELA: configuracoes
-- =====================================================
CREATE TABLE IF NOT EXISTS public.configuracoes (
  id UUID NOT NULL DEFAULT gen_random_uuid(),
  webhook_url TEXT,
  webhook_senha_temporaria TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  CONSTRAINT configuracoes_pkey PRIMARY KEY (id)
);

-- Inserir registro padrão se não existir
INSERT INTO public.configuracoes (webhook_url)
SELECT NULL
WHERE NOT EXISTS (SELECT 1 FROM public.configuracoes);

-- =====================================================
-- 14. TABELA: webhooks_barbeiros (webhooks por barbeiro)
-- =====================================================
CREATE TABLE IF NOT EXISTS public.webhooks_barbeiros (
  id UUID NOT NULL DEFAULT gen_random_uuid(),
  profissional_id UUID NOT NULL,
  webhook_url TEXT NOT NULL,
  webhook_senha TEXT,
  ativo BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  CONSTRAINT webhooks_barbeiros_pkey PRIMARY KEY (id),
  CONSTRAINT fk_webhook_profissional FOREIGN KEY (profissional_id) REFERENCES public.profissionais(id) ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS idx_webhooks_profissional ON public.webhooks_barbeiros(profissional_id);
CREATE INDEX IF NOT EXISTS idx_webhooks_ativo ON public.webhooks_barbeiros(ativo);

-- =====================================================
-- 15. TABELA: lembretes (system de lembretes)
-- =====================================================
CREATE TABLE IF NOT EXISTS public.lembretes (
  id UUID NOT NULL DEFAULT gen_random_uuid(),
  agendamento_id UUID NOT NULL,
  tipo VARCHAR(50) DEFAULT 'whatsapp',
  status VARCHAR(50) DEFAULT 'pendente',
  data_envio TIMESTAMPTZ,
  mensagem TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  CONSTRAINT lembretes_pkey PRIMARY KEY (id),
  CONSTRAINT fk_lembrete_agendamento FOREIGN KEY (agendamento_id) REFERENCES public.agendamentos(id) ON DELETE CASCADE
);

-- =====================================================
-- 16. FUNÇÕES E TRIGGERS
-- =====================================================

-- Função para atualizar updated_at automaticamente
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Aplicar trigger em todas as tabelas com updated_at
DROP TRIGGER IF EXISTS update_clientes_updated_at ON public.clientes;
CREATE TRIGGER update_clientes_updated_at
  BEFORE UPDATE ON public.clientes
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS update_profissionais_updated_at ON public.profissionais;
CREATE TRIGGER update_profissionais_updated_at
  BEFORE UPDATE ON public.profissionais
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS update_profissionais_login_updated_at ON public.profissionais_login;
CREATE TRIGGER update_profissionais_login_updated_at
  BEFORE UPDATE ON public.profissionais_login
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS update_servicos_updated_at ON public.servicos;
CREATE TRIGGER update_servicos_updated_at
  BEFORE UPDATE ON public.servicos
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS update_produtos_updated_at ON public.produtos;
CREATE TRIGGER update_produtos_updated_at
  BEFORE UPDATE ON public.produtos
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS update_planos_updated_at ON public.planos;
CREATE TRIGGER update_planos_updated_at
  BEFORE UPDATE ON public.planos
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS update_agendamentos_updated_at ON public.agendamentos;
CREATE TRIGGER update_agendamentos_updated_at
  BEFORE UPDATE ON public.agendamentos
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS update_configuracoes_updated_at ON public.configuracoes;
CREATE TRIGGER update_configuracoes_updated_at
  BEFORE UPDATE ON public.configuracoes
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS update_webhooks_barbeiros_updated_at ON public.webhooks_barbeiros;
CREATE TRIGGER update_webhooks_barbeiros_updated_at
  BEFORE UPDATE ON public.webhooks_barbeiros
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- =====================================================
-- 17. CRON JOB DIÁRIO PARA MANTER BANCO ATIVO
-- =====================================================
-- Este cron job executa uma query simples a cada 24 horas
-- para evitar que o Supabase pause o banco após 7 dias sem uso

-- Criar tabela de controle de cron jobs
CREATE TABLE IF NOT EXISTS public.cron_logs (
  id UUID NOT NULL DEFAULT gen_random_uuid(),
  job_name VARCHAR(100) NOT NULL,
  executed_at TIMESTAMPTZ DEFAULT NOW(),
  status VARCHAR(50) DEFAULT 'success',
  details TEXT,
  CONSTRAINT cron_logs_pkey PRIMARY KEY (id)
);

-- Função que será executada pelo cron
CREATE OR REPLACE FUNCTION keep_database_alive()
RETURNS void AS $$
BEGIN
  -- Inserir log de execução
  INSERT INTO public.cron_logs (job_name, status, details)
  VALUES ('keep_alive', 'success', 'Database keep-alive executed at ' || NOW());

  -- Executar uma query simples em cada tabela principal
  PERFORM 1 FROM public.clientes LIMIT 1;
  PERFORM 1 FROM public.profissionais LIMIT 1;
  PERFORM 1 FROM public.agendamentos LIMIT 1;
  PERFORM 1 FROM public.servicos LIMIT 1;
  PERFORM 1 FROM public.produtos LIMIT 1;
  PERFORM 1 FROM public.movimentos_financeiros LIMIT 1;

  -- Atualizar timestamp na tabela de configurações
  UPDATE public.configuracoes
  SET updated_at = NOW()
  WHERE id IS NOT NULL;
END;
$$ LANGUAGE plpgsql;

-- Agendar o cron job para rodar todos os dias às 3:00 AM
-- Isso garante que o banco nunca fique 7 dias sem atividade
SELECT cron.schedule(
  'keep-database-alive',
  '0 3 * * *', -- Todos os dias às 3:00 AM
  'SELECT keep_database_alive();'
);

-- =====================================================
-- 18. RLS (Row Level Security) - DESABILITADO
-- =====================================================
-- RLS está desabilitado para facilitar acesso via API
-- Habilitar se precisar de multi-tenancy no futuro

ALTER TABLE public.clientes DISABLE ROW LEVEL SECURITY;
ALTER TABLE public.profissionais DISABLE ROW LEVEL SECURITY;
ALTER TABLE public.profissionais_login DISABLE ROW LEVEL SECURITY;
ALTER TABLE public.servicos DISABLE ROW LEVEL SECURITY;
ALTER TABLE public.produtos DISABLE ROW LEVEL SECURITY;
ALTER TABLE public.planos DISABLE ROW LEVEL SECURITY;
ALTER TABLE public.agendamentos DISABLE ROW LEVEL SECURITY;
ALTER TABLE public.agendamento_servicos DISABLE ROW LEVEL SECURITY;
ALTER TABLE public.movimentos_financeiros DISABLE ROW LEVEL SECURITY;
ALTER TABLE public.compras DISABLE ROW LEVEL SECURITY;
ALTER TABLE public.configuracoes DISABLE ROW LEVEL SECURITY;
ALTER TABLE public.webhooks_barbeiros DISABLE ROW LEVEL SECURITY;
ALTER TABLE public.lembretes DISABLE ROW LEVEL SECURITY;
ALTER TABLE public.cron_logs DISABLE ROW LEVEL SECURITY;

-- =====================================================
-- 19. GRANTS - PERMISSÕES COMPLETAS
-- =====================================================
-- Dar permissões completas para todos os roles
GRANT ALL ON ALL TABLES IN SCHEMA public TO postgres;
GRANT ALL ON ALL TABLES IN SCHEMA public TO anon;
GRANT ALL ON ALL TABLES IN SCHEMA public TO authenticated;
GRANT ALL ON ALL TABLES IN SCHEMA public TO service_role;

-- Permissões em sequências
GRANT ALL ON ALL SEQUENCES IN SCHEMA public TO postgres;
GRANT ALL ON ALL SEQUENCES IN SCHEMA public TO anon;
GRANT ALL ON ALL SEQUENCES IN SCHEMA public TO authenticated;
GRANT ALL ON ALL SEQUENCES IN SCHEMA public TO service_role;

-- Permissões em funções
GRANT ALL ON ALL FUNCTIONS IN SCHEMA public TO postgres;
GRANT ALL ON ALL FUNCTIONS IN SCHEMA public TO anon;
GRANT ALL ON ALL FUNCTIONS IN SCHEMA public TO authenticated;
GRANT ALL ON ALL FUNCTIONS IN SCHEMA public TO service_role;

-- Permissão para executar pg_cron (somente service_role)
GRANT USAGE ON SCHEMA cron TO service_role;
GRANT ALL ON ALL TABLES IN SCHEMA cron TO service_role;

-- =====================================================
-- 20. DADOS INICIAIS (Opcional - Descomente se precisar)
-- =====================================================

-- Inserir um profissional admin padrão (descomente se necessário)
-- INSERT INTO public.profissionais (nome, email, telefone, ativo)
-- VALUES ('Admin', 'admin@barbearia.com', '11999999999', true)
-- ON CONFLICT DO NOTHING;

-- Inserir alguns serviços básicos (descomente se necessário)
-- INSERT INTO public.servicos (nome, descricao, preco, duracao_minutos, categoria, ativo)
-- VALUES
--   ('Corte de Cabelo', 'Corte masculino completo', 50.00, 30, 'Cabelo', true),
--   ('Barba', 'Aparar e modelar barba', 35.00, 20, 'Barba', true),
--   ('Couro Cabeludo', 'Hidratação e limpeza', 40.00, 25, 'Tratamento', true)
-- ON CONFLICT DO NOTHING;

-- =====================================================
-- 21. VIEWS ÚTEIS (Opcional)
-- =====================================================

-- View para agendamentos com detalhes completos
CREATE OR REPLACE VIEW vw_agendamentos_completos AS
SELECT
  a.id,
  a.data_agendamento,
  a.hora_inicio,
  a.status,
  a.valor,
  a.nome_cliente,
  a.telefone,
  c.nome_completo AS cliente_nome,
  c.email AS cliente_email,
  p.nome AS profissional_nome,
  p.cor_calendario AS profissional_cor,
  s.nome AS servico_nome,
  s.preco AS servico_preco,
  a.observacoes,
  a.compareceu,
  a.checkin_at,
  a.created_at
FROM public.agendamentos a
LEFT JOIN public.clientes c ON a.cliente_id = c.id
LEFT JOIN public.profissionais p ON a.profissional_id = p.id
LEFT JOIN public.servicos s ON a.servico_id = s.id
ORDER BY a.data_agendamento DESC, a.hora_inicio DESC;

-- View para movimentos financeiros com detalhes
CREATE OR REPLACE VIEW vw_movimentos_detalhados AS
SELECT
  mf.id,
  mf.tipo,
  mf.categoria,
  mf.descricao,
  mf.valor,
  mf.data_movimento,
  mf.metodo_pagamento,
  p.nome AS profissional_nome,
  a.data_agendamento,
  c.nome_completo AS cliente_nome,
  mf.created_at
FROM public.movimentos_financeiros mf
LEFT JOIN public.profissionais p ON mf.profissional_id = p.id
LEFT JOIN public.agendamentos a ON mf.agendamento_id = a.id
LEFT JOIN public.clientes c ON a.cliente_id = c.id
ORDER BY mf.data_movimento DESC, mf.created_at DESC;

-- =====================================================
-- FIM DO SCRIPT
-- =====================================================
-- Para verificar se tudo foi criado corretamente:
--
-- SELECT table_name FROM information_schema.tables
-- WHERE table_schema = 'public'
-- ORDER BY table_name;
--
-- Para verificar o cron job:
-- SELECT * FROM cron.job WHERE jobname = 'keep-database-alive';
--
-- Para verificar os logs do cron:
-- SELECT * FROM public.cron_logs ORDER BY executed_at DESC LIMIT 10;
-- =====================================================
