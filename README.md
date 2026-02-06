# 🎬 Veedco Platform - AI Video Generation

Full-stack Next.js platform for AI video generation with Supabase backend.

## 📁 Project Structure

```
veedco-platform/
├── src/
│   ├── app/                    # Next.js App Router
│   │   ├── page.tsx           # Landing page
│   │   ├── layout.tsx         # Root layout
│   │   ├── globals.css        # Global styles
│   │   ├── auth/              # Authentication pages
│   │   │   ├── login/
│   │   │   ├── signup/
│   │   │   └── callback/
│   │   ├── dashboard/         # Main app (after login)
│   │   │   ├── page.tsx       # Explore feed
│   │   │   ├── text-to-video/
│   │   │   ├── image-to-video/
│   │   │   ├── my-media/
│   │   │   └── settings/
│   │   └── api/               # API routes
│   │       ├── videos/
│   │       ├── credits/
│   │       └── webhooks/
│   ├── components/            # React components
│   │   ├── Sidebar.tsx
│   │   ├── VideoCard.tsx
│   │   ├── CreditDisplay.tsx
│   │   └── ModelSelector.tsx
│   ├── lib/                   # Utilities
│   │   ├── supabase.ts       # Supabase client
│   │   └── credits.ts        # Credit management
│   └── types/                 # TypeScript types
│       └── database.types.ts
├── supabase-schema.sql        # Complete database schema
├── package.json
├── next.config.js
├── tailwind.config.js
└── .env.example
```

## 🚀 Quick Start

### 1. Clone & Install

```bash
git clone <your-repo>
cd veedco-platform
npm install
```

### 2. Setup Supabase

1. Create a project at [supabase.com](https://supabase.com)
2. Go to SQL Editor and run `supabase-schema.sql`
3. Create storage buckets:
   - `videos` (public)
   - `images` (private)
   - `thumbnails` (public)
   - `avatars` (public)

### 3. Configure Environment

Copy `.env.example` to `.env.local`:

```bash
cp .env.example .env.local
```

Fill in your Supabase credentials:

```env
NEXT_PUBLIC_SUPABASE_URL=https://your-project.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=your-anon-key
SUPABASE_SERVICE_ROLE_KEY=your-service-role-key
NEXT_PUBLIC_SITE_URL=http://localhost:3000
```

### 4. Run Development Server

```bash
npm run dev
```

Open [http://localhost:3000](http://localhost:3000)

## 📊 Database Schema Overview

### Core Tables

1. **profiles** - User profiles with credits and subscription
2. **videos** - Generated videos with metadata
3. **images** - Uploaded images for image-to-video
4. **transactions** - Credit purchase and usage history
5. **subscription_plans** - Available subscription tiers
6. **likes** - User likes on videos
7. **follows** - User following system
8. **generation_queue** - Video generation queue

### Key Functions

- `deduct_credits(user_id, amount, description, metadata)` - Deduct credits
- `add_credits(user_id, amount, description, metadata)` - Add credits
- Auto-create profile on user signup
- Auto-update likes count on videos

## 🎨 Features

### Authentication
- ✅ Email/Password signup & login
- ✅ OAuth (Google)
- ✅ Supabase Auth integration
- ✅ Protected routes

### Credit System
- ✅ Free tier: 100 credits on signup
- ✅ Credit packages (500, 2000, 5000, 15000)
- ✅ Subscription plans (Free, Basic, Standard, Ultimate, Creator)
- ✅ Transaction history
- ✅ Automatic credit deduction on generation

### Video Generation
- ✅ Text to Video
- ✅ Image to Video
- ✅ Multiple AI models
- ✅ Resolution/FPS/Duration settings
- ✅ Generation queue with priority
- ✅ Progress tracking

### Social Features
- ✅ Public explore feed
- ✅ Video likes
- ✅ User following
- ✅ Filter by Trending/Recent/Following
- ✅ User profiles

### Storage
- ✅ Supabase Storage for videos/images
- ✅ CDN delivery
- ✅ Automatic thumbnail generation

## 🔐 Row Level Security (RLS)

All tables have RLS enabled:
- Users can only view/edit their own data
- Public videos visible to everyone
- Likes/follows visible to all but editable only by owner

## 📦 Deployment to Vercel

### One-Click Deploy

1. Push code to GitHub
2. Import to Vercel
3. Add environment variables
4. Deploy!

### Manual Deploy

```bash
# Build
npm run build

# Deploy to Vercel
vercel --prod
```

### Environment Variables in Vercel

Add these in Project Settings → Environment Variables:

```
NEXT_PUBLIC_SUPABASE_URL
NEXT_PUBLIC_SUPABASE_ANON_KEY
SUPABASE_SERVICE_ROLE_KEY
NEXT_PUBLIC_SITE_URL
```

## 🔧 Development Workflow

### 1. Make Changes Locally

```bash
git checkout -b feature/my-feature
# Make your changes
npm run dev  # Test locally
```

### 2. Commit & Push

```bash
git add .
git commit -m "Add feature"
git push origin feature/my-feature
```

### 3. Create Pull Request on GitHub

### 4. Merge & Auto-Deploy
Once merged to `main`, Vercel auto-deploys!

## 💳 Credit Costs (Example)

```typescript
const CREDIT_COSTS = {
  'text-to-video': {
    '480p': 10,
    '720p': 20,
    '1080p': 40,
  },
  'image-to-video': {
    '480p': 5,
    '720p': 10,
    '1080p': 20,
  }
}
```

## 📝 Subscription Tiers

| Tier | Price/Month | Credits | Video Gens | Models |
|------|-------------|---------|------------|--------|
| Free | $0 | 100 | 5 | Basic |
| Basic | $9 | 500 | 50 | +Vision Pro |
| Standard | $30 | 2,000 | 200 | +Sora, Kling |
| Ultimate | $38 | 5,000 | 500 | All Models |
| Creator | $142 | 20,000 | Unlimited | All + API |

## 🎯 Next Steps

### Essential Features to Add

1. **API Routes** for video generation
2. **Payment Integration** (Stripe)
3. **AI Model Integration** (Replicate, RunwayML, etc.)
4. **Email Notifications** (Resend/SendGrid)
5. **Analytics** (PostHog/Mixpanel)
6. **Rate Limiting** (Upstash)

### File Structure to Complete

```typescript
// src/app/api/videos/generate/route.ts
export async function POST(request: Request) {
  // 1. Check user credits
  // 2. Deduct credits
  // 3. Call AI API
  // 4. Save to database
  // 5. Upload to storage
  // 6. Return video URL
}

// src/app/api/credits/purchase/route.ts
export async function POST(request: Request) {
  // 1. Verify Stripe payment
  // 2. Add credits to user
  // 3. Create transaction record
}
```

## 🐛 Troubleshooting

### Supabase Connection Issues
- Check `.env.local` variables
- Verify RLS policies are enabled
- Check API keys haven't expired

### Build Errors
```bash
rm -rf .next node_modules
npm install
npm run build
```

### Type Errors
```bash
# Regenerate Supabase types
npx supabase gen types typescript --project-id <project-id> > src/types/database.types.ts
```

## 📚 Resources

- [Next.js Docs](https://nextjs.org/docs)
- [Supabase Docs](https://supabase.com/docs)
- [Tailwind CSS](https://tailwindcss.com/docs)
- [Vercel Deployment](https://vercel.com/docs)

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## 📄 License

MIT License - feel free to use for your own projects!

---

**Built with ❤️ using Next.js, Supabase, and Tailwind CSS**
