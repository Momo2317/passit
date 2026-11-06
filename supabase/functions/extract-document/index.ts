// Stub: invoice / document extraction (OCR / AI) — server-side only.
import { serve } from "https://deno.land/std@0.224.0/http/server.ts";

serve(async (req) => {
  if (req.method !== "POST") {
    return new Response(JSON.stringify({ error: "Method not allowed" }), {
      status: 405,
      headers: { "Content-Type": "application/json" },
    });
  }
  return new Response(
    JSON.stringify({ ok: true, message: "extract-document stub" }),
    { headers: { "Content-Type": "application/json" } },
  );
});
