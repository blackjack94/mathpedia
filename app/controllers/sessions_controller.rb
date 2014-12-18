class SessionsController < ApplicationController

  before_action :must_not_signed_in, except: [:destroy]
  before_action :must_signed_in, only: [:destroy]

  def new  	
  end

  def create
  	user = User.find_by(username: params[:session][:username].downcase)

  	if user && user.approved? && user.authenticate(params[:session][:password])
      sign_in user
  		flash[:success] = "<h4>WELCOME TO MATHPEDIA!</h4><p>Joining contests and Win a Gold.</p>"
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
