class Admin::UserManagementController < ApplicationController
    before_action :authenticate_user!

    def index
        authorize! :index, User
        @users = User.where(role: :seller)
    end

    def new
        authorize! :new, User
        @user = User.new
    end

    def create
        authorize! :create, User
        @user = User.new(user_params)
        @user.role = :seller

        if @user.save
            redirect_to admin_user_management_index_path, notice: 'User was successfully created.'
        else
            render:new
        end
    end

    def edit
        authorize! :edit, User
        @user = User.find(params[:id])
    end

    def update 
        authorize! :update, User
        @user = User.find(params[:id])

        if @user.update(user_params)
            redirect_to admin_user_management_index_path, notice: 'User was successfully updated'
        else
            render :edit
        end
    end

    def destroy
        authorize! :destroy, User
        @user = User.find(params[:id])
        @user.destroy
    
        redirect_to admin_user_management_index_path, notice: 'User was successfully destroyed.'
    end

    private

    def user_params
        params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end      
end
