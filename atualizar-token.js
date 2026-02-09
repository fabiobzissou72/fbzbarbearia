const { createClient } = require('@supabase/supabase-js');

const supabase = createClient(
  'https://onrdpfcjbmkfpjfqydnk.supabase.co',
  'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9ucmRwZmNqYm1rZnBqZnF5ZG5rIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc3MDUyNTYzNSwiZXhwIjoyMDg2MTAxNjM1fQ.wyCARbyTpAP4Y4vriQv78-hNcAFE9SxGUqsV0u6IBSc'
);

async function atualizarToken() {
  console.log('Buscando token atual...');

  const { data: config } = await supabase
    .from('configuracoes')
    .select('api_token')
    .single();

  if (!config || !config.api_token) {
    console.log('ERRO: Configuracao ou token nao encontrado');
    return;
  }

  const tokenAntigo = config.api_token;
  console.log('Token antigo (primeiros 30 chars):', tokenAntigo.substring(0, 30));

  const novoToken = 'fbzbarbearia_' + tokenAntigo.substring(6);
  console.log('Atualizando token...');

  const { data, error } = await supabase
    .from('configuracoes')
    .update({ api_token: novoToken })
    .eq('api_token', tokenAntigo);

  if (error) {
    console.log('ERRO ao atualizar:', error.message);
  } else if (data && data.length > 0) {
    console.log('SUCESSO! Token atualizado');
    console.log('Novo token (primeiros 30 chars):', novoToken.substring(0, 30));
    console.log('');
    console.log('Token completo:', novoToken);
  }
}

atualizarToken().catch(console.error);