class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    alias_action :update, :destroy, :to => :modify
    if user.has_any_role?(:admin)
      can :manage, User
      can [:create, :read], Episode
      can :modify, Episode, :published => false
      can :publish, Episode, :published => false, :transcoded => false
    elsif user.has_any_role?(:speaker)
      can :create, Episode
      can :modify, Episode, :published => false, :created_by_id => user.id
      can :publish, Episode, :published => false, :transcoded => false, :created_by_id => user.id
      can :read, Episode, :created_by_id => user.id
      cannot :read, Episode, :published => true, :transcoded => false
    end
    can :read, Episode, :published => true, :transcoded => true

    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user 
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. 
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
end
