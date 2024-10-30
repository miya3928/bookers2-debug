class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         authentication_keys: [:name] 
  
  has_many :books, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_one_attached :profile_image
  
 with_options on: :create do  
  validates :email, uniqueness: true
  validates :password, length: { minimum: 6 }
  validates :name, length: { minimum: 2, maximum: 20 }, uniqueness: true
end

  validates :name, length: { minimum: 2, maximum: 20 }, uniqueness: true
  validates :introduction, length: { maximum: 50 }

  def get_profile_image(width: 100, height: 100)
    # デフォルト画像が未添付の場合、ファイルパスを指定して添付
    unless profile_image.attached?
      file_path = Rails.root.join('app', 'assets', 'images', 'no_image.jpg')
      profile_image.attach(io: File.open(file_path), filename: 'no_image.jpg', content_type: 'image/jpg')
    end
    
    # サイズ指定があれば変換
    profile_image.variant(resize_to_limit: [width, height]).processed
  end
end