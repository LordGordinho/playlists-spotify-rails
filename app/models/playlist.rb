class Playlist < ApplicationRecord
  belongs_to :user
  has_many :musics

  serialize :owner, Hash
end
