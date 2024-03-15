class User::SearchesController < ApplicationController
  before_action :authenticate_user!

  def search
    @range = params[:range]

    if @range == "User"
      @users = User.looks(params[:word]).page(params[:page])
    else
      @posts = Post.looks(params[:word]).page(params[:page])
    end
    
  end
end
