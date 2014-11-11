# -*- coding: utf-8 -*-
class PurchasesMailer < ActionMailer::Base
  default from: "OptimizePlayer <#{ActiveadminSettings::Setting::value('Site Admin Email', 'en')}>"

  def video_access_token(email, token, referer)
    init_mailer
    @url = [referer, "?video_token=", token.token].join("")
    project = token.project


    mail(to: email,
         subject: "Access to video #{project.title}")
  end

  private
  def init_mailer
    ActionMailer::Base.postmark_settings = {:api_key => ActiveadminSettings::Setting::value('Postmark API Key', 'en')}
  end
end
