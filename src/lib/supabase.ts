import { createClientComponentClient, createServerComponentClient } from '@supabase/auth-helpers-nextjs'
import { Database } from '@/types/database.types'

// دالة المتصفح (Client) - آمنة للاستخدام في أي مكان
export const createClient = () => createClientComponentClient<Database>()

// دالة السيرفر (Server) - لن تسبب خطأ لأن الاستيراد يحدث داخلها فقط
export const createServerClient = () => {
  if (typeof window === 'undefined') {
    const { cookies } = require('next/headers')
    return createServerComponentClient<Database>({ cookies })
  }
  return createClient()
}
