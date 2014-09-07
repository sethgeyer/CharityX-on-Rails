Rails.application.routes.draw do

  root 'sessions#index'
  delete "/logout", to: "sessions#destroy", as: "logout"
  post "/login", to: "sessions#create", as: "login"

  resources :users do

  end


  resource :user do
    resource :profile, :only => [:edit, :update]
    resource :dashboard, :only => [:show]
    resources :deposits, :only => [:index, :new, :create]
    resources :distributions, :only => [:index, :new, :create]
    resources :wagers


  end


  resources :wager_view_preferences

  resources :mvps

  resources :charities

  resources :password_resets

  # get "/reset_password/:uid", to: "password_resets#edit"










  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
