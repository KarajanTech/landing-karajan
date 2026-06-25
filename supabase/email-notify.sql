-- Karajan landing — email notification on each new briefing request.
--
-- Sends you a formatted email (via Resend) every time a row is inserted into
-- briefing_requests. The lead is ALWAYS saved to the table first; the email is a
-- fire-and-forget notification, so even if sending fails you still have the row
-- in Table editor. Visitor input is HTML-escaped, so it can't inject markup.
--
-- ── BEFORE RUNNING ───────────────────────────────────────────────────────────
--   1. Create a Resend account:            https://resend.com
--   2. Create an API key (starts "re_"):   Resend → API Keys → Create
--   3. Sending domain — pick ONE:
--        a) Quick test: leave mail_from as onboarding@resend.dev. Resend only
--           delivers to the email you registered in Resend, so set mail_to to
--           that address.
--        b) Production: verify the karajan.io domain in Resend (add its DNS
--           records), then set mail_from to 'Karajan <notifications@karajan.io>'
--           and mail_to to any inbox you like (e.g. contact@karajan.io).
--   4. Replace the three  >>>  placeholders below, then paste this whole file in
--      the Supabase dashboard → SQL Editor → New query → Run. Re-running it just
--      updates the template (it is safe to run again).
-- ─────────────────────────────────────────────────────────────────────────────

create extension if not exists pg_net;

create or replace function public.notify_briefing_request()
returns trigger
language plpgsql
security definer
set search_path = public, net
as $$
declare
  resend_key text := '>>> re_YOUR_RESEND_API_KEY';        -- your Resend API key
  mail_from  text := 'Karajan <onboarding@resend.dev>';   -- see step 3
  mail_to    text := '>>> you@example.com';               -- where you receive requests (see step 3)

  -- HTML-escape visitor input (& < > ), with a fallback dash for an empty note.
  v_email text := replace(replace(replace(new.email, '&', '&amp;'), '<', '&lt;'), '>', '&gt;');
  v_note  text := replace(
                    replace(
                      replace(coalesce(nullif(trim(new.note), ''), '—'), '&', '&amp;'),
                    '<', '&lt;'),
                  '>', '&gt;');
  v_when  text := to_char(new.created_at at time zone 'Europe/Madrid', 'DD Mon YYYY, HH24:MI')
                  || ' · Madrid';
  v_html  text;
begin
  v_html :=
       '<!doctype html><html><body style="margin:0;padding:0;background:#f4f4f5;">'
    || '<table role="presentation" width="100%" cellpadding="0" cellspacing="0" style="background:#f4f4f5;padding:24px 12px;"><tr><td align="center">'
    || '<table role="presentation" width="100%" cellpadding="0" cellspacing="0" style="max-width:520px;background:#ffffff;border:1px solid #e4e4e7;border-radius:10px;overflow:hidden;font-family:-apple-system,BlinkMacSystemFont,Roboto,Helvetica,Arial,sans-serif;">'
    -- header
    || '<tr><td style="background:#08090b;padding:20px 28px;border-bottom:2px solid #54e6c1;">'
    || '<div style="font-size:13px;letter-spacing:3px;color:#ffffff;font-weight:600;">KARAJAN</div>'
    || '<div style="font-size:13px;color:#99a1ad;margin-top:6px;">New briefing request</div>'
    || '</td></tr>'
    -- body
    || '<tr><td style="padding:28px;">'
    || '<div style="font-size:11px;letter-spacing:1.5px;text-transform:uppercase;color:#71717a;margin-bottom:5px;">From</div>'
    || '<div style="font-size:16px;margin-bottom:20px;"><a href="mailto:' || v_email || '" style="color:#0f766e;text-decoration:none;font-weight:600;">' || v_email || '</a></div>'
    || '<div style="font-size:11px;letter-spacing:1.5px;text-transform:uppercase;color:#71717a;margin-bottom:5px;">Message</div>'
    || '<div style="font-size:15px;color:#27272a;line-height:1.55;margin-bottom:20px;white-space:pre-wrap;">' || v_note || '</div>'
    || '<div style="font-size:11px;letter-spacing:1.5px;text-transform:uppercase;color:#71717a;margin-bottom:5px;">Received</div>'
    || '<div style="font-size:15px;color:#27272a;">' || v_when || '</div>'
    || '</td></tr>'
    -- footer
    || '<tr><td style="padding:16px 28px;background:#fafafa;border-top:1px solid #efefef;font-size:12px;color:#a1a1aa;">Reply to this email to respond to ' || v_email || ' directly.</td></tr>'
    || '</table>'
    || '<div style="font-size:11px;color:#a1a1aa;margin-top:14px;font-family:-apple-system,BlinkMacSystemFont,Roboto,Helvetica,Arial,sans-serif;">Sent automatically by the Karajan briefing form.</div>'
    || '</td></tr></table></body></html>';

  perform net.http_post(
    url := 'https://api.resend.com/emails',
    headers := jsonb_build_object(
      'Authorization', 'Bearer ' || resend_key,
      'Content-Type', 'application/json'
    ),
    body := jsonb_build_object(
      'from', mail_from,
      'to', jsonb_build_array(mail_to),
      'reply_to', new.email,
      'subject', 'New briefing request — ' || new.email,
      'html', v_html,
      'text',
           'New briefing request' || E'\n\n'
        || 'From:     ' || new.email || E'\n'
        || 'Message:  ' || coalesce(nullif(trim(new.note), ''), '—') || E'\n'
        || 'Received: ' || v_when
    )
  );
  return new;
end;
$$;

drop trigger if exists on_briefing_request_insert on public.briefing_requests;
create trigger on_briefing_request_insert
  after insert on public.briefing_requests
  for each row
  execute function public.notify_briefing_request();

-- Debugging: select status_code, content from net._http_response order by id desc limit 5;
