import './globals.css'
import type { Metadata } from 'next'
import { Plus_Jakarta_Sans } from 'next/font/google'

const jakartaSans = Plus_Jakarta_Sans({ 
  subsets: ['latin'],
  variable: '--font-jakarta',
})

export const metadata: Metadata = {
  title: 'Veedco - AI Video Generation Platform',
  description: 'Transform your ideas into stunning videos with AI',
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="en">
      <head>
        <link
          href="https://fonts.googleapis.com/css2?family=Syne:wght@600;700;800&display=swap"
          rel="stylesheet"
        />
      </head>
      <body className={`${jakartaSans.className} bg-black text-white antialiased`}>
        {children}
      </body>
    </html>
  )
}
