import { NextRequest, NextResponse } from 'next/server'
import { supabase } from '@/lib/supabase'
import { verificarAutenticacao } from '@/lib/auth'

export const dynamic = 'force-dynamic'

/**
 * GET /api/servicos
 *
 * Lista todos os serviços ativos da barbearia
 */
export async function GET(request: NextRequest) {
  try {
    // 🔐 AUTENTICAÇÃO (permite requisições internas do dashboard sem token)
    const { autorizado, erro } = await verificarAutenticacao(request)
    if (!autorizado) {
      return NextResponse.json({
        success: false,
        message: 'Não autorizado',
        errors: [erro || 'Acesso negado']
      }, { status: 401 })
    }

    const { data: servicos, error } = await supabase
      .from('servicos')
      .select('*')
      .eq('ativo', true)
      .order('nome')

    if (error) {
      console.error('Erro ao buscar serviços:', error)
      return NextResponse.json({
        success: false,
        message: 'Erro ao buscar serviços',
        errors: [error.message]
      }, { status: 500 })
    }

    return NextResponse.json(servicos || [])

  } catch (error) {
    console.error('Erro ao listar serviços:', error)
    return NextResponse.json({
      success: false,
      message: 'Erro interno do servidor',
      errors: [error instanceof Error ? error.message : 'Erro desconhecido']
    }, { status: 500 })
  }
}

/**
 * POST /api/servicos
 *
 * Cria um novo serviço
 */
export async function POST(request: NextRequest) {
  try {
    // 🔐 AUTENTICAÇÃO (permite requisições internas do dashboard sem token)
    const { autorizado, erro } = await verificarAutenticacao(request)
    if (!autorizado) {
      return NextResponse.json({
        success: false,
        message: 'Não autorizado',
        errors: [erro || 'Acesso negado']
      }, { status: 401 })
    }

    const body = await request.json()
    const { nome, descricao, preco, duracao_minutos, categoria } = body

    if (!nome || !preco || !duracao_minutos) {
      return NextResponse.json({
        success: false,
        message: 'Dados obrigatórios faltando',
        errors: ['nome, preco e duracao_minutos são obrigatórios']
      }, { status: 400 })
    }

    const { data: servico, error } = await supabase
      .from('servicos')
      .insert({
        nome,
        descricao,
        preco,
        duracao_minutos,
        categoria,
        ativo: true
      })
      .select()
      .single()

    if (error) {
      return NextResponse.json({
        success: false,
        message: 'Erro ao criar serviço',
        errors: [error.message]
      }, { status: 500 })
    }

    return NextResponse.json({
      success: true,
      message: 'Serviço criado com sucesso',
      data: servico
    }, { status: 201 })

  } catch (error) {
    console.error('Erro ao criar serviço:', error)
    return NextResponse.json({
      success: false,
      message: 'Erro interno do servidor',
      errors: [error instanceof Error ? error.message : 'Erro desconhecido']
    }, { status: 500 })
  }
}

/**
 * PUT /api/servicos
 *
 * Atualiza um serviço existente
 */
export async function PUT(request: NextRequest) {
  try {
    // 🔐 AUTENTICAÇÃO (permite requisições internas do dashboard sem token)
    const { autorizado, erro } = await verificarAutenticacao(request)
    if (!autorizado) {
      return NextResponse.json({
        success: false,
        message: 'Não autorizado',
        errors: [erro || 'Acesso negado']
      }, { status: 401 })
    }

    const body = await request.json()
    const { id, nome, descricao, preco, duracao_minutos, categoria, ativo } = body

    if (!id) {
      return NextResponse.json({
        success: false,
        message: 'ID do serviço é obrigatório',
        errors: ['id é obrigatório']
      }, { status: 400 })
    }

    const { data: servico, error } = await supabase
      .from('servicos')
      .update({
        nome,
        descricao,
        preco,
        duracao_minutos,
        categoria,
        ativo
      })
      .eq('id', id)
      .select()
      .single()

    if (error) {
      return NextResponse.json({
        success: false,
        message: 'Erro ao atualizar serviço',
        errors: [error.message]
      }, { status: 500 })
    }

    return NextResponse.json({
      success: true,
      message: 'Serviço atualizado com sucesso',
      data: servico
    })

  } catch (error) {
    console.error('Erro ao atualizar serviço:', error)
    return NextResponse.json({
      success: false,
      message: 'Erro interno do servidor',
      errors: [error instanceof Error ? error.message : 'Erro desconhecido']
    }, { status: 500 })
  }
}

/**
 * DELETE /api/servicos
 *
 * Desativa um serviço (soft delete)
 */
export async function DELETE(request: NextRequest) {
  try {
    // 🔐 AUTENTICAÇÃO (permite requisições internas do dashboard sem token)
    const { autorizado, erro } = await verificarAutenticacao(request)
    if (!autorizado) {
      return NextResponse.json({
        success: false,
        message: 'Não autorizado',
        errors: [erro || 'Acesso negado']
      }, { status: 401 })
    }

    const { searchParams } = new URL(request.url)
    const id = searchParams.get('id')

    if (!id) {
      return NextResponse.json({
        success: false,
        message: 'ID do serviço é obrigatório',
        errors: ['id é obrigatório']
      }, { status: 400 })
    }

    // Soft delete - apenas marca como inativo
    const { error } = await supabase
      .from('servicos')
      .update({ ativo: false })
      .eq('id', id)

    if (error) {
      return NextResponse.json({
        success: false,
        message: 'Erro ao desativar serviço',
        errors: [error.message]
      }, { status: 500 })
    }

    return NextResponse.json({
      success: true,
      message: 'Serviço desativado com sucesso'
    })

  } catch (error) {
    console.error('Erro ao desativar serviço:', error)
    return NextResponse.json({
      success: false,
      message: 'Erro interno do servidor',
      errors: [error instanceof Error ? error.message : 'Erro desconhecido']
    }, { status: 500 })
  }
}
