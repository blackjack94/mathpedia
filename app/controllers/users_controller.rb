class UsersController < ApplicationController

	before_action :must_not_signed_in, only: [:new, :create]
	before_action :must_signed_in, only: [:index, :edit, :update, :status]
	before_action :must_own_it, only: [:edit, :update]
	before_action :must_be_master, only: [:index, :status]

	def new
		@user = User.new
		fresh_when [@user, form_authenticity_token]
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

	def index
		username = params[:username].downcase if params[:username]
		status = { 'pending' => 0, 'approved' => 1, 'blocked' => 2, 'master' => 'master' }[params[:status]]

		if status.nil? || (status == 'master' && !current_user.admin?)
			flash[:info] = "Trang này không tồn tại!"
			redirect_to users_path(status: 'approved')
		else
			@users = User.filter(username, status).paginate(page: params[:page], per_page: 10).to_a
			@blocked = true if status == 2

			fresh_when etag: users_cache_key
		end
	end

	def show
		@user = User.find_by(username: params[:username])
		
		if @user.nil?
			flash[:danger] = "Tài khoản \"#{params[:username]}\" không tồn tại!"
			redirect_to root_path
		end

		fresh_when(@user)
	end

	def edit
		fresh_when(form_authenticity_token)
	end

	def update
		if @user.update_attributes(user_params)
      flash[:success] = "Cập nhật thành công!"
      redirect_to edit_user_path(@user.username)
    else
      render :edit
    end
	end

	def status
		user = User.find(params[:id])

		if user.nil? || (params[:change] == 'demote' && !current_user.admin?)
			flash[:info] = 'Làm bậy hả chú? Log lại rồi đó nha!'
		else
			user.change_status(params[:change])
			sign_out(user) if params[:change] == 'block'
		end

		redirect_to users_path(status: params[:back])
	end

	private
		def user_params
			params.require(:user).permit(:username, :facebook, :school, :avatar, :password, :password_confirmation)
		end

		def must_own_it
			@user = User.find_by(username: params[:username])

			unless current_user? @user
        flash[:info] = "Đừng hack tài khoản của bạn khác nhe đồng chí!"
        redirect_to edit_user_path(current_user.username)
      end
		end

end
