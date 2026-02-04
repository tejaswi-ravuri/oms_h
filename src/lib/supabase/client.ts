import { createBrowserClient } from "@supabase/ssr";
import { createClient } from "@supabase/supabase-js";

// For client-side operations (Client Components)
export const createClientSupabaseClient = () => {
  return createBrowserClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!,
  );
};

// For server-side admin operations (use sparingly, only when you need service role)
export const createServerClient = () =>
  createClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.SUPABASE_SERVICE_ROLE_KEY!,
  );

// Default client for client-side
export const supabase = createClientSupabaseClient();
