class Ability
  include CanCan::Ability

  def initialize(user, request)

    # disable all
    cannot :manage, :all


    @user = user || User.new # for guest
    @request ||= request

    # set not role based permissions
    role_independent

    # set role based permissions
    @user.roles.each do |role|
      send role.name if ['player', 'coach', 'admin'].include? role.name
    end

    if @user.roles.size == 0
      # =======================================
      # GUEST PERMISSIONS
      # =======================================
      can [:new, :create], RegistrationsController
    end

  end

  # ===========================================
  # ROLE INDEPENDENT PERMISSIONS
  #
  # This is used for permissions which directly
  # don't rely on user role.
  #
  # ===========================================
  def role_independent
    # =============
    # VariableField
    #==============

    # @4.3 - can only view own VF page
    can [:user_variable_fields], VariableFieldsController if @request.params[:user_id] == @user.slug

    # can manage only own VF - @4.2, @4.7, @4.8, @4.9, @4.10
    can [:show, :edit, :update, :delete], VariableField do |vf|
      vf.user_id ==  @user.id
    end

  end

  # ===========================================
  # PLAYER PERMISSIONS
  # ===========================================
  def player
    can [:index], HomeController
    # =============
    # VariableField
    # =============

    # @4.1, @4.2, @4.5 - must be controlled in controller, @4.6
    can [:index, :new, :create, :show], VariableField

    # =============
    # VariableFieldMeasurement
    # =============
    can [:index], VariableFieldMeasurement

    # @5.1 - TODO restrict only to actions not by required params
    if @request.params[:controller] == 'variable_field_measurements' &&
        ['new_for_user', 'create_for_user'].include?(@request.params[:action]) && @request.params[:id] && @request.params[:user_id]
      vf = VariableField.find(@request.params[:id])
      user = User.friendly.find(@request.params[:user_id])
      # user must be owner or field global and add measurement for myself or has coach relation to player
      if (vf.user == @user || vf.is_global? ) && (user == @user || @user.in_relation?(user, :coach))
        can [:new_for_user, :create_for_user], VariableFieldMeasurement
      end
    end

    # @5.1 - add only to myself
    if @request.params[:controller] == 'variable_field_measurements' && ['new', 'create'].include?(@request.params[:action])
      vf_id = @request.params[:variable_field_id]
      vf_id ||= @request.params[:variable_field_measurement][:variable_field_id] if @request.params[:variable_field_measurement]
      vf_id ||= @request.params[:id]
      vf = VariableField.find(vf_id)
      can [:new, :create], VariableFieldMeasurement if vf.is_global? || vf.user == @user
    end

    # @5.4
    can [:show], VariableFieldMeasurement do |vfm|
      vfm.measured_by = @user || @user.in_relation?(vfm.measured_for, :coach)
    end

    # @5.2
    can [:edit, :update, :destroy], VariableFieldMeasurement do |vfm|
      vfm.measured_by == @user
    end

    # =============
    # User
    # =============
    # @1.8
    can [:index], User

    #  @1.4
    can [:edit, :update], User do |user|
      user.id == @user.id
    end

    # @1.3
    can [:show], User do |user|
      (user.id == @user.id) || @user.in_relation?(user, :friend) || @user.in_relation?(user, :coach) || @user.in_relation?(user, :watcher)
    end

    # =============
    # UserRelations
    # =============
    # @3.1
    if @request.params[:controller] == 'user_relations' && @request.params[:action] == 'user_has'
      for_user = User.friendly.find(@request.params[:user_id])
      if for_user == @user || @user.in_relation?(for_user, :watcher) || @user.in_relation?(for_user, :friend) || @user.in_relation?(for_user, :coach)
        can :user_has, UserRelation
      end
    end

    # @3.3
    can [:new_request, :create_request], UserRelation

    # @3.4
    can [:change_status], UserRelation do |r|
      r.from == @user || r.to == @user
    end

    # =============
    # UserGroups
    # =============
    # @2.1
    can [:index], UserGroup

    # @2.2
    can [:show], UserGroup do |g|
      g.owner == @user || ['registered', 'public'].include?(g.visibility) || ( g.visibility == 'members' && g.user_is_in?(@user) )
    end

    # @2.3
    if @request.params[:controller] == 'user_groups' && @request.params[:action] == 'user_in'
      for_user = User.friendly.find(@request.params[:user_id])
      if for_user == @user || @user.in_relation?(for_user, :coach) || @user.in_relation?(for_user, :watcher)
        can [:user_in], UserGroup
      end
    end

    # @2.5, @2.6, @2.8
    can [:edit, :update, :destroy, :remove_user], UserGroup, user_id: @user.id

    # @2.7
    can [:add_user], UserGroup do |g|
      user_to_add = User.where(email: @request.params[:user_group_user][:email]).first

      g.owner == @user && ( @user.in_relation?(user_to_add, :friend) || @user.in_relation?(user_to_add, :coach) ||
                            @user.in_relation?(user_to_add, :watcher) )
    end

    # =============
    # RegularTraining
    # =============
    # @7.1
    can [:index], RegularTraining

    # @7.2
    can [:show], RegularTraining do |t|
      c = false
      # basic permissions check
      c = true if t.public? || t.user == @user || t.user_group.user_is_in?(@user)

      # TODO permit access for coaches
      # chceck for existing relation to training group members
      unless c
        t.user_group.users.each do |u|
          if @user.in_relation?(u, :watcher) || @user.in_relation?(u, :coach)
            c = true
            break
          end
        end
      end

      c
    end

  end

  # ===========================================
  # COACH PERMISSIONS
  #
  # Inherits all permissions from player
  # Add or modify inherited permissions
  #
  # ===========================================
  def coach
    # INHERIT from :player
    player() unless @user.has_role? :player

    # =============
    # VariableField
    # =============
    # can only VF page of users connected to him
    if @request.params.has_key?(:user_id) &&
        ((@request.params[:user_id] == @user.slug) || @user.in_relation?(User.friendly.find(@request.params[:user_id]), 'coach'))
      can [:user_variable_fields], VariableFieldsController
    end

    # =============
    # VariableFieldMeasurement
    # =============

    # @5.1
    if @request.params[:controller] == 'variable_field_measurements' && ['new', 'create'].include?(@request.params[:action])
      vf_id = @request.params[:variable_field_id]
      vf_id ||= @request.params[:variable_field_measurement][:variable_field_id] if @request.params[:variable_field_measurement]
      vf_id ||= @request.params[:id]
      vf = VariableField.find(vf_id)

      can [:new, :create], VariableFieldMeasurement if @user.in_relation?(vf.user, :coach)
    end

    # =============
    # User
    # =============
    can [:index], User

    # =============
    # UserGroups
    # =============
    # @2.4
    can [:new, :create], UserGroup

    # =============
    # RegularTraining
    # =============
    # @7.4
    can [:new, :create], RegularTraining
    # @7.5, @7.6
    can [:edit, :update, :destroy], RegularTraining do |rt|
      rt.user == @user
    end
  end

  # ===========================================
  # ADMIN PERMISSIONS
  #
  # Inherits all permissions from coach
  # Add or modify inherited permissions
  #
  # ===========================================
  def admin
    # INHERIT from :coach
    coach() unless @user.has_role? :coach


    can :manage, :all

    # =============
    # VariableField
    # =============

    # @4.2
    can :show, VariableField

    # =============
    # User
    # =============
    # no additional permission

  end

    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user permission to do.
    # If you pass :manage it will apply to every action. Other common actions here are
    # :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. If you pass
    # :all it will apply to every resource. Otherwise pass a Ruby class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details: https://github.com/ryanb/cancan/wiki/Defining-Abilities
end
