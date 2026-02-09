import { NextRequest, NextResponse } from 'next/server'
import { supabase } from '@/lib/supabase'
import { verificarAutenticacao } from '@/lib/auth'

export const dynamic = 'force-dynamic'

/**
 * GET /api/produtos/listar
 *
 * Retorna todos os produtos ativos da barbearia
 *
 * Query params (opcional):
 * - ativo: true | false (filtrar por status)
 * - categoria: string (filtrar por categoria)
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
    const categoria = searchParams.get('categoria')

    // Construir query
    let query = supabase
      .from('produtos')
      .select('*')
      .order('nome')

    // Filtrar por status ativo
    if (ativoParam !== null) {
      const ativo = ativoParam === 'true'
      query = query.eq('ativo', ativo)
    }

    // Filtrar por categoria
    if (categoria) {
      query = query.eq('categoria', categoria)
    }

    const { data: produtos, error } = await query

    if (error) {
      console.error('Erro ao buscar produtos:', error)
      return NextResponse.json({
        success: false,
        error: 'Erro ao buscar produtos'
      }, { status: 500 })
    }

    return NextResponse.json({
      success: true,
      total: produtos?.length || 0,
      produtos: produtos || []
    })

  } catch (error) {
    console.error('Erro ao listar produtos:', error)
    return NextResponse.json({
      success: false,
      error: 'Erro interno do servidor'
    }, { status: 500 })
  }
}
