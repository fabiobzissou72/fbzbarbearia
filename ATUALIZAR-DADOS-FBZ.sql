-- ============================================
-- ATUALIZA DADOS DA VINCE → FBZ BARBEARIA
-- Execute isso no SQL Editor do Supabase
-- ============================================

-- 1. Atualizar profissionais (barbeiros) - Mudar nome de "Vinci" para remover
UPDATE profissionais
SET nome = CASE
    WHEN nome LIKE '%Vinci%' THEN 'Fábio Zissou'
    WHEN nome LIKE '%Barbearia%' THEN 'Fábio Zissou'
    ELSE nome
END
WHERE nome LIKE '%Vinci%' OR nome LIKE '%Barbearia%';

-- 2. Atualizar serviços - remover referências à Vince
UPDATE servicos
SET nome = CASE
    WHEN nome LIKE '%Vinci%' THEN 'Corte de Cabelo'
    WHEN nome LIKE '%Barbearia%' THEN 'Corte Masculino'
    ELSE nome
END,
descricao = REPLACE(descricao, 'Vinci', 'FBZ')
WHERE nome LIKE '%Vinci%' OR nome LIKE '%Barbearia%' OR descricao LIKE '%Vinci%';

-- 3. Verificar resultado
SELECT '✅ Profissionais:' as info;
SELECT id, nome FROM profissionais WHERE ativo = true;

SELECT '✅ Serviços:' as info;
SELECT id, nome FROM servicos;

SELECT '✅ Total de profissionais ativos:' as info;
SELECT COUNT(*) as total FROM profissionais WHERE ativo = true;

SELECT '✅ Total de serviços:' as info;
SELECT COUNT(*) as total FROM servicos;
