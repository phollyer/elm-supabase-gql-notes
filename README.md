# elm-supabase-notes

Learning project for Elm + Supabase integration with production-minded defaults.

## Prerequisites

- Node.js and npm
- Elm 0.19.1
- Supabase CLI

## Quick start

1. Install frontend dependencies:
   - `cd frontend`
   - `npm install`
2. Copy frontend env template:
   - `cp .env.example .env`
3. Start Supabase locally from repo root:
   - `supabase start`
4. Set frontend env values (from `supabase status`):
   - `VITE_SUPABASE_URL=http://127.0.0.1:54321`
   - `VITE_SUPABASE_PUBLISHABLE_KEY=<publishable key>`
5. Apply migrations and seed:
   - `supabase db reset`
6. Start frontend dev server:
   - `cd frontend`
   - `npm run dev`
7. Open:
   - App: `http://localhost:5173`
   - Studio: `http://127.0.0.1:54323`
   - Mailpit (magic links): `http://127.0.0.1:54324`

## Supported auth flows

- Email + password sign up
- Email + password sign in
- Magic link sign in
- Sign out

## Useful commands

- `cd frontend && npm run check` (Elm compile check)
- `supabase status` (print local URLs and keys)

## Security model

- Frontend uses only the public publishable key.
- Never expose service role key in frontend code.
- RLS is enabled on app tables and policies are migration-managed.

## Current schema

- `profiles` (owner-only read/write)
- `notes` (owner-only CRUD)
