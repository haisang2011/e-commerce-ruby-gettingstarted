Rails.application.routes.draw do
  resources :products do
    get '/', to: 'products#index', as: "get_all_products"
    get '/detail/:id', to: 'products#show', as: "get_detail_products"
    post '/', to: 'products#create', as: "create_product"
    put '/:id', to: 'products#update', as: "update_product"
    delete'/:id', to: 'products#destroy', as: "destroy_product"
  end
  resources :orders do
    get '/', to: 'orders#index', as: "get_show"
    # post '/', to: 'orders#create', as: "createOrders"
    post '/', to: 'orders#create', as: "create_orders"
  end
  resources :order_details do
    get '/', to: 'order_details#index'
    get '/:code', to: 'order_details#show'
    post '/', to: 'order_details#create'
  end
  resources :users
  post '/auth/login', to: 'authentication#login'
  post '/auth/logout', to: 'authentication#logout'
  post '/auth/register', to: 'authentication#register'
  put '/auth/update_profile', to: 'authentication#update_profile'

  resources :carts do
    get 'get_cart', on: :collection, to: 'carts#show'
    post 'add_to_cart', on: :collection, to: 'carts#add_to_cart'
    delete 'remove_product', on: :collection, to: 'carts#destroy'
    delete 'clear_cart', on: :collection, to: 'carts#clear_cart'
  end
end

