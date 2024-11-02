class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         authentication_keys: [:name]
  
  has_many :books, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy

  # フォローフォロワー機能
  has_many :follower_relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :followed_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  has_many :followings, through: :follower_relationships, source: :followed
  has_many :followers, through: :followed_relationships, source: :follower
  
  def follow(user)
    follower_relationships.find_or_create_by(followed_id: user.id)
  end
  
  def unfollow(user)
    follower_relationships.find_by(followed_id: user.id)&.destroy
  end
  
  def following?(user)
    followings.include?(user)
  end  

  has_one_attached :profile_image
  
  with_options on: :create do  
    validates :email, uniqueness: true
    validates :password, length: { minimum: 6 }
    validates :name, length: { minimum: 2, maximum: 20 }, uniqueness: true
  end

  validates :name, length: { minimum: 2, maximum: 20 }, uniqueness: true
  validates :introduction, length: { maximum: 50 }

  def get_profile_image(width = 100, height = 100)
    # デフォルト画像が未添付の場合、ファイルパスを指定して添付
    unless profile_image.attached?
      file_path = Rails.root.join('app', 'assets', 'images', 'no_image.jpg')
      profile_image.attach(io: File.open(file_path), filename: 'no_image.jpg', content_type: 'image/jpg')
    end
    
    # サイズ指定があれば変換
    profile_image.variant(resize_to_limit: [width, height]).processed
  end
end