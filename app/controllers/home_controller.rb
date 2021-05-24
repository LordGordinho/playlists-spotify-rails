class HomeController < ApplicationController
  before_action :authenticate_user!

  def index
    if request.env['omniauth.auth'] 
      @spotify_user = RSpotify::User.new(request.env['omniauth.auth'])
      current_user.user_hash = @spotify_user.to_hash
      current_user.save
    else
      redirect_to '/auth/spotify'
    end
  end

end
