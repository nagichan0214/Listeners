class User::PostsController < ApplicationController
  def new
    @post = Post.new
  end
  
  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    @post.save
    redirect_to user_posts_path
  end
  
  def index
    @posts = Post.all
  end

  def show
    @post = Post.find(params[:id])
  end

  def edit
  end
  
  
   private

  def post_params
    params.require(:post).permit(:title, :image, :body)
  end
end
