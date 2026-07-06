import { supabase } from './client.js'

const toError = (requestId, error) => ({
    type: 'error',
    requestId,
    message: error?.message || 'Unknown data error'
})

export const fetchNotes = async (requestId) => {
    const { data, error } = await supabase
        .from('notes')
        .select('id,title,body,created_at')
        .order('created_at', { ascending: false })

    if (error) {
        return toError(requestId, error)
    }

    return {
        type: 'notes-loaded',
        requestId,
        notes: data || []
    }
}

export const createNote = async (requestId, title, body) => {
    const {
        data: { user },
        error: userError
    } = await supabase.auth.getUser()

    if (userError) {
        return toError(requestId, userError)
    }

    if (!user) {
        return {
            type: 'error',
            requestId,
            message: 'You must be signed in to create a note.'
        }
    }

    const { data, error } = await supabase
        .from('notes')
        .insert({ user_id: user.id, title, body })
        .select('id,title,body,created_at')
        .single()

    if (error) {
        return toError(requestId, error)
    }

    return {
        type: 'note-created',
        requestId,
        note: data
    }
}

export const searchNotes = async (requestId, query) => {
    const { data, error } = await supabase
        .from('notes')
        .select('id,title,body,created_at')
        .or(`title.ilike.%${query}%,body.ilike.%${query}%`)
        .order('created_at', { ascending: false })

    if (error) {
        return toError(requestId, error)
    }

    return {
        type: 'notes-found',
        requestId,
        notes: data || []
    }
}
