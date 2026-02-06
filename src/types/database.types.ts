export type Json =
  | string
  | number
  | boolean
  | null
  | { [key: string]: Json | undefined }
  | Json[]

export interface Database {
  public: {
    Tables: {
      profiles: {
        Row: {
          id: string
          email: string
          username: string | null
          full_name: string | null
          avatar_url: string | null
          credits: number
          subscription_tier: string
          subscription_status: string
          subscription_end_date: string | null
          total_videos_generated: number
          total_images_generated: number
          created_at: string
          updated_at: string
        }
        Insert: {
          id: string
          email: string
          username?: string | null
          full_name?: string | null
          avatar_url?: string | null
          credits?: number
          subscription_tier?: string
          subscription_status?: string
          subscription_end_date?: string | null
          total_videos_generated?: number
          total_images_generated?: number
        }
        Update: {
          username?: string | null
          full_name?: string | null
          avatar_url?: string | null
          credits?: number
          subscription_tier?: string
          subscription_status?: string
          subscription_end_date?: string | null
        }
      }
      videos: {
        Row: {
          id: string
          user_id: string
          title: string | null
          prompt: string
          model_used: string
          video_url: string | null
          thumbnail_url: string | null
          duration: number | null
          resolution: string | null
          fps: number | null
          aspect_ratio: string | null
          status: string
          visibility: string
          views: number
          likes: number
          credits_used: number
          generation_time: number | null
          metadata: Json | null
          created_at: string
          completed_at: string | null
        }
        Insert: {
          user_id: string
          prompt: string
          model_used: string
          title?: string | null
          resolution?: string | null
          fps?: number | null
          aspect_ratio?: string | null
          visibility?: string
          credits_used?: number
          metadata?: Json | null
        }
        Update: {
          title?: string | null
          video_url?: string | null
          thumbnail_url?: string | null
          duration?: number | null
          status?: string
          visibility?: string
          completed_at?: string | null
        }
      }
      transactions: {
        Row: {
          id: string
          user_id: string
          type: string
          amount: number
          balance_after: number
          description: string | null
          metadata: Json | null
          created_at: string
        }
      }
      subscription_plans: {
        Row: {
          id: string
          tier: string
          name: string
          price_monthly: number
          price_yearly: number | null
          credits_per_month: number
          max_video_generations: number | null
          max_image_generations: number | null
          video_models: string[] | null
          features: Json | null
          created_at: string
        }
      }
      likes: {
        Row: {
          id: string
          user_id: string
          video_id: string
          created_at: string
        }
        Insert: {
          user_id: string
          video_id: string
        }
        Delete: {
          user_id: string
          video_id: string
        }
      }
    }
    Functions: {
      deduct_credits: {
        Args: {
          p_user_id: string
          p_credits: number
          p_description: string
          p_metadata?: Json
        }
        Returns: boolean
      }
      add_credits: {
        Args: {
          p_user_id: string
          p_credits: number
          p_description: string
          p_metadata?: Json
        }
        Returns: number
      }
    }
  }
}
