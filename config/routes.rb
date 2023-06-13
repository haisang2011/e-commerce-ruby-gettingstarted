Rails.application.routes.draw do
  resources :products do
    get '/', to: 'products#index', as: "getAllProducts"
    post '/', to: 'products#create', as: "createProduct"
    put '/:id', to: 'products#update', as: "updateProduct"
    delete'/:id', to: 'products#destroy', as: "destroyProduct"
  end
  resources :orders do
    get '/', to: 'orders#index', as: "getAllOrders"
    post '/', to: 'orders#create', as: "createOrders"
    put '/:id', to: 'orders#update', as: "updateOrders"
    delete'/:id', to: 'orders#destroy', as: "destroyOrders"
  end
end
