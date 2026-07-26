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
import { uploadAvatar } from './supabase/data.js'

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
    switch (message.type) {
        case 'initialize-session':
            emit(await initializeSession())
            return

        case 'refresh-session':
            emit(await refreshSession())
            return

        case 'sign-up-password':
            emit(await signUpWithPassword(message.email, message.password))
            return

        case 'sign-in-password':
            emit(await signInWithPassword(message.email, message.password))
            return

        case 'sign-in-magic-link':
            emit(await signInWithMagicLink(message.email))
            return

        case 'sign-out':
            emit(await signOut())
            return

        case 'upload-avatar':
            emit(await uploadAvatar())
            return

        default:
            emit({
                type: 'error',
                message: `Unknown command type: ${message.type}`
            })
    }
}

app.ports.supabaseOut.subscribe((value) => {
    run(value).catch((error) => {
        emit({
            type: 'error',
            message: error?.message || 'Unexpected bridge error'
        })
    })
})
