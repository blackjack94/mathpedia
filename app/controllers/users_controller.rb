class UsersController < ApplicationController

	before_action :must_not_signed_in, only: [:new, :create]
	before_action :must_signed_in, only: [:edit, :update]
	before_action :must_own_it, only: [:edit, :update]

	def new
		@user = User.new
	end

	def create
		@user = User.new(user_params)

		if @user.save
			flash[:success] = "<h4>ĐĂNG KÝ THÀNH CÔNG!</h4><p>Thông tin của bạn đang được xử lý và sẽ được thông báo qua Facebook.</p>"
			redirect_to root_path
		else
			render :new
		end
	end

	def show
		@user = User.find_by(username: params[:username])
	end

	def edit
	end

	def update
		if @user.update_attributes(user_params)
      flash[:success] = "Update success!"
      redirect_to edit_user_path(@user.username)
    else
      render :edit
    end
	end

	private
		def user_params
			params.require(:user).permit(:username, :facebook, :school, :password, :password_confirmation)
		end

		def must_own_it
			@user = User.find_by(username: params[:username])

			unless current_user? @user
        flash[:info] = "Please edit your profile!"
        redirect_to edit_user_path(current_user.username)
      end
		end

end
