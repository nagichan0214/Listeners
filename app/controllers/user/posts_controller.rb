class User::PostsController < ApplicationController
  before_action :authenticate_user!
  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    if @post.save
      flash[:notice] = "投稿に成功しました!"
      redirect_to user_posts_path
    else
      flash[:alert] = "投稿に失敗しました..."
      render :new
    end
  end

  def index

    @posts = Post.all.order(created_at: :desc).page(params[:page])
  end

  def show
    @post = Post.find(params[:id])
    @post_comment = PostComment.new
    @post_comments = @post.post_comments
    @comment_errors = @post_comments.map(&:errors)
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
    if @post.update(post_params)
      flash[:notice] = "更新しました!"
      redirect_to user_post_path(@post.id)
    else
      flash[:alert] = "更新できませんでした..."
      render :edit
    end
  end

  def destroy
    post = Post.find(params[:id])
    post.destroy
    redirect_to user_posts_path
  end

   private

  def post_params
    params.require(:post).permit(:title, :image, :body)
  end
end
