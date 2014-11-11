class Gateway < ActiveRecord::Base
  attr_accessible :name, :date, :transaction_code, :email, :phone, :amount, :affiliate, :payment_method, 
                  :address_1, :address_2, :city, :state, :postal_code, :country_name, :transaction_type, :currency, 
                  :charge_type, :tracking_id, :tax, :user_name, :plan_id, :custom1, :custom2, :custom3, :custom4, 
                  :custom5, :custom6, :custom7, :custom8, :custom9, :custom10, :ramount, :rfrequency, :rfuturepayments, 
                  :rnextpaymentdate, :rstatus, :transaction_parent, :key, :date
  has_many :orders
end
