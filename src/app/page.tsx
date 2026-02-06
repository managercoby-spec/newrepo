'use client'

import Link from 'next/link'
import { useState } from 'react'

export default function Home() {
  const [email, setEmail] = useState('')

  return (
    <div className="min-h-screen flex flex-col">
      {/* Header */}
      <header className="fixed top-0 left-0 right-0 z-50 bg-black/80 backdrop-blur-md border-b border-gray-800">
        <div className="max-w-7xl mx-auto px-6 py-4 flex items-center justify-between">
          <h1 className="text-3xl font-display font-bold text-gradient">
            Veedco
          </h1>
          <div className="flex items-center gap-4">
            <Link 
              href="/auth/login"
              className="text-gray-300 hover:text-white transition"
            >
              Login
            </Link>
            <Link 
              href="/auth/signup"
              className="bg-gradient-to-r from-veedco-cyan to-veedco-cyan-light px-6 py-2.5 rounded-lg font-semibold hover:shadow-lg hover:shadow-veedco-cyan/30 transition"
            >
              Get Started
            </Link>
          </div>
        </div>
      </header>

      {/* Hero Section */}
      <main className="flex-1 flex items-center justify-center px-6 pt-24">
        <div className="max-w-4xl mx-auto text-center">
          <h2 className="text-6xl md:text-7xl font-display font-bold mb-6 leading-tight">
            Create <span className="text-gradient">Amazing Videos</span>
            <br />
            with AI
          </h2>
          <p className="text-xl text-gray-400 mb-12 max-w-2xl mx-auto">
            Transform your ideas into stunning videos in seconds. 
            Powered by the latest AI technology.
          </p>

          {/* Email Signup */}
          <div className="max-w-md mx-auto mb-12">
            <div className="flex gap-3">
              <input
                type="email"
                value={email}
                onChange={(e) => setEmail(e.target.value)}
                placeholder="Enter your email"
                className="flex-1 px-6 py-4 rounded-lg bg-gray-900 border border-gray-800 focus:border-veedco-cyan focus:outline-none"
              />
              <Link 
                href={`/auth/signup?email=${email}`}
                className="px-8 py-4 bg-gradient-to-r from-veedco-cyan to-veedco-cyan-light rounded-lg font-semibold hover:shadow-lg hover:shadow-veedco-cyan/30 transition whitespace-nowrap"
              >
                Start Free
              </Link>
            </div>
            <p className="text-sm text-gray-500 mt-3">
              Start with 100 free credits. No credit card required.
            </p>
          </div>

          {/* Features Grid */}
          <div className="grid md:grid-cols-3 gap-8 mt-20">
            <div className="bg-gray-900 border border-gray-800 rounded-2xl p-8 hover:border-veedco-cyan transition">
              <div className="w-16 h-16 bg-gradient-to-br from-veedco-cyan to-veedco-cyan-light rounded-xl flex items-center justify-center text-3xl mb-4 mx-auto">
                ✨
              </div>
              <h3 className="text-xl font-semibold mb-2">Text to Video</h3>
              <p className="text-gray-400">
                Describe your vision and watch it come to life
              </p>
            </div>

            <div className="bg-gray-900 border border-gray-800 rounded-2xl p-8 hover:border-veedco-cyan transition">
              <div className="w-16 h-16 bg-gradient-to-br from-veedco-cyan to-veedco-cyan-light rounded-xl flex items-center justify-center text-3xl mb-4 mx-auto">
                🎬
              </div>
              <h3 className="text-xl font-semibold mb-2">Image to Video</h3>
              <p className="text-gray-400">
                Bring your images to life with motion
              </p>
            </div>

            <div className="bg-gray-900 border border-gray-800 rounded-2xl p-8 hover:border-veedco-cyan transition">
              <div className="w-16 h-16 bg-gradient-to-br from-veedco-cyan to-veedco-cyan-light rounded-xl flex items-center justify-center text-3xl mb-4 mx-auto">
                ⚡
              </div>
              <h3 className="text-xl font-semibold mb-2">Lightning Fast</h3>
              <p className="text-gray-400">
                Generate professional videos in seconds
              </p>
            </div>
          </div>
        </div>
      </main>

      {/* Footer */}
      <footer className="border-t border-gray-800 py-8 mt-20">
        <div className="max-w-7xl mx-auto px-6 text-center text-gray-500">
          <p>&copy; 2026 Veedco. All rights reserved.</p>
        </div>
      </footer>
    </div>
  )
}
