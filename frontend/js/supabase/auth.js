import { supabase } from './client.js'

const toError = (error) => ({
    type: 'error',
    message: error?.message || 'Unknown auth error'
})

export const initializeSession = async () => {
    const { data, error } = await supabase.auth.getSession()
    if (error) {
        return toError(error)
    }

    const user = data?.session?.user
    if (!user) {
        return { type: 'session-missing' }
    }

    return {
        type: 'session-ready',
        accessToken: data.session.access_token,
        userId: user.id,
        email: user.email || ''
    }
}

export const refreshSession = async () => {
    const { data, error } = await supabase.auth.refreshSession()
    if (error) {
        return toError(error)
    }

    const user = data?.session?.user
    if (!user) {
        return { type: 'session-missing' }
    }

    return {
        type: 'session-ready',
        accessToken: data.session.access_token,
        userId: user.id,
        email: user.email || ''
    }
}

export const signInWithPassword = async (email, password) => {
    const { data, error } = await supabase.auth.signInWithPassword({ email, password })
    if (error) {
        return toError(error)
    }

    const user = data?.user
    if (!user) {
        return { type: 'session-missing' }
    }

    return {
        type: 'session-ready',
        accessToken: data.session.access_token,
        userId: user.id,
        email: user.email || ''
    }
}

export const signUpWithPassword = async (email, password) => {
    const { data, error } = await supabase.auth.signUp({ email, password })
    if (error) {
        return toError(error)
    }

    const user = data?.user
    const session = data?.session

    if (!user) {
        return {
            type: 'error',
            message: 'Sign up did not return a user. Please try again.'
        }
    }

    if (!session) {
        return {
            type: 'error',
            message: 'Account created. Check your email to confirm, then sign in.'
        }
    }

    return {
        type: 'session-ready',
        accessToken: session.access_token,
        userId: user.id,
        email: user.email || ''
    }
}

export const signInWithMagicLink = async (email) => {
    const { error } = await supabase.auth.signInWithOtp({
        email,
        options: {
            emailRedirectTo: 'http://localhost:5173'
        }
    })

    if (error) {
        return toError(error)
    }

    return {
        type: 'error',
        message: 'Magic link sent. Open your email to continue.'
    }
}

export const signOut = async () => {
    const { error } = await supabase.auth.signOut()
    if (error) {
        return toError(error)
    }

    return {
        type: 'session-missing'
    }
}
