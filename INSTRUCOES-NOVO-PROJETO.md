# 🚀 Instruções - Novo Projeto Barbearia

## ✅ Mudanças Realizadas

Todas as referências ao projeto "Vince" foram removidas e substituídas por "Barbearia":

### 1. **Arquivos de Configuração**
- ✅ `package.json` - Nome do projeto alterado para "barbearia"
- ✅ `.env.local` - Criado com novas credenciais Supabase

### 2. **Frontend**
- ✅ `src/app/layout.tsx` - Título alterado para "Barbearia - Dashboard"
- ✅ `src/app/dashboard/layout.tsx` - Branding atualizado
- ✅ `src/app/login/page.tsx` - Tela de login atualizada
- ✅ `public/manifest.json` - Manifest do app atualizado
- ✅ `public/logo.png` - Logo substituído (copiado da pasta `imagem/`)

### 3. **Domínio e Documentação**
- ✅ Todas as referências de `vincefbzbarbearia.vercel.app` → `fbzbarbearia.vercel.app`
- ✅ Atualizado em todos os arquivos `.md`, `.yaml`, `.sh`, `.py`

### 4. **Banco de Dados**
- ✅ Arquivo SQL completo criado: `SQL-COMPLETO-BARBEARIA.sql`

---

## 📋 Configuração do Supabase

### Credenciais Novas

**URL do Supabase:**
```
https://onrdpfcjbmkfpjfqydnk.supabase.co
```

**Anon Key (pública):**
```
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9ucmRwZmNqYm1rZnBqZnF5ZG5rIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzA1MjU2MzUsImV4cCI6MjA4NjEwMTYzNX0.a-pjpXUIk4PDEQrOKDDtjGVpJu8oGFBt23WQb5WcNls
```

**Service Role Key (admin/servidor):**
```
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9ucmRwZmNqYm1rZnBqZnF5ZG5rIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc3MDUyNTYzNSwiZXhwIjoyMDg2MTAxNjM1fQ.wyCARbyTpAP4Y4vriQv78-hNcAFE9SxGUqsV0u6IBSc
```

---

## 🗄️ Como Configurar o Banco de Dados

### Passo 1: Acessar o Supabase
1. Acesse: https://supabase.com/dashboard
2. Clique no projeto: `onrdpfcjbmkfpjfqydnk`
3. Vá em: **SQL Editor** (ícone de terminal no menu lateral)

### Passo 2: Executar o SQL Completo
1. Copie todo o conteúdo do arquivo `SQL-COMPLETO-BARBEARIA.sql`
2. Cole no SQL Editor do Supabase
3. Clique em **Run** (ou pressione Ctrl+Enter)

### Passo 3: Verificar se Tudo Foi Criado
Execute esta query para verificar as tabelas:
```sql
SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'public'
ORDER BY table_name;
```

Você deve ver estas tabelas:
- ✅ agendamentos
- ✅ agendamento_servicos
- ✅ clientes
- ✅ compras
- ✅ configuracoes
- ✅ cron_logs
- ✅ lembretes
- ✅ movimentos_financeiros
- ✅ planos
- ✅ profissionais
- ✅ profissionais_login
- ✅ produtos
- ✅ servicos
- ✅ webhooks_barbeiros

### Passo 4: Verificar o Cron Job
Execute esta query para confirmar o cron job diário:
```sql
SELECT * FROM cron.job WHERE jobname = 'keep-database-alive';
```

**O que o cron job faz:**
- Executa todos os dias às 3:00 AM
- Mantém o banco de dados ativo
- Evita o bloqueio do Supabase após 7 dias sem uso

---

## 🚀 Como Fazer Deploy na Vercel

### Opção 1: Pela Vercel CLI
```bash
# Instalar a Vercel CLI (se não tiver)
npm i -g vercel

# Fazer login
vercel login

# Deploy
vercel --prod
```

### Opção 2: Pelo Dashboard Vercel
1. Acesse: https://vercel.com/dashboard
2. Clique em **"Add New..."** → **"Project"**
3. Conecte seu repositório Git
4. Configure:
   - **Framework Preset**: Next.js
   - **Root Directory**: `./`
   - **Build Command**: `npm run build`
   - **Output Directory**: `.next`
5. Adicione as variáveis de ambiente (Environment Variables):
   ```
   NEXT_PUBLIC_SUPABASE_URL=https://onrdpfcjbmkfpjfqydnk.supabase.co
   NEXT_PUBLIC_SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
   SUPABASE_SERVICE_ROLE_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
   ```
6. Clique em **Deploy**

### Domínio Esperado
Após o deploy, seu app estará disponível em:
```
https://fbzbarbearia.vercel.app
```

---

## 🧪 Testar Localmente

```bash
# Instalar dependências (se ainda não instalou)
npm install

# Rodar em desenvolvimento
npm run dev

# Acessar
# http://localhost:3000
```

---

## 📊 Estrutura do SQL Completo

O arquivo `SQL-COMPLETO-BARBEARIA.sql` contém:

### 1. **Tabelas Criadas** (14 tabelas)
- clientes
- profissionais
- profissionais_login
- servicos
- produtos
- planos
- agendamentos
- agendamento_servicos
- movimentos_financeiros
- compras
- configuracoes
- webhooks_barbeiros
- lembretes
- cron_logs

### 2. **Índices de Performance**
Índices criados para as colunas mais usadas em buscas e filtros

### 3. **Triggers Automáticos**
- `updated_at` é atualizado automaticamente em todas as tabelas

### 4. **Cron Job Diário**
- Executa todos os dias às 3:00 AM
- Mantém o banco ativo (evita pausa após 7 dias)
- Registra logs em `cron_logs`

### 5. **Views Úteis**
- `vw_agendamentos_completos` - View com todos os detalhes dos agendamentos
- `vw_movimentos_detalhados` - View com movimentos financeiros detalhados

### 6. **Permissões Completas**
- RLS (Row Level Security) desabilitado
- Permissões FULL para todos os roles (postgres, anon, authenticated, service_role)
- Acesso total via API

### 7. **Políticas de Segurança**
- Todas as políticas liberadas para uso da API
- Acesso sem restrições para facilitar integração

---

## 🔧 Verificações Pós-Instalação

### 1. Verificar Tabelas
```sql
SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'public'
ORDER BY table_name;
```

### 2. Verificar Cron Job
```sql
SELECT * FROM cron.job WHERE jobname = 'keep-database-alive';
```

### 3. Verificar Logs do Cron
```sql
SELECT * FROM public.cron_logs
ORDER BY executed_at DESC
LIMIT 10;
```

### 4. Verificar Triggers
```sql
SELECT trigger_name, event_object_table
FROM information_schema.triggers
WHERE trigger_schema = 'public'
ORDER BY event_object_table, trigger_name;
```

### 5. Verificar Views
```sql
SELECT table_name, view_definition
FROM information_schema.views
WHERE table_schema = 'public'
ORDER BY table_name;
```

---

## 📝 Próximos Passos

1. **Executar o SQL completo** no Supabase
2. **Testar localmente** com `npm run dev`
3. **Fazer deploy** na Vercel
4. **Configurar domínio** personalizado (opcional)
5. **Testar todas as funcionalidades** do app

---

## 🎨 Personalização

### Alterar Logo
O logo atual está em:
- `public/logo.png`

Para trocar:
1. Coloque sua imagem na pasta `imagem/`
2. Copie para `public/logo.png`
3. Recomende-se usar PNG quadrado (512x512px)

### Alterar Cores
As cores principais estão em:
- `src/app/globals.css` - Variáveis CSS
- `tailwind.config.js` - Cores do Tailwind

Cor principal atual: `#0891b2` (Cyan)

---

## 🐛 Troubleshooting

### Erro: "Relation does not exist"
**Causa:** O SQL ainda não foi executado no Supabase
**Solução:** Execute o arquivo `SQL-COMPLETO-BARBEARIA.sql` no SQL Editor

### Erro: "Invalid API Key"
**Causa:** Credenciais incorretas no `.env.local`
**Solução:** Verifique se as chaves no arquivo `.env.local` estão corretas

### Cron Job não está funcionando
**Verificação:**
```sql
-- Verificar se pg_cron está instalado
SELECT * FROM pg_extension WHERE extname = 'pg_cron';

-- Verificar o job
SELECT * FROM cron.job WHERE jobname = 'keep-database-alive';
```

### Erro: "RLS policy exists"
**Causa:** RLS foi habilitado acidentalmente
**Solução:** O SQL já desabilita RLS em todas as tabelas

---

## 📞 Suporte

Se precisar de ajuda:
1. Verifique os logs do Supabase
2. Verifique os logs da Vercel (se estiver em produção)
3. Revise o arquivo `SQL-COMPLETO-BARBEARIA.sql`
4. Consulte a documentação em `docs/`

---

## ✨ Resumo

- ✅ Nome do projeto: **Barbearia**
- ✅ Domínio: **fbzbarbearia.vercel.app**
- ✅ Supabase URL: **https://onrdpfcjbmkfpjfqydnk.supabase.co**
- ✅ SQL completo: **SQL-COMPLETO-BARBEARIA.sql**
- ✅ Logo atualizado
- ✅ Todas as referências alteradas
- ✅ Cron job diário configurado
- ✅ Permissões completas liberadas

**Seu projeto está pronto para fazer deploy! 🚀**
