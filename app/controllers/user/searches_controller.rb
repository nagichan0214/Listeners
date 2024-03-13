class User::SearchesController < ApplicationController
  before_action :authenticate_user!

  def search
    @range = params[:range]

    if @range == "User"
      @users = User.looks(params[:word])
    else
      @posts = Post.looks(params[:word])
    end
    
  end
end
