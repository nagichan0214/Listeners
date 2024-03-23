class PostComment < ApplicationRecord
  
belongs_to :user
belongs_to :post
validates :comment, length:{ maximum: 140, too_long: "は%{count}字以下で投稿してください" }, presence: { message: "が空です" }
end
