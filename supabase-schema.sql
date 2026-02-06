-- ============================================
-- VEEDCO PLATFORM - SUPABASE SCHEMA
-- ============================================

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ============================================
-- 1. USERS TABLE (extends Supabase auth.users)
-- ============================================
CREATE TABLE public.profiles (
    id UUID REFERENCES auth.users(id) PRIMARY KEY,
    email TEXT UNIQUE NOT NULL,
    username TEXT UNIQUE,
    full_name TEXT,
    avatar_url TEXT,
    credits INTEGER DEFAULT 100, -- Free starting credits
    subscription_tier TEXT DEFAULT 'free', -- free, basic, standard, ultimate, creator
    subscription_status TEXT DEFAULT 'active', -- active, cancelled, expired
    subscription_end_date TIMESTAMP WITH TIME ZONE,
    total_videos_generated INTEGER DEFAULT 0,
    total_images_generated INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Enable Row Level Security
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

-- Policies for profiles
CREATE POLICY "Users can view their own profile" 
    ON public.profiles FOR SELECT 
    USING (auth.uid() = id);

CREATE POLICY "Users can update their own profile" 
    ON public.profiles FOR UPDATE 
    USING (auth.uid() = id);

-- ============================================
-- 2. CREDIT PACKAGES TABLE
-- ============================================
CREATE TABLE public.credit_packages (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    name TEXT NOT NULL,
    credits INTEGER NOT NULL,
    price_usd DECIMAL(10, 2) NOT NULL,
    popular BOOLEAN DEFAULT false,
    description TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Insert default credit packages
INSERT INTO public.credit_packages (name, credits, price_usd, popular, description) VALUES
    ('Starter', 500, 9.99, false, 'Perfect for trying out'),
    ('Pro', 2000, 29.99, true, 'Most popular choice'),
    ('Business', 5000, 69.99, false, 'For heavy users'),
    ('Enterprise', 15000, 149.99, false, 'Maximum value');

-- ============================================
-- 3. SUBSCRIPTION PLANS TABLE
-- ============================================
CREATE TABLE public.subscription_plans (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    tier TEXT UNIQUE NOT NULL, -- free, basic, standard, ultimate, creator
    name TEXT NOT NULL,
    price_monthly DECIMAL(10, 2) NOT NULL,
    price_yearly DECIMAL(10, 2),
    credits_per_month INTEGER NOT NULL,
    max_video_generations INTEGER,
    max_image_generations INTEGER,
    video_models TEXT[], -- Array of allowed model names
    features JSONB, -- Additional features as JSON
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Insert subscription plans
INSERT INTO public.subscription_plans (tier, name, price_monthly, price_yearly, credits_per_month, max_video_generations, max_image_generations, video_models, features) VALUES
    ('free', 'Free', 0, 0, 100, 5, 20, ARRAY['veedco-gen'], '{"concurrent_generations": 1, "priority_queue": false}'::jsonb),
    ('basic', 'Basic', 9, 90, 500, 50, 100, ARRAY['veedco-gen', 'veedco-vision-pro'], '{"concurrent_generations": 2, "priority_queue": false}'::jsonb),
    ('standard', 'Standard', 30, 300, 2000, 200, 500, ARRAY['veedco-gen', 'veedco-vision-pro', 'sora-2', 'kling-2.6'], '{"concurrent_generations": 3, "priority_queue": true}'::jsonb),
    ('ultimate', 'Ultimate', 38, 380, 5000, 500, 1000, ARRAY['veedco-gen', 'veedco-vision-pro', 'sora-2', 'sora-2-pro', 'kling-2.6', 'pixverse-v5', 'veo-3.1'], '{"concurrent_generations": 4, "priority_queue": true, "unlimited_models": true}'::jsonb),
    ('creator', 'Creator', 142, 1420, 20000, -1, -1, ARRAY['all'], '{"concurrent_generations": 5, "priority_queue": true, "unlimited_models": true, "api_access": true}'::jsonb);

-- ============================================
-- 4. VIDEOS TABLE (Generated Videos)
-- ============================================
CREATE TABLE public.videos (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    user_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE,
    title TEXT,
    prompt TEXT NOT NULL,
    model_used TEXT NOT NULL,
    video_url TEXT,
    thumbnail_url TEXT,
    duration INTEGER, -- in seconds
    resolution TEXT, -- 480p, 720p, 1080p
    fps INTEGER,
    aspect_ratio TEXT, -- 16:9, 9:16, 1:1, 4:3
    status TEXT DEFAULT 'generating', -- generating, completed, failed
    visibility TEXT DEFAULT 'private', -- private, public
    views INTEGER DEFAULT 0,
    likes INTEGER DEFAULT 0,
    credits_used INTEGER DEFAULT 0,
    generation_time INTEGER, -- in seconds
    metadata JSONB, -- Additional metadata
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    completed_at TIMESTAMP WITH TIME ZONE
);

-- Enable RLS
ALTER TABLE public.videos ENABLE ROW LEVEL SECURITY;

-- Policies for videos
CREATE POLICY "Users can view their own videos" 
    ON public.videos FOR SELECT 
    USING (auth.uid() = user_id OR visibility = 'public');

CREATE POLICY "Users can insert their own videos" 
    ON public.videos FOR INSERT 
    WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own videos" 
    ON public.videos FOR UPDATE 
    USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own videos" 
    ON public.videos FOR DELETE 
    USING (auth.uid() = user_id);

-- Indexes for performance
CREATE INDEX videos_user_id_idx ON public.videos(user_id);
CREATE INDEX videos_visibility_idx ON public.videos(visibility);
CREATE INDEX videos_created_at_idx ON public.videos(created_at DESC);

-- ============================================
-- 5. IMAGES TABLE (Image to Video source images)
-- ============================================
CREATE TABLE public.images (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    user_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE,
    image_url TEXT NOT NULL,
    thumbnail_url TEXT,
    original_filename TEXT,
    file_size INTEGER, -- in bytes
    width INTEGER,
    height INTEGER,
    format TEXT, -- jpg, png, webp
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Enable RLS
ALTER TABLE public.images ENABLE ROW LEVEL SECURITY;

-- Policies
CREATE POLICY "Users can view their own images" 
    ON public.images FOR SELECT 
    USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own images" 
    ON public.images FOR INSERT 
    WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can delete their own images" 
    ON public.images FOR DELETE 
    USING (auth.uid() = user_id);

-- ============================================
-- 6. LIKES TABLE (User likes on videos)
-- ============================================
CREATE TABLE public.likes (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    user_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE,
    video_id UUID REFERENCES public.videos(id) ON DELETE CASCADE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(user_id, video_id)
);

-- Enable RLS
ALTER TABLE public.likes ENABLE ROW LEVEL SECURITY;

-- Policies
CREATE POLICY "Users can view all likes" 
    ON public.likes FOR SELECT 
    USING (true);

CREATE POLICY "Users can insert their own likes" 
    ON public.likes FOR INSERT 
    WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can delete their own likes" 
    ON public.likes FOR DELETE 
    USING (auth.uid() = user_id);

-- ============================================
-- 7. FOLLOWS TABLE (User following system)
-- ============================================
CREATE TABLE public.follows (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    follower_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE,
    following_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(follower_id, following_id),
    CHECK (follower_id != following_id)
);

-- Enable RLS
ALTER TABLE public.follows ENABLE ROW LEVEL SECURITY;

-- Policies
CREATE POLICY "Users can view all follows" 
    ON public.follows FOR SELECT 
    USING (true);

CREATE POLICY "Users can insert their own follows" 
    ON public.follows FOR INSERT 
    WITH CHECK (auth.uid() = follower_id);

CREATE POLICY "Users can delete their own follows" 
    ON public.follows FOR DELETE 
    USING (auth.uid() = follower_id);

-- ============================================
-- 8. TRANSACTIONS TABLE (Credit purchases and usage)
-- ============================================
CREATE TABLE public.transactions (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    user_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE,
    type TEXT NOT NULL, -- purchase, usage, refund, subscription
    amount INTEGER NOT NULL, -- positive for credits added, negative for used
    balance_after INTEGER NOT NULL,
    description TEXT,
    metadata JSONB, -- Payment info, video_id, etc.
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Enable RLS
ALTER TABLE public.transactions ENABLE ROW LEVEL SECURITY;

-- Policies
CREATE POLICY "Users can view their own transactions" 
    ON public.transactions FOR SELECT 
    USING (auth.uid() = user_id);

CREATE INDEX transactions_user_id_idx ON public.transactions(user_id);
CREATE INDEX transactions_created_at_idx ON public.transactions(created_at DESC);

-- ============================================
-- 9. GENERATION QUEUE TABLE (Video generation queue)
-- ============================================
CREATE TABLE public.generation_queue (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    video_id UUID REFERENCES public.videos(id) ON DELETE CASCADE,
    user_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE,
    priority INTEGER DEFAULT 0, -- Higher number = higher priority
    status TEXT DEFAULT 'queued', -- queued, processing, completed, failed
    progress INTEGER DEFAULT 0, -- 0-100
    error_message TEXT,
    started_at TIMESTAMP WITH TIME ZONE,
    completed_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Enable RLS
ALTER TABLE public.generation_queue ENABLE ROW LEVEL SECURITY;

-- Policies
CREATE POLICY "Users can view their own queue items" 
    ON public.generation_queue FOR SELECT 
    USING (auth.uid() = user_id);

CREATE INDEX queue_status_priority_idx ON public.generation_queue(status, priority DESC);

-- ============================================
-- 10. FUNCTIONS AND TRIGGERS
-- ============================================

-- Function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Trigger for profiles updated_at
CREATE TRIGGER update_profiles_updated_at 
    BEFORE UPDATE ON public.profiles
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- Function to create profile on user signup
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO public.profiles (id, email, credits)
    VALUES (NEW.id, NEW.email, 100);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger to create profile automatically
CREATE TRIGGER on_auth_user_created
    AFTER INSERT ON auth.users
    FOR EACH ROW
    EXECUTE FUNCTION public.handle_new_user();

-- Function to update video likes count
CREATE OR REPLACE FUNCTION update_video_likes_count()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        UPDATE public.videos
        SET likes = likes + 1
        WHERE id = NEW.video_id;
    ELSIF TG_OP = 'DELETE' THEN
        UPDATE public.videos
        SET likes = GREATEST(likes - 1, 0)
        WHERE id = OLD.video_id;
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

-- Trigger for likes count
CREATE TRIGGER update_likes_count
    AFTER INSERT OR DELETE ON public.likes
    FOR EACH ROW
    EXECUTE FUNCTION update_video_likes_count();

-- Function to deduct credits
CREATE OR REPLACE FUNCTION deduct_credits(
    p_user_id UUID,
    p_credits INTEGER,
    p_description TEXT,
    p_metadata JSONB DEFAULT '{}'::jsonb
)
RETURNS BOOLEAN AS $$
DECLARE
    v_current_credits INTEGER;
    v_new_balance INTEGER;
BEGIN
    -- Get current credits
    SELECT credits INTO v_current_credits
    FROM public.profiles
    WHERE id = p_user_id
    FOR UPDATE;

    -- Check if user has enough credits
    IF v_current_credits < p_credits THEN
        RETURN FALSE;
    END IF;

    -- Calculate new balance
    v_new_balance := v_current_credits - p_credits;

    -- Update user credits
    UPDATE public.profiles
    SET credits = v_new_balance,
        updated_at = NOW()
    WHERE id = p_user_id;

    -- Record transaction
    INSERT INTO public.transactions (user_id, type, amount, balance_after, description, metadata)
    VALUES (p_user_id, 'usage', -p_credits, v_new_balance, p_description, p_metadata);

    RETURN TRUE;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function to add credits
CREATE OR REPLACE FUNCTION add_credits(
    p_user_id UUID,
    p_credits INTEGER,
    p_description TEXT,
    p_metadata JSONB DEFAULT '{}'::jsonb
)
RETURNS INTEGER AS $$
DECLARE
    v_new_balance INTEGER;
BEGIN
    -- Update user credits
    UPDATE public.profiles
    SET credits = credits + p_credits,
        updated_at = NOW()
    WHERE id = p_user_id
    RETURNING credits INTO v_new_balance;

    -- Record transaction
    INSERT INTO public.transactions (user_id, type, amount, balance_after, description, metadata)
    VALUES (p_user_id, 'purchase', p_credits, v_new_balance, p_description, p_metadata);

    RETURN v_new_balance;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ============================================
-- 11. STORAGE BUCKETS (Run in Supabase Dashboard)
-- ============================================
-- Create storage buckets for:
-- 1. videos (generated videos)
-- 2. images (uploaded images)
-- 3. thumbnails (video thumbnails)
-- 4. avatars (user profile pictures)

-- Note: These need to be created via Supabase Dashboard or API
-- Storage -> New Bucket -> Name: "videos", Public: true
-- Storage -> New Bucket -> Name: "images", Public: false (user uploads)
-- Storage -> New Bucket -> Name: "thumbnails", Public: true
-- Storage -> New Bucket -> Name: "avatars", Public: true

-- ============================================
-- END OF SCHEMA
-- ============================================
