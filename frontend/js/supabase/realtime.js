import { supabase } from './client.js'

export const subscribeNotes = (userId, onPayload) =>
    supabase
        .channel(`notes-${userId}`)
        .on(
            'postgres_changes',
            {
                event: '*',
                schema: 'public',
                table: 'notes',
                filter: `user_id=eq.${userId}`
            },
            onPayload
        )
        .subscribe()

export const unsubscribeChannel = (channel) => {
    if (channel) {
        supabase.removeChannel(channel)
    }
}
