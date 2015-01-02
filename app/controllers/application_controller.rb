class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  rescue_from ActionController::InvalidAuthenticityToken, :with => :sign_out_user

  include SessionsHelper

  etag { flash }
  etag { current_user }

  helper_method :users_cache_key, :problems_cache_key

  #users cache key
    def users_cache_key
    	"users/all-#{users_count}-#{users_max_updated_at}"
    end

    def users_count
    	Rails.cache.fetch("users-count") { User.count }
    end

    def users_max_updated_at
    	Rails.cache.fetch("users-max-updated-at") do
    		User.maximum(:updated_at).try(:utc).try(:to_s, :number)
    	end
    end

  #problems cache key
    def problems_cache_key
      "problems/all-#{problems_count}-#{problems_max_updated_at}"
    end

    def problems_count
      Rails.cache.fetch("problems-count") { Problem.count }
    end

    def problems_max_updated_at
      Rails.cache.fetch("problems-max-updated-at") do
        Problem.maximum(:updated_at).try(:utc).try(:to_s, :number)
      end
    end

  private
    def sign_out_user
      sign_out(current_user) if signed_in?
      flash[:warning] = 'Your session has expired, please login again!'
      redirect_to signin_path
    end

end
