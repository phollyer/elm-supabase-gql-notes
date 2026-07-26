import { supabase } from './client.js'

const MAX_AVATAR_BYTES = 1048576

const toError = (error) => ({
    type: 'error',
    message: error?.message || 'Unknown data error'
})



export const uploadAvatar = async () => {
    const { data: { user }, error: userError } = await supabase.auth.getUser()

    if (userError) {
        return toError(userError)
    }

    if (!user) {
        return {
            type: 'error',
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
                    message: 'No file selected.'
                })
                return
            }

            if (!file.type.startsWith('image/')) {
                resolve({
                    type: 'error',
                    message: 'Avatar must be an image file.'
                })
                return
            }

            if (file.size > MAX_AVATAR_BYTES) {
                resolve({
                    type: 'error',
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
                resolve(toError(error))
                return
            }

            const { data: publicUrlData, error: publicUrlError } = supabase.storage
                .from('avatar')
                .getPublicUrl(fileName)

            if (publicUrlError) {
                resolve(toError(publicUrlError))
                return
            }

            resolve({
                type: 'avatar-uploaded',
                avatarUrl: publicUrlData.publicUrl,
                avatarPath: fileName
            })
        }

        // Trigger the file input dialog
        fileInput.click()
    })
}
