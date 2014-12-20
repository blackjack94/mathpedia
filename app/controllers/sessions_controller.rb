class SessionsController < ApplicationController

  before_action :must_not_signed_in, only: [:new, :create]
  before_action :must_signed_in, only: [:destroy]

  def new  	
  end

  def create
  	user = User.find_by(username: params[:session][:username].downcase)

  	if user && user.authenticate(params[:session][:password])
      key, message = {
        pending: [:info, "<h4>PLEASE WAIT!</h4><p>We're processing your info.</p>"],
        approved: [:success,"<h4>WELCOME TO MATHPEDIA!</h4><p>Joining contests and Win a Gold.</p>"],
        blocked: [:danger, "<h4>WE'RE SORRY!</h4><p>Your account is blocked.</p>"] 
      }[user.status.to_sym]

      flash[key] = message
      sign_in user if user.approved?
      redirect_to root_path
  	else
  		@error = 'Wrong username or password!'
  		render :new
  	end
  end

  def destroy
    sign_out
    flash[:success] = "<h4>GOODBYE!</h4><p>See you next Contest.</p>"
    redirect_to root_path
  end

end
