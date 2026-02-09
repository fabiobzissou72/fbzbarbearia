-- ============================================
-- ADICIONAR COLUNDA api_token NA TABELA configuracoes
-- Execute isso no SQL Editor do Supabase
-- ============================================

-- 1. Adicionar coluna api_token
ALTER TABLE configuracoes
ADD COLUMN IF NOT EXISTS api_token TEXT;

-- 2. Verificar se já existe algum token
SELECT id, api_token, LEFT(api_token, 30) as token_preview
FROM configuracoes;

-- 3. Se não tiver token, inserir um novo com o prefixo correto
UPDATE configuracoes
SET api_token = 'fbzbarbearia_' || encode(gen_random_bytes(64), 'base64')
WHERE api_token IS NULL;

-- 4. Se já tiver token com prefixo antigo, atualizar
UPDATE configuracoes
SET api_token = REPLACE(api_token, 'vinci_', 'fbzbarbearia_')
WHERE api_token LIKE 'vinci_%';

-- 5. Verificar resultado final
SELECT id, api_token, LEFT(api_token, 30) as token_preview
FROM configuracoes;
