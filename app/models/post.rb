class Post < ApplicationRecord
  has_one_attached :image
  
  validates :title, length:{ maximum: 30, too_long: "は%{count}字以下で投稿してください" }, presence: true
  validates :body, length:{ maximum: 140, too_long: "は%{count}字以下で投稿してください" }, presence: true

  
  belongs_to :user
  has_many :post_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy

  
  def get_image
    if image.attached?
      image
    end
  end
  
  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end
  
  def self.looks(word)
    if Post.where("title LIKE?","%#{word}%").present?
      @post = Post.where("title LIKE?","%#{word}%")
    else
      @post = Post.all
    end
  end


end
