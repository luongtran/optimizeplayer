class Transaction < ActiveRecord::Base
  attr_accessible :description, :account_id, :amount, :charge_id
  belongs_to :account

  acts_pricefully :amount
end
