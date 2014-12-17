# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  username        :string(255)
#  password_digest :string(255)
#  remember_token  :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#  facebook        :string(255)
#  school          :string(255)
#  admin           :boolean          default(FALSE)
#  master          :boolean          default(FALSE)
#  status          :integer          default(0)
#

class User < ActiveRecord::Base

	before_create :create_remember_token
	before_save { username.downcase! }

	enum status: [ :pending, :approved, :blocked ]

#VALIDATIONS
#====================================================================
	#username
	VALID_USERNAME_REGEX = /\A[a-zA-Z0-9]+(_?[a-zA-Z0-9]+)+\z/
	validates :username, presence: true,
											 length: { minimum: 2, maximum: 50 },
											 format: { with: VALID_USERNAME_REGEX },
											 uniqueness: { case_sensitive: false }

	#password											 
	has_secure_password
	validates :password, length: { minimum: 6 }

	#information (no validation of facebook)
	validates :school, presence: true

#SIGNING IN (remember_token)
#====================================================================
	def User.new_remember_token
		SecureRandom.urlsafe_base64
	end

	def User.digest(token)
		Digest::SHA1.hexdigest(token.to_s)
	end

	private
		def create_remember_token
			self.remember_token = User.digest(User.new_remember_token)
		end

end
