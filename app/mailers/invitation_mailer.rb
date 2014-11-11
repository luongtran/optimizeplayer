# -*- coding: utf-8 -*-
class InvitationMailer < ActionMailer::Base
  default from: "OptimizePlayer <#{ActiveadminSettings::Setting::value('Site Admin Email', 'en')}>"

  def invitation_message(user, password)
    init_mailer
    @user = user
    @pass = password
    @account_name = @user.account.name
    mail(:to => @user.email,
       :subject => "#{@account_name} Has Invited You to Join Their OptimizePlayer Team")
  end

  private
  def init_mailer
    ActionMailer::Base.postmark_settings = {:api_key => ActiveadminSettings::Setting::value('Postmark API Key', 'en')}
  end
end
