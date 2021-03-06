Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'carts#index'
  # get '/carts/:id' => 'carts#index'
  get '/carts/cart/:id' => 'carts#cart', as: 'cart'
  get '/carts/new' => 'carts#new', as: 'new_cart'
  get 'carts/edit/:id' => 'carts#edit', as: 'edit_cart'
  post 'carts/new' => 'carts#create', as: 'create_cart'
  post 'carts/update/:id' => 'carts#update', as: 'submit_update'
  post '/carts/cart/:cart_id/review/:id' => 'carts#add_review', as: 'add_cart_review'
  put '/carts/cart/:cart_id/review/:id' => 'carts#edit_review', as: 'edit_cart_review'
  delete '/carts/cart/:cart_id/review/:id' => 'carts#delete_review', as: 'delete_cart_review'
  post '/setusername' => 'carts#setusername', as: 'setusername'
  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  #resources :movies

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
