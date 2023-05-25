class Admin::UserManagementController < ApplicationController
    before_action :authenticate_user!

    def index
        @users = User.where(role: :seller)
    end

    def new
        @user = User.new
    end

    def create
        @user = User.new(user_param)
        @user.role = :seller

        if @user.save
            redirect_to admin_user_management_index_path, notice: 'User was successfully created.'
        else
            render:new
        end
    end

    def edit
        @user = User.find(params[:id])
    end

    def update 
        @user = User.find(params[:id])

        if @user.update(user_param)
            redirect_to admin_user_management_index_path, notice: 'User was successfully updated'
        else
            render :edit
        end
    end

    def destroy
        @user = User.find(params[:id])
        @user.destroy
    
        redirect_to admin_user_management_index_path, notice: 'User was successfully destroyed.'
    end

    private

    def user_param
        params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end      
end
