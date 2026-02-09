# 🔧 Configurar Variáveis de Ambiente na Vercel

## Erro: Missing env.NEXT_PUBLIC_SUPABASE_URL

Este erro acontece porque as variáveis de ambiente do Supabase não estão configuradas na Vercel.

---

## 📋 Passo a Passo - Configurar na Vercel

### 1️⃣ Acessar o Dashboard da Vercel

1. Acesse: https://vercel.com/dashboard
2. Encontre seu projeto **barbearia**
3. Clique no projeto
4. Vá em: **Settings** → **Environment Variables**

### 2️⃣ Adicionar as 3 Variáveis de Ambiente

Clique em **"Add New"** e adicione uma por uma:

#### Variável 1: NEXT_PUBLIC_SUPABASE_URL
```
Name: NEXT_PUBLIC_SUPABASE_URL
Value: https://onrdpfcjbmkfpjfqydnk.supabase.co
Environment: ✓ Production ✓ Preview ✓ Development
```

#### Variável 2: NEXT_PUBLIC_SUPABASE_ANON_KEY
```
Name: NEXT_PUBLIC_SUPABASE_ANON_KEY
Value: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9ucmRwZmNqYm1rZnBqZnF5ZG5rIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzA1MjU2MzUsImV4cCI6MjA4NjEwMTYzNX0.a-pjpXUIk4PDEQrOKDDtjGVpJu8oGFBt23WQb5WcNls
Environment: ✓ Production ✓ Preview ✓ Development
```

#### Variável 3: SUPABASE_SERVICE_ROLE_KEY
```
Name: SUPABASE_SERVICE_ROLE_KEY
Value: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9ucmRwZmNqYm1rZnBqZnF5ZG5rIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc3MDUyNTYzNSwiZXhwIjoyMDg2MTAxNjM1fQ.wyCARbyTpAP4Y4vriQv78-hNcAFE9SxGUqsV0u6IBSc
Environment: ✓ Production ✓ Preview ✓ Development
```

### 3️⃣ Salvar e Rebuild

1. Clique em **"Save"** após cada variável adicionada
2. Vá em: **Deployments**
3. Encontre o deployment mais recente
4. Clique nos 3 pontos (...) → **Redeploy**
5. Confirme clicando em **"Redeploy"**

---

## 🖼️ Screenshots - Onde Ficar

### Configurar Environment Variables:
```
Vercel Dashboard
  └─ Seu Projeto (barbearia)
      └─ Settings
          └─ Environment Variables
              └─ Add New
```

### Fazer Rebuild:
```
Vercel Dashboard
  └─ Seu Projeto (barbearia)
      └─ Deployments
          └─ [último deployment]
              └─ (...) → Redeploy
```

---

## ✅ Verificar se Funcionou

Após o rebuild, acesse:
```
https://fbzbarbearia.vercel.app
```

Se aparecer o site, **funcionou!** 🎉

---

## 🔑 Chaves Copiar e Colar

### NEXT_PUBLIC_SUPABASE_URL
```
https://onrdpfcjbmkfpjfqydnk.supabase.co
```

### NEXT_PUBLIC_SUPABASE_ANON_KEY
```
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9ucmRwZmNqYm1rZnBqZnF5ZG5rIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzA1MjU2MzUsImV4cCI6MjA4NjEwMTYzNX0.a-pjpXUIk4PDEQrOKDDtjGVpJu8oGFBt23WQb5WcNls
```

### SUPABASE_SERVICE_ROLE_KEY
```
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9ucmRwZmNqYm1rZnBqZnF5ZG5rIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc3MDUyNTYzNSwiZXhwIjoyMDg2MTAxNjM1fQ.wyCARbyTpAP4Y4vriQv78-hNcAFE9SxGUqsV0u6IBSc
```

---

## ⚠️ Importante

- **NUNCA** commite o arquivo `.env.local` no GitHub (ele está no .gitignore)
- Estas chaves estão no arquivo `.env.example` apenas para referência
- Na Vercel, as variáveis ficam seguras e criptografadas
- Variáveis que começam com `NEXT_PUBLIC_` ficam disponíveis no navegador
- Variáveis sem `NEXT_PUBLIC_` ficam apenas no servidor (mais seguras)

---

## 🚀 Após Configurar

1. Rebuild o deployment na Vercel
2. Teste o site: https://fbzbarbearia.vercel.app
3. Execute o SQL no Supabase (SQL-COMPLETO-BARBEARIA.sql)
4. Teste fazer login

---

## 📞 Ainda com Erro?

### Verificar Logs na Vercel:
1. Vá em: **Deployments** → [último deployment]
2. Clique em **"View Function Logs"**
3. Procure por erros de "Missing env"

### Verificar se Variáveis Foram Salvas:
1. Vá em: **Settings** → **Environment Variables**
2. Confirme que as 3 variáveis estão lá
3. Verifique se estão marcadas para **Production**, **Preview** e **Development**

---

**Resumo:** Adicione as 3 variáveis na Vercel e faça rebuild! 🎯
