import { createClientComponentClient, createServerComponentClient } from '@supabase/auth-helpers-nextjs'
import { Database } from '@/types/database.types'

// دالة المتصفح (Client) - آمنة تماماً للاستخدام في صفحات "use client"
export const createClient = () => createClientComponentClient<Database>()

// دالة السيرفر (Server) - تم تعديلها لتجنب استيراد next/headers في المتصفح
export const createServerClient = () => {
  if (typeof window === 'undefined') {
    // التحميل الديناميكي يمنع المتصفح من رؤية الاستيراد المحظور
    const { cookies } = require('next/headers')
    return createServerComponentClient<Database>({ cookies })
  }
  return createClient()
}
