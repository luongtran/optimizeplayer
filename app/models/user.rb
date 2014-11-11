class User < ActiveRecord::Base
  belongs_to :account
  has_many :assets
  has_many :videopages
  has_and_belongs_to_many :folders
  has_and_belongs_to_many :notifications
  devise :database_authenticatable, :registerable, :recoverable, :rememberable #, :trackable, :validatable, :confirmable, :lockable

  attr_accessible :name, :email, :password, :password_confirmation, :remember_me, :admin, :folder_ids, :url

  validates :email, uniqueness: true
  validates :url, uniqueness: true, allow_nil: true

  alias_method :db_folders, :folders

  after_create do |user|
    user.security_salt = username + "_" + DateTime.now.to_i.to_s
    unless user.account
      account = Account.create(name: "#{user.name}account")
      user.account_id = account.id
      user.url = SecureRandom.hex(5) if self.url.blank?
      user.owner = true
    end
    user.save!
  end

  def folders
    owner ? account.folders : db_folders
  end

  def username
    name.present? ? name : email
  end

  def embeds_count
    account.projects.count
  end

  def has_account?
    self.account.present?
  end

  def has_csn?
    self.account.present? && self.account.csns.any?
  end

  def is_admin?
    self.admin
  end

  def is_active?
    self.active
  end

  def self.create_team_member(account, email)
    pass = SecureRandom.base64(6)
    member = account.users.create!(email: email, password: pass, password_confirmation: pass)
    InvitationMailer.invitation_message(member, pass).deliver
  end

  def self.send_overdue_notify
    overdue_users = User.where("(overdue_notify > ?) AND (suspend IS ? OR suspend = ?)", 0, nil, false)
    unless overdue_users.blank?
      overdue_users.each do |overdue_user|
        if overdue_user.suspend.blank?
          if overdue_user.overdue_notify.blank?
            overdue_user.overdue_notify = 0
          else
            overdue_user.overdue_notify += 1
          end
          overdue_user.save
          BillingMailer.send_overdue_notify(overdue_user).deliver
          if overdue_user.overdue_notify == 8 and overdue_user.suspend.blank?
            overdue_user.suspend = 1
            overdue_user.save
            BillingMailer.send_suspend(overdue_user).deliver
          end
        end
      end
    end
  end
end