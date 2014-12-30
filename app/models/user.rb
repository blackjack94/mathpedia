# == Schema Information
#
# Table name: users
#
#  id                  :integer          not null, primary key
#  username            :string(255)
#  password_digest     :string(255)
#  remember_token      :string(255)
#  created_at          :datetime
#  updated_at          :datetime
#  facebook            :string(255)
#  school              :string(255)
#  admin               :boolean          default(FALSE)
#  master              :boolean          default(FALSE)
#  status              :integer          default(0)
#  avatar_file_name    :string(255)
#  avatar_content_type :string(255)
#  avatar_file_size    :integer
#  avatar_updated_at   :datetime
#

class User < ActiveRecord::Base

	before_create :create_remember_token
	before_save { username.downcase! }
	after_commit :invalidate_cache

	enum status: [ :pending, :approved, :blocked ]

#RELATIONSHIPS
#================================================================
	has_many :problems, foreign_key: 'author_id', dependent: :destroy

#AVATAR
#================================================================
	has_attached_file :avatar, 
										styles: { thumb: '26x26!', square: '50x50!', preview: '96x96!' },
										path: '/users/:id/avatar/:style/:basename.:extension',
										default_url: ":style/missing.png"

  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/
  validates_attachment :avatar, :size => { :less_than => 200.kilobytes }

#VALIDATIONS
#================================================================
	#username
	VALID_USERNAME_REGEX = /\A[a-zA-Z0-9]+(_?[a-zA-Z0-9]+)+\z/
	validates :username, presence: true,
											 length: { minimum: 2, maximum: 50 },
											 format: { with: VALID_USERNAME_REGEX },
											 uniqueness: { case_sensitive: false }

	#password											 
	has_secure_password
	validates :password, length: { minimum: 6 }, unless: :no_password_provide

	#information (no validation of facebook)
	validates :school, presence: true

#SIGNING IN (remember_token)
#================================================================
	def User.new_remember_token
		SecureRandom.urlsafe_base64
	end

	def User.digest(token)
		Digest::SHA1.hexdigest(token.to_s)
	end

#ADMIN MODULE
#================================================================
	def User.filter username, status
		if status == 'master'
			where('username LIKE ? AND master = true', "%#{username}%")
		else
			where('username LIKE ? AND status = ?', "%#{username}%", status)
		end
	end

	def change_status action
		if self.master? && !self.admin?
			update_attribute(:master, false) if action == 'demote'
		else
			if action == 'delete'
				destroy
			elsif action == 'approve' || action == 'unblock'
				update_attribute(:status, 'approved')
			elsif action == 'block'
				update_attribute(:status, 'blocked')
			elsif action == 'promote'
				update_attribute(:master, true) if self.approved?
			end
		end
	end

#PRIVATE
#================================================================
	private
		def create_remember_token
			self.remember_token = User.digest(User.new_remember_token)
		end

		def no_password_provide
			self.password.blank?
		end

		def invalidate_cache
			Rails.cache.delete('users-count')
			Rails.cache.delete('users-max-updated-at')
		end

end
