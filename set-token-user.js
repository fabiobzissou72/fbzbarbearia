const { createClient } = require('@supabase/supabase-js');

const supabase = createClient(
  'https://onrdpfcjbmkfpjfqydnk.supabase.co',
  'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9ucmRwZmNqYm1rZnBqZnF5ZG5rIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc3MDUyNTYzNSwiZXhwIjoyMDg2MTAxNjM1fQ.wyCARbyTpAP4Y4vriQv78-hNcAFE9SxGUqsV0u6IBSc'
);

const TOKEN_DO_USUARIO = 'fbzbarbearia_CsADnUx4ihoEJ2wKub2zwu0yLjCKqsVu9eGff3zIZDcv816v0pldCeZr8c4u52Cr';

async function atualizarToken() {
  console.log('Atualizando token no banco para o token fornecido pelo usuário...');

  const { data, error } = await supabase
    .from('configuracoes')
    .update({ api_token: TOKEN_DO_USUARIO })
    .neq('api_token', null);

  if (error) {
    console.log('ERRO:', error.message);
  } else {
    console.log('SUCESSO! Token atualizado');
    console.log('Novo token:', TOKEN_DO_USUARIO);
  }
}

atualizarToken().catch(console.error);
