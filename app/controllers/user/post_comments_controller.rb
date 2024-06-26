class User::PostCommentsController < ApplicationController

  def create
    @post = Post.find(params[:post_id])
    @comment = current_user.post_comments.new(post_comment_params)
    @comment.post_id = @post.id
    if @comment.save

      redirect_to user_post_path(@post.id)  
    else
      @post_comments = @post.post_comments
      @post_comment = PostComment.new
      render template: "user/posts/show"
    end
  end
  
  def destroy
    @comment = PostComment.find(params[:id])
    if @comment.user == current_user
      @comment.destroy
    end
    redirect_to user_post_path(params[:post_id])
  end
  
  
  private
  
  def post_comment_params
     params.require(:post_comment).permit(:comment)
  end





end
