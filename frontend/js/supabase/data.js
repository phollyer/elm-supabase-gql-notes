import { supabase } from './client.js'

const MAX_AVATAR_BYTES = 1048576

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

export const uploadAvatar = async (requestId) => {
    const { data: { user }, error: userError } = await supabase.auth.getUser()

    if (userError) {
        return toError(requestId, userError)
    }

    if (!user) {
        return {
            type: 'error',
            requestId,
            message: 'You must be signed in to upload an avatar.'
        }
    }

    // Create a file input element to select the avatar image
    const fileInput = globalThis['document'].createElement('input')
    fileInput.type = 'file'
    fileInput.accept = 'image/*'

    return new Promise((resolve) => {
        fileInput.onchange = async () => {
            const file = fileInput.files[0]
            if (!file) {
                resolve({
                    type: 'error',
                    requestId,
                    message: 'No file selected.'
                })
                return
            }

            if (!file.type.startsWith('image/')) {
                resolve({
                    type: 'error',
                    requestId,
                    message: 'Avatar must be an image file.'
                })
                return
            }

            if (file.size > MAX_AVATAR_BYTES) {
                resolve({
                    type: 'error',
                    requestId,
                    message: 'Avatar must be 1 MB or smaller.'
                })
                return
            }

            const fileName = `${user.id}/${file.name}`
            const { error } = await supabase.storage
                .from('avatar')
                .upload(fileName, file, {
                    contentType: file.type,
                    upsert: true
                })

            if (error) {
                resolve(toError(requestId, error))
                return
            }

            const { data: publicUrlData, error: publicUrlError } = supabase.storage
                .from('avatar')
                .getPublicUrl(fileName)

            if (publicUrlError) {
                resolve(toError(requestId, publicUrlError))
                return
            }

            resolve({
                type: 'avatar-uploaded',
                requestId,
                avatarUrl: publicUrlData.publicUrl,
                avatarPath: fileName
            })
        }

        // Trigger the file input dialog
        fileInput.click()
    })
}
