# -*- coding: utf-8 -*-
class BillingMailer < ActionMailer::Base
  default from: "OptimizePlayer <#{ActiveadminSettings::Setting::value('Site Admin Email', 'en')}>"

  def send_pass(user, pass)
    init_mailer
    @mail_data = {
      user: user,
      pass: pass,
      sub_root_url: root_url(:subdomain => user.url),
      root_url: root_url
    }
    email_with_name = "#{@mail_data[:user].name} <#{@mail_data[:user].email}>"
    mail(
      to: email_with_name,
      subject: 'Welcome to Optimize player',
      date: Time.now,
      content_type: "text/html"
    )
  end

  def send_test(data)
    init_mailer
    @mail_data = data
    email_with_name = "Xing Jin <jinxing823@gmail.com>"
    mail(
      to: email_with_name,
      subject: 'Billing Test',
      date: Time.now,
      content_type: "text/html"
    )
  end

  def send_overdue_notify(data)
    init_mailer
    if data.overdue_notify.blank?
      data.overdue_notify = 1
    end
    if data.overdue_notify <= 8
      @mail_data = {
        user: data,
        days: 8 - data.overdue_notify,
        root_url: root_url
      }
      email_with_name = "#{@mail_data[:user].name} <#{@mail_data[:user].email}>"
      mail(
        to: email_with_name,
        subject: 'Account overdue',
        date: Time.now,
        content_type: "text/html"
      )
    end
  end

  def send_suspend(data)
    init_mailer
    @mail_data = {
      user: data,
      root_url: root_url
    }
    email_with_name = "#{@mail_data[:user].name} <#{@mail_data[:user].email}>"
    mail(
      to: email_with_name,
      subject: 'Account suspend',
      date: Time.now,
      content_type: "text/html"
    )
  end

  private
  def init_mailer
    ActionMailer::Base.postmark_settings = {:api_key => ActiveadminSettings::Setting::value('Postmark API Key', 'en')}
  end
end