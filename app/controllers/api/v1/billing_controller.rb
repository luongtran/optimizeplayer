module Api
  module V1
    class BillingController < Api::V1::BaseController
      inherit_resources
      before_filter :authenticate_user!, except: [:ipn]
      skip_before_filter :check_subdomain, only: [:ipn]
      skip_before_filter :check_user_suspend, only: [:ipn]
      respond_to :json

      def ipn
        unless params.blank? and params[:id].blank?
          gateway_id = params[:id]
          gateway = Gateway.find_by_id(gateway_id)
          unless gateway.blank?
            post_order = params
            except_keys = ["format", "action", "controller", "id"]
            except_keys.each do |key|
              post_order.except!(key)
            end
            if post_order.size > 0
              # verify = ipnVerify(post_order, gateway)
              # if verify
                keys = []
                post_order.each do |key, value|
                  keys.push key
                end
                unless keys.blank?
                  order = Order.new
                  gateway.attributes.keys.each do |column_name|
                    unless gateway[column_name].blank?
                      unless post_order[gateway[column_name]].blank?
                        if column_name == "date"
                          order[column_name] = Time.at(post_order[gateway[column_name]].to_i)
                        else
                          order[column_name] = post_order[gateway[column_name]]
                        end
                      end
                    end
                  end
                  order.gateway_id = gateway.id

                  if gateway.name.downcase != "jvzoo"
                    order.amount = in_pennies(order.amount)
                    order.ramount = in_pennies(order.ramount)
                    order.tax = in_pennies(order.tax)
                  end

                  if order.plan_id.blank?
                    plan = Plan.find_by_plan_type("free")
                    unless plan.blank?
                      order.plan_id = plan.id
                    else
                      plan = Plan.where("id > 0").first
                      unless plan.blank?
                        order.plan_id = plan.id
                      end
                    end
                  else
                    plan = Plan.find_by_id(order.plan_id)
                    unless plan.blank?
                      order.plan_id = plan.id
                    else
                      plan = Plan.find_by_name("Free")
                      unless plan.blank?
                        order.plan_id = plan.id
                      end
                    end
                  end
                  saved = order.save

                  unless saved.blank?
                    trx_map = TransactionMapping.where(TransactionMapping.arel_table[:value].matches("%"+post_order[gateway.transaction_type]+"%")).first
                    unless trx_map.blank?
                      result = exec_action(trx_map.action, order)
                    end
                  end
                end
              # end # verify
            end
          end
        end
        render nothing: true, status: :ok
      end

      private

      def exec_action(action=nil, order=nil)
        case action
        when "create_account"
          unless order.email.blank?
            check_user = User.find_by_email(order.email)
            if check_user.blank?
              user_name = "default_" + SecureRandom.hex(4)
              unless order.user_name.blank?
                user_name = order.user_name
              end
              pass = SecureRandom.base64(6)
              user = User.create(
                email: order.email,
                password: pass,
                password_confirmation: pass,
                name: user_name
              )
              unless user.blank?
                unless order.plan_id.blank?
                  account = Account.find_by_id(user.account_id)
                  unless account.blank?
                    plan = Plan.find_by_id(order.plan_id)
                    unless plan.blank?
                      account.create_customer()
                    end
                  end
                end
                BillingMailer.send_pass(user, pass).deliver
              end
            end
          end
        when "account_overdue"
          check_user = User.find_by_email(order.email)
          if !check_user.blank? and check_user.overdue_notify.blank?
            check_user.overdue_notify = 1
            check_user.save
            BillingMailer.send_overdue_notify(check_user).deliver
          end
        when "suspend_account"
          suspend_user = User.find_by_email(order.email)
          unless suspend_user.blank?
            suspend_user.suspend = 1
            suspend_user.save
            BillingMailer.send_suspend(suspend_user).deliver
          end
        else
        end
      end

      def in_pennies(amount)
        unless amount.blank?
          amount / 100
        end
      end

      def ipnVerify(post_params, gateway)
        unless gateway.transaction_code.blank?
          secret_key = (!gateway.blank? and !gateway.key.blank?) ? gateway.key : ""
          pop = ""
          ipn_fields = []
          secret_key_name = ""
          if post_params.has_key?(gateway.transaction_code) and !post_params[gateway.transaction_code].blank?
            post_params.each_key do |key|
              if key == gateway.transaction_code
                secret_key_name = key
                next
              end
              ipn_fields.push(key)
            end
            ipn_fields.sort
            ipn_fields.each do |field|
              pop += post_params[field] + "|"
            end
            pop += secret_key
            calced_verification = Digest::SHA1.hexdigest(pop).upcase[0,8]
            data = {
              post_params: post_params,
              ipn_fields: ipn_fields,
              pop: pop,
              secret_key_value: post_params[secret_key_name],
              calced_verification: calced_verification
            }
            BillingMailer.send_test(data).deliver
            calced_verification == post_params[secret_key_name]
          else
            false
          end
        else
          false
        end
      end

    end
  end
end