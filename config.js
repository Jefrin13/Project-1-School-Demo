// ============================================================
// Supabase connection settings
// ------------------------------------------------------------
// Get these two values from your Supabase project:
//   Project Settings → API → Project URL, and Project API keys → "anon public"
// The anon key is safe to use here — it's a public, restricted key.
// (Never put a "service_role" key in a file like this.)
// ============================================================
const SUPABASE_URL = "https://YOUR-PROJECT-REF.supabase.co";
const SUPABASE_ANON_KEY = "YOUR-ANON-PUBLIC-KEY";

const supabaseClient = window.supabase.createClient(SUPABASE_URL, SUPABASE_ANON_KEY);
