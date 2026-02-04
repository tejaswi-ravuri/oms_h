import dotenv from "dotenv";
import { createServerClient } from "./src/lib/supabase/client";

dotenv.config({ path: ".env.local" });

async function testSupabase() {
  if (
    !process.env.NEXT_PUBLIC_SUPABASE_URL ||
    !process.env.SUPABASE_SERVICE_ROLE_KEY
  ) {
    console.error("Missing Supabase environment variables");
    process.exit(1);
  }

  const supabase = createServerClient();
  const { data, error } = await supabase.from("pg_tables").select("*");

  if (error) {
    console.error("Supabase error:", error);
    process.exit(1);
  }

  console.log("Supabase connection successful! Tables:", data.length);
  process.exit(0);
}

testSupabase();
