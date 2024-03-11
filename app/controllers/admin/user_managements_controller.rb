class Admin::UserManagementsController < ApplicationController
  before_action :authenticate_admin!
  def index
    @users = User.all
  end

  def show
  @user = User.find(params[:id])
  end

  def destroy
  @user = User.find(params[:id])
  @user.update(is_deleted: true)
  redirect_to admin_user_managements_path, notice: "ユーザーを削除しました"
end
end
