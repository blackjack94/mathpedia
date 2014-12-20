module SessionsHelper

#SIGN IN & SIGN OUT
#=====================================================================
	def sign_in user
  	remember_token = User.new_remember_token

  	#save to cookies; encrypt then save to DB
  	cookies.permanent[:remember_token] = remember_token
  	user.update_attribute(:remember_token, User.digest(remember_token))
  end

  def sign_out
  	#new remember_token, delete old from cookies
    current_user.update_attribute(:remember_token, User.digest(User.new_remember_token))
    cookies.delete(:remember_token)
  end

#CURRENT_USER RELATED
#=====================================================================
	def current_user
    token = cookies[:remember_token]

    unless token.nil?
      remember_token = User.digest(token)
      @current_user ||= User.find_by(remember_token: remember_token)
    end
  end

  #check if a visitor is signed_in?
  def signed_in?
  	true unless current_user.nil?
  end

  #check if current_user is someone
  def current_user?(user)
    current_user == user
  end

#AUTHORIZATION
#=====================================================================
	#SIGNED_IN ONLY
  def must_signed_in
    unless signed_in?
      flash[:warning] = 'Please sign in!'
      redirect_to signin_path
    end
  end

  #NON-SIGNED_IN ONLY
  def must_not_signed_in
    redirect_to root_path if signed_in?
  end

end
