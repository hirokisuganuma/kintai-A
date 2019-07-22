Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'application#top'
  get  '/top/:id',   to: 'application#top',as: :top
  #session resource
  get  '/signup',   to: 'users#new'
  get  '/index/:id',   to: 'users#index', as: :user_index
  get    '/login',  to: 'sessions#new'
  post   '/login',  to: 'sessions#create'
  delete 'logout'  => 'sessions#destroy'
  delete '/logout', to: 'sessions#destroy'
  
  #user resource
  get    'users/:id/edit_basic_info',to:'users#edit_basic_info',as:'edit_basic_info'
  patch  'users/:id/update_basic_info' , to: 'users#update_basic_info',as:'update_basic_info'
  get    '/users/working_users', to: 'users#working_users',as:'users_working_users'
  resources :users do
    resources :works, only: :create
  end
  
  #work_edit resource
  get 'users/:id/works/:date/edit', to: 'works#edit', as: :edit_works
  patch 'users/:id/works/:date/update', to: 'works#update', as: :update_works
  
  #base_resource
  resources :bases do
    collection do
      get  'base_edit'
      post 'base_add'
      patch 'base_update'
      delete 'base_delete'
      get 'base_edit_modal'
    end
  end
  
end
