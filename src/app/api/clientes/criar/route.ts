import { NextRequest, NextResponse } from 'next/server'
import { supabase } from '@/lib/supabase'
import { verificarAutenticacao } from '@/lib/auth'

export const dynamic = 'force-dynamic'

export async function POST(request: NextRequest) {
  try {
    // 🔐 AUTENTICAÇÃO (permite requisições internas do dashboard sem token)
    const { autorizado, erro } = await verificarAutenticacao(request)
    if (!autorizado) {
      return NextResponse.json(
        {
          success: false,
          message: 'Não autorizado',
          error: erro || 'Acesso negado'
        },
        { status: 401 }
      )
    }

    const body = await request.json()
    const {
      nome_completo,
      telefone,
      email,
      data_nascimento,
      profissao,
      estado_civil,
      tem_filhos,
      profissional_preferido,
      observacoes,
      is_vip,
      como_soube,
      gosta_conversar
    } = body

    // Validações básicas
    if (!nome_completo || !telefone) {
      return NextResponse.json(
        { success: false, error: 'nome_completo e telefone são obrigatórios' },
        { status: 400 }
      )
    }

    // Verificar se cliente já existe
    const { data: clienteExistente } = await supabase
      .from('clientes')
      .select('id, nome_completo')
      .eq('telefone', telefone)
      .single()

    if (clienteExistente) {
      return NextResponse.json(
        {
          success: false,
          error: 'Cliente já cadastrado com este telefone',
          cliente: clienteExistente
        },
        { status: 409 }
      )
    }

    // Criar cliente
    const { data: novoCliente, error: erroCliente } = await supabase
      .from('clientes')
      .insert([{
        nome_completo,
        telefone,
        email: email || null,
        data_nascimento: data_nascimento || null,
        profissao: profissao || null,
        estado_civil: estado_civil || null,
        tem_filhos: tem_filhos || null,
        profissional_preferido: profissional_preferido || null,
        observacoes: observacoes || null,
        is_vip: is_vip || false,
        como_soube: como_soube || null,
        gosta_conversar: gosta_conversar || null,
        data_cadastro: new Date().toISOString()
      }])
      .select()
      .single()

    if (erroCliente) {
      console.error('Erro ao criar cliente:', erroCliente)
      return NextResponse.json(
        { success: false, error: 'Erro ao criar cliente' },
        { status: 500 }
      )
    }

    return NextResponse.json({
      success: true,
      message: 'Cliente cadastrado com sucesso!',
      cliente: novoCliente
    })
  } catch (error) {
    console.error('Erro ao criar cliente:', error)
    return NextResponse.json(
      { success: false, error: 'Erro interno do servidor' },
      { status: 500 }
    )
  }
}
