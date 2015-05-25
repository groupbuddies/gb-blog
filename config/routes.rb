GbBlog::Application.routes.draw do


  get '/' => redirect('/blog')

  scope '/blog' do
    root to: "posts#index"

    resources :passwords, controller: 'clearance/passwords', only: [:create, :new]
    resource :session, controller: 'clearance/sessions', only: [:create]

    resources :users, controller: 'clearance/users', only: [:create] do
      resource :password,
        controller: 'clearance/passwords',
        only: [:create, :edit, :update]
    end

    get '/sign_in' => 'clearance/sessions#new', as: 'sign_in'
    delete '/sign_out' => 'clearance/sessions#destroy', as: 'sign_out'
    get '/sign_up' => 'clearance/users#new', as: 'sign_up'

    resources :users, controller: :users, only: [:create]
    resources :posts, only: [:show]

    scope controller: :archive do
      get '/archive' => 'archives#show', as: :archive
      get '/author/:author' => 'archives#show', as: :author
    end

    get '/feed' => 'posts#feed'

    namespace :admin do
      get '/', to: 'application#dashboard', as: :dashboard

      resources :posts, only: [:index, :show, :new, :create, :edit, :update] do
        patch :publish
        patch :unpublish
      end
      resources :post_images, only: [:create]

      get 'me', to: 'users#show', as: :me
      patch 'me', to: 'users#update', as: :update_me
      resources :users, only: [:show, :update]

      post 'saying', to: 'application#create_saying', as: :create_saying
    end

    namespace :api, defaults: { format: :json }, constraints: { format: :json } do
      resources :posts, only: [:create, :update]
    end

    scope controller: :pages do
      get :ui_kit
    end

    mount JasmineRails::Engine => '/specs' if defined?(JasmineRails)
  end
end
