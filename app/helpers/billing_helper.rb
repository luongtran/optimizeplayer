module BillingHelper
	def account_usage_bar(small=false)
    user_embeds = current_user.embeds_count 
    plan_embeds_count = current_account.subscription.plan.embeds_count
    
    percentage, plan_embeds = if current_account.prepaid || plan_embeds_count == -1
                  [0, "&#8734;"]
                 else
                  [(user_embeds * 100 / plan_embeds_count).to_i, plan_embeds_count]
                 end
    
    raw("<div class='usage'>
          Account Usage: #{user_embeds} / #{plan_embeds}
          <div class='progress'>
            <div class='progress-bar' role='progressbar' aria-valuenow='#{user_embeds}' aria-valuemin='0' aria-valuemax='#{plan_embeds}' style='width: #{user_embeds}%;'>
              <span class='sr-only'></span>
            </div>
          </div>
        </div>")
  end
end
