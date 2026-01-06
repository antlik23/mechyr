# frozen_string_literal: true

Rails.application.routes.draw do
  unless Rails.env.production?
    mount Rswag::Ui::Engine => '/api-docs'
    mount Rswag::Api::Engine => '/api-docs'
  end
  get '/404' => 'errors#not_found'
  get '/500' => 'errors#exception'
  devise_for :users, defaults: { format: :json }, path: 'api/v1',
                     controllers: {
                       invitations: 'api/v1/invitations',
                       confirmations: 'api/v1/confirmations'
                     }

  namespace :api do
    namespace :v1 do
      get 'export', to: 'exports#export', as: 'export' # More generic route
      devise_scope :user do
        post 'resend_invitation', to: 'invitations#resend_invitation'
        namespace :users do
          post 'password_forgot', to: 'passwords#forgot'
          post 'password_reset', to: 'passwords#reset'
        end
        resource :login, only: :create
        resource :logout, only: :create
        resource :signup, only: :create
        resource :refresh, only: :create
      end
      post 'resend_confirmation', to: 'confirmations#resend_confirmation'
      resources :patients, only: %i[index] do
        collection do
          put 'request_assignment', to: 'patients#request_assignment'
          put 'approve/:patient_id', to: 'patients#approve'
          put 'reject/:patient_id', to: 'patients#reject'
          get 'list_to_be_approved', to: 'patients#list_to_be_approved'
        end
      end
      get 'doctors/available_doctors', to: 'doctors#available_doctors'
      put 'doctors/update_full_capacity', to: 'doctors#update_full_capacity'
      resources :entry_forms
      resources :oab_forms
      resources :iciq_forms
      resources :ipss_forms
      resources :anamnestic_forms
      resources :voiding_diaries do
        collection do
          get 'latest_diary', to: 'voiding_diaries#latest_diary'
        end
        resources :voiding_records
      end
      resources :appointment_seconds
      resources :appointment_firsts
      resources :appointment_initials
      resources :jobs, only: %i[show create update destroy index] do
        resource :copy, controller: :job_copies, only: :create
        member do
          put 'upload_signature', to: 'jobs#upload_signature'
        end
      end
      namespace :addresses do
        resources :autocompletes, only: :index
      end
      resources :addresses, only: %i[show create update destroy index]
      resources :users, only: %i[show create update destroy index] do
        collection do
          resources :team_members, only: %i[destroy index]
          get 'find_by_token/:invitation_token', to: 'users#find_by_token', as: 'find_by_token'
          get ':id/forms', to: 'users#forms', as: 'forms'
          get ':id/diaries', to: 'users#diaries', as: 'diaries'
        end
      end
      namespace :admin do
        resources :jobs, only: :index
      end
    end
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?

  match '*unmatched', to: 'application#route_not_found', via: :all, constraints: lambda { |req|
    req.path.exclude? 'rails/active_storage'
  } unless Rails.env.development?
end
