import { supabase } from './client.js'

const toError = (requestId, error) => ({
    type: 'error',
    requestId,
    message: error?.message || 'Unknown auth error'
})

export const initializeSession = async (requestId) => {
    const { data, error } = await supabase.auth.getSession()
    if (error) {
        return toError(requestId, error)
    }

    const user = data?.session?.user
    if (!user) {
        return { type: 'session-missing', requestId }
    }

    return {
        type: 'session-ready',
        accessToken: data.session.access_token,
        requestId,
        userId: user.id,
        email: user.email || ''
    }
}

export const refreshSession = async (requestId) => {
    const { data, error } = await supabase.auth.refreshSession()
    if (error) {
        return toError(requestId, error)
    }

    const user = data?.session?.user
    if (!user) {
        return { type: 'session-missing', requestId }
    }

    return {
        type: 'session-ready',
        accessToken: data.session.access_token,
        requestId,
        userId: user.id,
        email: user.email || ''
    }
}

export const signInWithPassword = async (requestId, email, password) => {
    const { data, error } = await supabase.auth.signInWithPassword({ email, password })
    if (error) {
        return toError(requestId, error)
    }

    const user = data?.user
    if (!user) {
        return { type: 'session-missing', requestId }
    }

    return {
        type: 'session-ready',
        accessToken: data.session.access_token,
        requestId,
        userId: user.id,
        email: user.email || ''
    }
}

export const signUpWithPassword = async (requestId, email, password) => {
    const { data, error } = await supabase.auth.signUp({ email, password })
    if (error) {
        return toError(requestId, error)
    }

    const user = data?.user
    const session = data?.session

    if (!user) {
        return {
            type: 'error',
            requestId,
            message: 'Sign up did not return a user. Please try again.'
        }
    }

    if (!session) {
        return {
            type: 'error',
            requestId,
            message: 'Account created. Check your email to confirm, then sign in.'
        }
    }

    return {
        type: 'session-ready',
        accessToken: session.access_token,
        requestId,
        userId: user.id,
        email: user.email || ''
    }
}

export const signInWithMagicLink = async (requestId, email) => {
    const { error } = await supabase.auth.signInWithOtp({
        email,
        options: {
            emailRedirectTo: 'http://localhost:5173'
        }
    })

    if (error) {
        return toError(requestId, error)
    }

    return {
        type: 'error',
        requestId,
        message: 'Magic link sent. Open your email to continue.'
    }
}

export const signOut = async (requestId) => {
    const { error } = await supabase.auth.signOut()
    if (error) {
        return toError(requestId, error)
    }

    return {
        type: 'session-missing',
        requestId
    }
}
