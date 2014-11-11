class PlanList < ActiveRecord::Base
  # attr_accessible :title, :body
  #
  has_many :plans, order: :position

end
