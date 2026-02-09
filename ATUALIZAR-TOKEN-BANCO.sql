-- ============================================
-- ATUALIZAR TOKEN API NO BANCO DE DADOS
-- ============================================
-- Execute isso no SQL Editor do Supabase
-- https://supabase.com/dashboard/project/onrdpfcjbmkfpjfqydnk/sql

-- 1. Verificar token atual (antes de atualizar)
SELECT api_token, LEFT(api_token, 30) as token_preview
FROM configuracoes;

-- 2. Atualizar token - MUDAR prefixo de vinci_ para fbzbarbearia_
UPDATE configuracoes
SET api_token = REPLACE(api_token, 'vinci_', 'fbzbarbearia_');

-- 3. Verificar token atualizado (depois da atualização)
SELECT api_token, LEFT(api_token, 30) as token_preview
FROM configuracoes;

-- 4. Se precisar gerar um token completamente novo, use:
-- UPDATE configuracoes
-- SET api_token = 'fbzbarbearia_' || encode(gen_random_bytes(64), 'base64');
-- (isso vai gerar um token aleatório novo)
