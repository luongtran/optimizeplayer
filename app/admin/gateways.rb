ActiveAdmin.register Gateway do
  menu :priority => 7

  index do
    column :id
    column "Gateway name", :name
    column "Orders count" do |gateway|
      gateway.orders.count.to_s
    end
    column "url" do |gateway|
      root_url(subdomain: false, protocol: "https") + "api/v1/billing/ipn/#{gateway.id}"
    end
    actions
  end


  form do |f|
    f.inputs do
      f.input :name, :label=> "Gateway name"
      f.input :key, :label=> "Gateway secret key"
      f.input :date
      f.input :transaction_code
      f.input :user_name
      f.input :email
      f.input :phone
      f.input :amount
      f.input :affiliate
      f.input :payment_method
      f.input :address_1
      f.input :address_2
      f.input :city
      f.input :state
      f.input :postal_code
      f.input :country_name
      f.input :transaction_type
      f.input :currency
      f.input :charge_type
      f.input :tracking_id
      f.input :tax
      f.input :plan_id, :label=> "Plan id"
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
