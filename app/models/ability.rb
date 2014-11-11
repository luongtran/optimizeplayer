class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    account = user.account

    if account.users.count < account.plan.number_of_users || account.plan.number_of_users == -1
      can :invite, User
    end

    if account.plan.can_add_cta
      can :add_cta, Project
    end

    can :manage, Project do |p|
      user.folders.include? p.folder
    end

    if account.number_of_jobs < account.plan.number_of_jobs || account.plan.number_of_jobs == -1
      can :encode, Asset
    end

    can :destroy, User do |u|
      user.owner && account.users.include?(u) && u != user
    end

    can :access, Folder do |f|
      user.owner || user.folders.include?(f)
    end
  end
end
