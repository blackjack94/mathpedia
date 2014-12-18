class UsersController < ApplicationController

	before_action :must_not_signed_in

	def new
		@user = User.new
	end

	def create
		@user = User.new(user_params)

		if @user.save
			sign_in @user
			flash[:success] = "<h4>ĐĂNG KÝ THÀNH CÔNG!</h4><p>Thông tin của bạn đang được xử lý và sẽ được thông báo qua Facebook.</p>"
			redirect_to root_path
		else
			render :new
		end
	end

	private
		def user_params
			params.require(:user).permit(:username, :facebook, :school, :password, :password_confirmation)
		end

end
