class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  serialize :user_hash, Hash
  has_many :playlists

  def already_exists?
    if self.user_hash == {}
      false
    else
      true
    end
  end
end
