class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  include SessionsHelper

  etag { flash }
  etag { current_user }

  helper_method :users_cache_key

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

end
