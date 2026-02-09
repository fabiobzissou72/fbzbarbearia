-- ============================================
-- ADICIONAR TODAS AS COLUNAS NA TABELA configuracoes
-- Execute isso no SQL Editor do Supabase
-- ============================================

-- Adicionar coluna endereco
ALTER TABLE configuracoes
ADD COLUMN IF NOT EXISTS endereco TEXT;

-- Adicionar coluna telefone
ALTER TABLE configuracoes
ADD COLUMN IF NOT EXISTS telefone TEXT;

-- Adicionar coluna email
ALTER TABLE configuracoes
ADD COLUMN IF NOT EXISTS email TEXT;

-- Adicionar coluna nome_barbearia
ALTER TABLE configuracoes
ADD COLUMN IF NOT EXISTS nome_barbearia VARCHAR(255) DEFAULT 'FBZ Barbearia';

-- Adicionar coluna api_token
ALTER TABLE configuracoes
ADD COLUMN IF NOT EXISTS api_token TEXT;

-- Adicionar coluna horarios_por_dia (JSONB)
ALTER TABLE configuracoes
ADD COLUMN IF NOT EXISTS horarios_por_dia JSONB;

-- Adicionar coluna tempo_padrao_servico
ALTER TABLE configuracoes
ADD COLUMN IF NOT EXISTS tempo_padrao_servico INTEGER DEFAULT 30;

-- Adicionar coluna valor_minimo_agendamento
ALTER TABLE configuracoes
ADD COLUMN IF NOT EXISTS valor_minimo_agendamento DECIMAL(10,2) DEFAULT 0;

-- Adicionar coluna comissao_barbeiro_percentual
ALTER TABLE configuracoes
ADD COLUMN IF NOT EXISTS comissao_barbeiro_percentual INTEGER DEFAULT 50;

-- Adicionar coluna aceita_agendamento_online
ALTER TABLE configuracoes
ADD COLUMN IF NOT EXISTS aceita_agendamento_online BOOLEAN DEFAULT true;

-- Adicionar coluna prazo_cancelamento_horas
ALTER TABLE configuracoes
ADD COLUMN IF NOT EXISTS prazo_cancelamento_horas INTEGER DEFAULT 2;

-- Adicionar coluna notif_confirmacao
ALTER TABLE configuracoes
ADD COLUMN IF NOT EXISTS notif_confirmacao BOOLEAN DEFAULT true;

-- Adicionar coluna notif_lembrete_24h
ALTER TABLE configuracoes
ADD COLUMN IF NOT EXISTS notif_lembrete_24h BOOLEAN DEFAULT true;

-- Adicionar coluna notif_lembrete_2h
ALTER TABLE configuracoes
ADD COLUMN IF NOT EXISTS notif_lembrete_2h BOOLEAN DEFAULT true;

-- Adicionar coluna notif_followup_3d
ALTER TABLE configuracoes
ADD COLUMN IF NOT EXISTS notif_followup_3d BOOLEAN DEFAULT false;

-- Adicionar coluna notif_followup_21d
ALTER TABLE configuracoes
ADD COLUMN IF NOT EXISTS notif_followup_21d BOOLEAN DEFAULT false;

-- Adicionar coluna notif_cancelamento
ALTER TABLE configuracoes
ADD COLUMN IF NOT EXISTS notif_cancelamento BOOLEAN DEFAULT true;

-- Verificar colunas criadas
SELECT column_name, data_type, is_nullable
FROM information_schema.columns
WHERE table_name = 'configuracoes'
ORDER BY ordinal_position;
