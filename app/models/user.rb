class User < ApplicationRecord

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
         
  has_many :posts, dependent: :destroy
  has_many :post_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :reverse_of_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  has_many :followings, through: :relationships, source: :followed
  has_many :followers, through: :reverse_of_relationships, source: :follower
  
  has_one_attached :profile_image
  
  def active_for_authentication?
    super && (is_deleted == false)
  end
  
  def get_profile_image(width, height)
    unless profile_image.attached?
      file_path = Rails.root.join('app/assets/images/no-user.PNG')
      profile_image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
    profile_image.variant(resize_to_limit: [width, height]).processed
  end
  
  # ゲストログイン
  GUEST_USER_EMAIL = "guest@example.com"
  
  def self.guest
    find_or_create_by!(email: GUEST_USER_EMAIL) do |user|
      user.password = SecureRandom.urlsafe_base64
      user.name = "guestuser"
    end
  end
  
  def guest_user?
    email == GUEST_USER_EMAIL
  end
  
  # 検索方法分岐
  def self.looks(word)
    if User.where("name LIKE?","%#{word}%").present?
      @user = User.where("name LIKE?","%#{word}%")
    else
      @user = User.all
    end
  end
  
  def follow(user_id)
  relationships.create(followed_id: user_id)
  end
  
  def unfollow(user_id)
  relationships.find_by(followed_id: user_id).destroy
  end
  
  def following?(user)
  followings.include?(user)
  end
  
end