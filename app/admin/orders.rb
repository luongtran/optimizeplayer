ActiveAdmin.register Order do
  actions :all, except: [:new]

  filter :id, :as => :numeric
  filter :date
  filter :transaction_code
  filter :name, :label=> "Gateway name"
  filter :user_name
  filter :amount
  filter :affiliate
  filter :charge_type
  filter :email
  filter :phone
  filter :payment_method
  filter :address_1
  filter :address_2
  filter :city
  filter :state
  filter :postal_code
  filter :country_name
  filter :transaction_type
  filter :currency
  filter :tracking_id
  filter :tax
  filter :plan_id
  filter :ramount
  filter :rfrequency
  filter :rfuturepayments
  filter :rnextpaymentdate
  filter :rstatus
  filter :transaction_parent
  filter :custom1
  filter :custom2
  filter :custom3
  filter :custom4
  filter :custom5
  filter :custom6
  filter :custom7
  filter :custom8
  filter :custom9
  filter :custom10


  scope :all, :default => true
  scope :standard
  scope :recurring

  index do
    column "Order", :id
    column :date
    column :transaction_code
    column "Gateway name", :name do |order|
      Gateway.find(order.gateway_id).name
    end
    column :user_name
    column :amount
    column :affiliate
    column :charge_type
    column :plan_id do |order|
      Plan.find(order.plan_id).name
    end
    actions
  end

  show do
    panel "Order Details" do
      attributes_table_for order do
        row("Gateway name") { |order| Gateway.find(order.gateway_id).name }
        row("Date") { |order| order.date }
        row("User name") { |order| order.user_name }
        row("Transaction code") { |order| order.transaction_code }
        row("Amount") { |order| order.amount }
        row("Affiliate") { |order| order.affiliate }
        row("Charge type") { |order| order.charge_type }
        row("Email") { |order| order.email }
        row("Phone") { |order| order.phone }
        row("Payment method") { |order| order.payment_method }
        row("Address 1") { |order| order.address_1 }
        row("Address 2") { |order| order.address_2 }
        row("City") { |order| order.city }
        row("State") { |order| order.state }
        row("Postal code") { |order| order.postal_code }
        row("Country name") { |order| order.country_name }
        row("Transaction type") { |order| order.transaction_type }
        row("Currency") { |order| order.currency }
        row("Tracking id") { |order| order.tracking_id }
        row("Tax") { |order| order.tax }
        row("Plan id") {|order| order.plan_id }
        row("Custom1") { |order| order.custom1 }
        row("Custom2") { |order| order.custom2 }
        row("Custom3") { |order| order.custom3 }
        row("Custom4") { |order| order.custom4 }
        row("Custom5") { |order| order.custom5 }
        row("Custom6") { |order| order.custom6 }
        row("Custom7") { |order| order.custom7 }
        row("Custom8") { |order| order.custom8 }
        row("Custom9") { |order| order.custom9 }
        row("Custom10") { |order| order.custom10 }
        row("Ramount") { |order| order.ramount }
        row("Rfrequency") { |order| order.rfrequency }
        row("Rfuturepayments") { |order| order.rfuturepayments }
        row("Rnextpaymentdate") { |order| order.rnextpaymentdate }
        row("Rstatus") { |order| order.rstatus }
        row("Transaction parent") { |order| order.transaction_parent }
      end
    end
  end

  form do |f|
    f.inputs do
      f.input :date
      f.input :transaction_code
      f.input :name, :label=> "Gateway name", :as => :select, :collection => Gateway.all.map{|g| ["#{g.name}", g.id]}
      f.input :user_name
      f.input :amount
      f.input :affiliate
      f.input :charge_type
      f.input :email
      f.input :phone
      f.input :payment_method
      f.input :address_1
      f.input :address_2
      f.input :city
      f.input :state
      f.input :postal_code
      f.input :country_name
      f.input :transaction_type
      f.input :currency
      f.input :tracking_id
      f.input :tax
      f.input :plan_id, :label=> "Plan id", :as => :select, :collection => Plan.all.map{|p| ["#{p.name}", p.id]}
      f.input :ramount
      f.input :rfrequency
      f.input :rfuturepayments
      f.input :rnextpaymentdate
      f.input :rstatus
      f.input :transaction_parent
      f.input :custom1
      f.input :custom2
      f.input :custom3
      f.input :custom4
      f.input :custom5
      f.input :custom6
      f.input :custom7
      f.input :custom8
      f.input :custom9
      f.input :custom10
    end
    f.actions
  end
end
