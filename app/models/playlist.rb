class Playlist < ApplicationRecord
  belongs_to :user
  has_many :musics, dependent: :destroy

  serialize :owner, Hash

  # def init_remove_musics(user_id)
  #   RemoveMusicJob.set(wait: 200.seconds).perform_later(user_id)
  # end
end
