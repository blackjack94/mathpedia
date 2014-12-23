class SessionsController < ApplicationController

  before_action :must_not_signed_in, only: [:new, :create]
  before_action :must_signed_in, only: [:destroy]

  def new  	
  end

  def create
  	user = User.find_by(username: params[:session][:username].downcase)

  	if user && user.authenticate(params[:session][:password])
      key, message = {
        "pending" => [:info, "<h4>XIN CHỜ!</h4><p>Thông tin của Bạn đang được Xử lý!</p>"],
        "approved" => [:success,"<h4>WELCOME TO MATHPEDIA!</h4><p>Hãy chọn một Bài thi và lấy HC Vàng nào!</p>"],
        "blocked" => [:danger, "<h4>XIN LỖI!</h4><p>Tài khoản của bạn đã bị khoá.</p>"] 
      }[user.status]

      flash[key] = message
      sign_in user if user.approved?
      redirect_to root_path
  	else
  		@error = 'Sai username hoặc password!'
  		render :new
  	end
  end

  def destroy
    sign_out current_user
    flash[:success] = "<h4>TẠM BIỆT!</h4><p>Hẹn gặp lại trong Bài thi sau.</p>"
    redirect_to root_path
  end

end
