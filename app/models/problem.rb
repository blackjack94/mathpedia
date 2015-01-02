# == Schema Information
#
# Table name: problems
#
#  id         :integer          not null, primary key
#  title      :string(255)
#  statement  :text
#  solution   :text
#  status     :integer          default(0)
#  difficulty :integer          default(0)
#  domain_id  :integer
#  author_id  :integer
#  created_at :datetime
#  updated_at :datetime
#

class Problem < ActiveRecord::Base
  belongs_to :domain
  belongs_to :author, class_name: 'User'

  enum status: [ :draft, :ready, :online, :official ]
  enum difficulty: [ :easy, :medium, :hard ]

  before_create :default_solution

#VALIDATIONS
#================================================================
  #title
  validates :title, presence: true,
  									length: { maximum: 140 }

  #statement
  validates :statement, presence: true

  #domain & author
  validates :domain_id, presence: true
  validates :author_id, presence: true

#BUSINESS LOGIC
#================================================================
  def Problem.options_for(attribute)
    Problem.try(attribute).map { |key, value| [key, key] }
  end

  def Problem.filter(domain_id, difficulty)
    domain_id = '1' if domain_id.nil?

    if difficulty.nil? || difficulty == '3'
      official.where('domain_id = ?', domain_id).order(updated_at: :desc)
    else
      official.where('domain_id = ? AND difficulty = ?', domain_id, difficulty).order(updated_at: :desc)  
    end
  end

#PRIVATE
#================================================================
  private
    def default_solution
    	self.solution = 'Lời giải và Bình luận'
    end

end
