ITCasts::Application.routes.draw do
  resources :episodes do
    put "publish", :on => :member
  end


  authenticated :user do
    root :to => 'episodes#index'

    constraint = lambda { |request| request.env["warden"].authenticate? and request.env['warden'].user.admin? }
    constraints constraint do
      require 'sidekiq/web'
      mount Sidekiq::Web, at: '/sidekiq'
    end
  end
  root :to => "episodes#index"
  devise_for :users
  resources :users
end
