class GetPlaylistService
    def initialize(params = {})
        @user = RSpotify::User.new(params[:hash])
        @id_playlist = params[:id_playlist]
    end

    def call
        playlists_spotify = @user.playlists

        playlist_spotify = playlists_spotify.map do |playlist|
            playlist if playlist.id == Playlist.find(@id_playlist).id_spotify
        end

        playlist_spotify = playlist_spotify.reject(&:blank?)
        playlist_spotify = playlist_spotify[0]
    end

    private

end
