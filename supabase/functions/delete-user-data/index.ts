// Stub: delete user-owned DB rows and storage objects (verified workflow).
import { serve } from "https://deno.land/std@0.224.0/http/server.ts";

serve(async (req) => {
  if (req.method !== "POST") {
    return new Response(JSON.stringify({ error: "Method not allowed" }), {
      status: 405,
      headers: { "Content-Type": "application/json" },
    });
  }
  return new Response(
    JSON.stringify({ ok: true, message: "delete-user-data stub" }),
    { headers: { "Content-Type": "application/json" } },
  );
});
