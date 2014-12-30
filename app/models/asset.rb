# == Schema Information
#
# Table name: assets
#
#  id                 :integer          not null, primary key
#  image_file_name    :string(255)
#  image_content_type :string(255)
#  image_file_size    :integer
#  image_updated_at   :datetime
#  created_at         :datetime
#  updated_at         :datetime
#

class Asset < ActiveRecord::Base

	has_attached_file :image, styles: { original: '500>' }, 
														path: '/assets/:id/:basename.:extension'

  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/
  validates_attachment :image, :size => { :less_than => 200.kilobytes }

end
