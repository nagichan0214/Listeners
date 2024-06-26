class User::UsersController < ApplicationController
  before_action :authenticate_user!, except: [:top]
  #before_action :ensure_guest_user, only: [:edit]

  def show
    @user = User.find(params[:id])
    @posts = @user.posts.order(created_at: :desc).page(params[:page])
    @currentUserEntry=Entry.where(user_id: current_user.id)
    @userEntry=Entry.where(user_id: @user.id)
    if @user.id == current_user.id
    else
      @currentUserEntry.each do |cu|
        @userEntry.each do |u|
          if cu.room_id == u.room_id then
            @isRoom = true
            @roomId = cu.room_id
          end
        end
      end
      if @isRoom
      else
        @room = Room.new
        @entry = Entry.new
      end
    end
  end

  def edit
    @user = User.find(params[:id])
    if current_user != @user
      redirect_to user_user_path(@user)
    end
  end

  def update
  @user = User.find(params[:id])
    if current_user == @user
      if @user.update(user_params)
        flash[:notice] = "更新しました!"
        redirect_to user_user_path(@user.id)
      else
        flash[:alert] = "更新できませんでした..."
        render :edit
      end
    else
      redirect_to user_user_path(@user)
    end
  end

  def favorites
    @user = User.find(params[:id])
    favorites = Favorite.where(user_id: @user.id).pluck(:post_id)
    @favorite_posts = Post.where(id: favorites).page(params[:page])
  end

  def index
  end

  def withdrawal
    @user = User.find(params[:id])
    if current_user == @user
      # is_deletedカラムをtrueに変更することにより削除フラグを立てる
      @user.update(is_deleted: true)
      reset_session
      flash[:notice] = "退会処理を実行いたしました"
      redirect_to user_root_path
    else
      redirect_to user_user_path(@user)
    end
  end

private

  def user_params
    params.require(:user).permit(:name, :profile_image, :introduction)
  end

  def ensure_guest_user
    @user = User.find(params[:id])
    if @user.email == "guest@example.com"
      redirect_to user_user_path(current_user) , notice: "ゲストユーザーはプロフィール編集画面へ遷移できません。"
    end
  end


end
