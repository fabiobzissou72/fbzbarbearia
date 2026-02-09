# 🚀 COMECE AQUI - Guia Rápido

## ✅ O Que Já Foi Feito

1. **Nome do projeto**: "vince-barbearia" → "barbearia"
2. **Domínio**: vincefbzbarbearia.vercel.app → fbzbarbearia.vercel.app
3. **Logo**: Substituído (imagem/logo.jpg → public/logo.png)
4. **Branding**: Todos os textos "Vince" removidos
5. **Supabase**: Novas credenciais configuradas
6. **SQL completo**: Criado com cron job diário

---

## 🎯 Próximos Passos (3 passos simples)

### 1️⃣ Configurar o Banco de Dados (5 min)

```sql
-- Acesse: https://supabase.com/dashboard
-- Abra o SQL Editor
-- Cole e execute o arquivo: SQL-COMPLETO-BARBEARIA.sql
```

### 2️⃣ Testar Localmente (2 min)

```bash
npm install
npm run dev
# Acesse: http://localhost:3000
```

### 3️⃣ Fazer Deploy na Vercel (5 min)

```bash
# Instalar Vercel CLI
npm i -g vercel

# Login e deploy
vercel login
vercel --prod
```

**Variáveis de ambiente na Vercel:**
- `NEXT_PUBLIC_SUPABASE_URL` = `https://onrdpfcjbmkfpjfqydnk.supabase.co`
- `NEXT_PUBLIC_SUPABASE_ANON_KEY` = (veja no .env.local)
- `SUPABASE_SERVICE_ROLE_KEY` = (veja no .env.local)

---

## 📁 Arquivos Importantes Criados

| Arquivo | Para Que Serve |
|---------|----------------|
| `.env.local` | Credenciais do Supabase |
| `SQL-COMPLETO-BARBEARIA.sql` | Script completo do banco |
| `INSTRUCOES-NOVO-PROJETO.md` | Instruções detalhadas |
| `COMECE-AQUI.md` | Este guia rápido |

---

## 🔑 Credenciais Supabase

**URL:**
```
https://onrdpfcjbmkfpjfqydnk.supabase.co
```

**Anon Key** (uso público/frontend):
```
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9ucmRwZmNqYm1rZnBqZnF5ZG5rIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzA1MjU2MzUsImV4cCI6MjA4NjEwMTYzNX0.a-pjpXUIk4PDEQrOKDDtjGVpJu8oGFBt23WQb5WcNls
```

**Service Role** (uso admin/backend):
```
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9ucmRwZmNqYm1rZnBqZnF5ZG5rIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc3MDUyNTYzNSwiZXhwIjoyMDg2MTAxNjM1fQ.wyCARbyTpAP4Y4vriQv78-hNcAFE9SxGUqsV0u6IBSc
```

---

## 🎯 O Que o SQL Faz

O arquivo `SQL-COMPLETO-BARBEARIA.sql` cria:

✅ **14 tabelas** completas
✅ **Índices** para performance
✅ **Triggers** para updated_at automático
✅ **Cron job** diário (3:00 AM) para manter banco ativo
✅ **Views** úteis para relatórios
✅ **Permissões FULL** liberadas para API
✅ **RLS desabilitado** para facilitar integração

---

## 🚀 Domínio na Vercel

Após o deploy, seu app estará em:
```
https://fbzbarbearia.vercel.app
```

---

## ✅ Checklist de Verificação

- [ ] SQL executado no Supabase
- [ ] Tabelas criadas (verifique no SQL Editor)
- [ ] Cron job agendado (roda às 3:00 AM)
- [ ] App funciona localmente
- [ ] Deploy feito na Vercel
- [ ] Variáveis de ambiente configuradas
- [ ] App acessível em fbzbarbearia.vercel.app

---

**Precisa de ajuda?** Leia `INSTRUCOES-NOVO-PROJETO.md` para detalhes completos! 📖
