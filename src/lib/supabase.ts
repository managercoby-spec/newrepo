import { createClientComponentClient } from '@supabase/auth-helpers-nextjs'
import { createServerComponentClient } from '@supabase/auth-helpers-nextjs'
import { cookies } from 'next/headers'
import { Database } from '@/types/database.types'

// دالة للكلاينت (تستخدم في الصفحات التي تبدأ بـ 'use client')
export const createClient = () => createClientComponentClient<Database>()

// دالة للسيرفر (تستخدم في Server Components فقط)
export const createServerClient = () => {
  // هذا الشرط يمنع الخطأ عند استدعاء الملف من جهة المتصفح
  if (typeof window !== 'undefined') return createClient()
  return createServerComponentClient<Database>({ cookies })
}
