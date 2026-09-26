import { NextResponse } from "next/server";

export async function GET() {
  const hasUrl = Boolean(process.env.NEXT_PUBLIC_SUPABASE_URL);
  const hasAnonKey = Boolean(process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY);

  if (hasUrl && hasAnonKey) {
    return NextResponse.json({ ok: true, configured: true }, { status: 200 });
  }

  return NextResponse.json(
    { ok: false, configured: false },
    { status: 503 }
  );
}
