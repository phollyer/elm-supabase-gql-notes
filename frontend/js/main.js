/* global document */

import { Elm } from '../src/Main.elm'
import {
    initializeSession,
    refreshSession,
    signInWithPassword,
    signUpWithPassword,
    signInWithMagicLink,
    signOut
} from './supabase/auth.js'
import { createNote, fetchNotes, searchNotes, uploadAvatar } from './supabase/data.js'

const publishableKey = import.meta.env.VITE_SUPABASE_PUBLISHABLE_KEY || import.meta.env.VITE_SUPABASE_ANON_KEY
const graphqlUrl = `${import.meta.env.VITE_SUPABASE_URL}/graphql/v1`

const app = Elm.Main.init({
    node: document.getElementById('app'),
    flags: {
        publishableKey,
        graphqlUrl
    }
})

const emit = (event) => {
    app.ports.supabaseIn.send(event)
}

const run = async (message) => {
    const requestId = message.requestId || `req-${Date.now()}`

    switch (message.type) {
        case 'initialize-session':
            emit(await initializeSession(requestId))
            return

        case 'refresh-session':
            emit(await refreshSession(requestId))
            return

        case 'sign-up-password':
            emit(await signUpWithPassword(requestId, message.email, message.password))
            return

        case 'sign-in-password':
            emit(await signInWithPassword(requestId, message.email, message.password))
            return

        case 'sign-in-magic-link':
            emit(await signInWithMagicLink(requestId, message.email))
            return

        case 'sign-out':
            emit(await signOut(requestId))
            return

        case 'fetch-notes':
            emit(await fetchNotes(requestId))
            return

        case 'create-note':
            emit(await createNote(requestId, message.title, message.body))
            return

        case 'search-notes':
            emit(await searchNotes(requestId, message.query))
            return

        case 'upload-avatar':
            emit(await uploadAvatar(requestId))
            return

        default:
            emit({
                type: 'error',
                requestId,
                message: `Unknown command type: ${message.type}`
            })
    }
}

app.ports.supabaseOut.subscribe((value) => {
    run(value).catch((error) => {
        emit({
            type: 'error',
            requestId: value.requestId || `req-${Date.now()}`,
            message: error?.message || 'Unexpected bridge error'
        })
    })
})
