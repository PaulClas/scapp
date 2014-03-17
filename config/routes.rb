Scapp::Application.routes.draw do
  resources :variable_fields do
    resources :variable_field_measurements, only: [:new, :create]
  end
  post '/variable_fields/add_category', to: 'variable_fields#add_category', as: 'variable_fields_add_new_category'

  resources :variable_field_categories

  resources :variable_field_user_levels

  resources :variable_field_sports

  resources :variable_field_optimal_values

  resources :variable_field_measurements

  resources :user_relations

  resources :organizations

  resources :user_groups

  # static routes
  get '/static/:action', to: 'static#:action'

  root :to => "home#index"

  devise_for :users, :controllers => {:registrations => "registrations"}, skip: [:sessions, :registrations]
  as :user do
    get 'signin' => 'sessions#new', :as => :new_user_session
    post 'signin' => 'sessions#create', :as => :user_session
    delete 'signout' => 'sessions#destroy', :as => :destroy_user_session
    get 'signout' => 'sessions#destroy', :as => :destroy_user_session_get

    get 'signup' => 'registrations#new', :as => :new_user_registration
    post 'signup' => 'registrations#create', :as => :user_registration
    get 'edit_profile' => 'registrations#edit', :as => :edit_user_registration
    get 'cancel_profile' => 'registrations#cancel', :as => :cancel_user_registration
    patch 'edit_profile' => 'registrations#update'
    put 'edit_profile' => 'registrations#update'
    delete 'edit_profile' => 'registrations#destroy'

  end

  resources :users do
    resources :variable_fields, only: [] do
      collection do
        get '/' => 'variable_fields#user_variable_fields'
      end
      member do
        get 'graph' => 'variable_fields#user_variable_graph'
        get 'table' => 'variable_fields#user_variable_table'
        get 'detail' => 'variable_fields#user_variable_field_detail'
        get 'add_measurement' => 'variable_field_measurements#new_for_user'
        post 'add_measurement' => 'variable_field_measurements#create_for_user'
      end
    end

    resources :user_groups, only: [], path: 'groups' do
      collection do
        get '/' => 'user_groups#user_in'
      end
    end

    resources :user_relations, only: [], path: 'relations' do
      collection do
        get '/' => 'user_relations#user_has'
      end
    end

  end
end