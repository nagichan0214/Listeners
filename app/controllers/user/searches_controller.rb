class User::SearchesController < ApplicationController
  before_action :authenticate_user!

  def search
    p @range = params[:range]
    #byebug
    if @range == "user"
      @users = User.looks(params[:word]).page(params[:page])
    else
      @posts = Post.looks(params[:word]).page(params[:page])
    end
  end
end
