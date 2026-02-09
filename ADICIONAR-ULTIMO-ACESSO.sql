-- ============================================
-- ADICIONAR COLUNA ultimo_acesso NA TABELA clientes
-- Execute isso no SQL Editor do Supabase
-- ============================================

-- Adicionar coluna ultimo_acesso
ALTER TABLE clientes
ADD COLUMN IF NOT EXISTS ultimo_acesso TIMESTAMPTZ;

-- Verificar se foi adicionada
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = 'clientes'
AND column_name = 'ultimo_acesso';
