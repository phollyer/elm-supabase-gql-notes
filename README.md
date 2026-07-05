# elm-supabase

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
4. Apply migrations and seed:
   - `supabase db reset`
5. Start frontend dev server:
   - `cd frontend`
   - `npm run dev`

## Security model

- Frontend uses only public anon key.
- Never expose service role key in frontend code.
- RLS is enabled on app tables and policies are migration-managed.

## Current schema

- `profiles` (owner-only read/write)
- `notes` (owner-only CRUD)
