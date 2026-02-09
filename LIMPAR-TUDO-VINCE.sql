-- ============================================
-- LIMPA TODAS AS REFERÊNCIAS À "VINCE" DO BANCO DE DADOS
-- Execute isso no SQL Editor do Supabase
-- ============================================

-- 1. Atualizar serviços
UPDATE servicos
SET nome = REPLACE(nome, 'Vinci', 'FBZ'),
    descricao = REPLACE(descricao, 'Vinci', 'FBZ'),
    nome = REPLACE(nome, 'Barbearia', 'Barbearia'),
    nome = CASE
        WHEN nome = 'FBZ' THEN 'Corte de Cabelo'
        ELSE nome
    END
WHERE nome LIKE '%Vinci%' OR nome LIKE 'FBZ' OR descricao LIKE '%Vinci%';

-- 2. Atualizar profissionais (barbeiros)
UPDATE profissionais
SET nome = REPLACE(nome, 'Vinci', 'FBZ'),
    nome = REPLACE(nome, 'Barbearia', '')
WHERE nome LIKE '%Vinci%' OR nome LIKE '%Barbearia';

-- 3. Atualizar agendamentos (histórico)
UPDATE agendamentos
SET observacoes = REPLACE(observacoes::text, 'Vinci', 'FBZ')::text
WHERE observacoes::text LIKE '%Vinci%';

-- 4. Verificar resultado
SELECT '✅ Serviços atualizados:' as info;
SELECT id, nome, descricao FROM servicos;

SELECT '✅ Profissionais atualizados:' as info;
SELECT id, nome, especialidades FROM profissionais WHERE ativo = true;

SELECT '✅ Total de serviços:' as info;
SELECT COUNT(*) as total FROM servicos;

SELECT '✅ Total de profissionais ativos:' as info;
SELECT COUNT(*) as total FROM profissionais WHERE ativo = true;
