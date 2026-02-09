import { NextRequest, NextResponse } from 'next/server'
import { supabase } from '@/lib/supabase'
import { verificarAutenticacao } from '@/lib/auth'

export const dynamic = 'force-dynamic'

/**
 * GET /api/planos/listar
 *
 * Retorna todos os planos ativos da barbearia
 *
 * Query params (opcional):
 * - ativo: true | false (filtrar por status)
 */
export async function GET(request: NextRequest) {
  try {
    // 🔐 AUTENTICAÇÃO (permite requisições internas do dashboard sem token)
    const { autorizado, erro } = await verificarAutenticacao(request)
    if (!autorizado) {
      return NextResponse.json({
        success: false,
        message: 'Não autorizado',
        error: erro || 'Acesso negado'
      }, { status: 401 })
    }

    const searchParams = request.nextUrl.searchParams
    const ativoParam = searchParams.get('ativo')

    // Construir query
    let query = supabase
      .from('planos')
      .select('*')
      .order('valor_total')

    // Filtrar por status ativo
    if (ativoParam !== null) {
      const ativo = ativoParam === 'true'
      query = query.eq('ativo', ativo)
    }

    const { data: planos, error } = await query

    if (error) {
      console.error('Erro ao buscar planos:', error)
      return NextResponse.json({
        success: false,
        error: 'Erro ao buscar planos'
      }, { status: 500 })
    }

    return NextResponse.json({
      success: true,
      total: planos?.length || 0,
      planos: planos || []
    })

  } catch (error) {
    console.error('Erro ao listar planos:', error)
    return NextResponse.json({
      success: false,
      error: 'Erro interno do servidor'
    }, { status: 500 })
  }
}
