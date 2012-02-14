DragonHoard::Application.routes.draw do
  
  scope constraints: {protocol: Rails.env.production? ? 'https' : 'http'} do
    namespace :admin do
      match 'inventory' => 'inventory#index'
      
      resources :users do
        
        collection do
          get  :login
          post :authenticate
          get  :logout
          get  :forgot
          get  :search
        end

        resources :addresses, controller: 'users/addresses'
        resources :phones,    controller: 'users/phones'
        resources :emails,    controller: 'users/emails'
        
        resources :orders,  controller: 'users/orders' do
          member do
            get :refund
            get :cancel
            get :print
          end

          resources :line_items, controller: 'users/orders/line_items' do
            member do
              delete :refund
            end
          end

          resources :payments,   controller: 'users/orders/payments' do
            member do
              delete :refund
            end
          end
          
          resources :tickets, controller: 'users/orders/tickets'
        end

        resources :tickets, controller: 'tickets'
        
      end
      
      resources :customers do
        collection do
          get :search
        end
      end
      
      resources :orders do
        
        collection do
          get :find
        end
        
        member do
          put  :info
          post :info
          get  :cancel
          get  :refund
          put  :lookup
          post :lookup
          put  :force_lookup
          post :force_lookup
          put  :address
          post :address
          get  :print
        end
        
        resources :line_items, controller: 'orders/line_items', action: 'index', conditions: {method: :put}
        resources :line_items, controller: 'orders/line_items', action: 'index', conditions: {method: :get}
        resources :line_items, except: [:index], controller: 'orders/line_items'
        
        match 'payments' => 'orders/payments#index', conditions: {method: [:put, :get]}, as: :payments
        resources :payments, except: [:index], controller: 'orders/payments'
        resources :tickets, controller: 'tickets'
      end
      
      resources :tickets do
        collection do
          get :find
        end
        
        member do
          get :accept
          get :advance
        end
        
      end
      
      match 'search' => 'searches#general', as: :search
      match 'search/users' => 'searches#users', as: :search_users
    
      resources :customers
      resources :faqs, except: [:new, :create, :destroy]
      
      resources :molds do
        member do
          get :cancel
        end
        resources :attachments, controller: 'molds/attachments'
        match '/molds/:mold_id/attachments/update_positions/:id' => 'molds/attachments#update_positions', as: :mold_asset_update_position
      end
      
      resources :collections

      resources :items do
        collection do
          get :current
          get :old
          get :instore
          get :published
          get :ooak
          get :find
        end
        
        member do
          get :cancel
          get :remove
          get :restore
          get :clone
        end

        resources :assets, controller: 'items/assets' do
          member do
            get :update_position
          end
        end
        
        resources :variations, controller: 'items/variations' do
          member do
            get :cancel
          end
          resources :attachments, controller: 'items/variations/attachments' do
            member do
              get :update_position
            end
          end
        end
      end
        
      match 'items/:item_id/variations/:variation_id/attachments/update_positions/:id' => 'items/variations/attachments#update_positions', as: :item_variation_asset_update_position
      
      match 'live_searches/metals/:id' => 'live_searches#metals', as: :metals
      match 'live_searches/jewels/:id' => 'live_searches#jewels', as: :jewels
      match 'live_searches/finishes/:id' => 'live_searches#finishes', as: :finishes
      match 'live_searches/:id' => 'live_searches#items', as: :full_search
      
      namespace :reports do
        namespace :items do
          resources :items, collection: {current: :get}
        end
      end
      
    end
    
    match 'admin' => 'admin/users#dashboard', as: :admin_root

    resources :items
    resources :collections, only: [:index, :show]
    
    resources :users do
      collection do
        get  :login
        get  :logout
        post :authenticate
        get  :register
        post :registered
        get  :forgot_password
        post :generate_new_password
      end
      
      member do
        get :dashboard
      end
    end
      
    match '/users/fb_authenticate/:uid' => 'users#fb_authenticate', as: :fb_authenticate
    match 'dashboard' => 'users#dashboard', as: :dashboard
    
    match '/orders/:id/checkout' => 'orders#checkout', method: :post, as: :checkout
    match '/orders/:id/shipping' => 'orders#shipping', method: :post, as: :shipping
    match '/orders/:id/addressed' => 'orders#addressed', method: :post, as: :addressed
    match '/orders/:id/pay' => 'orders#pay', method: :post, as: :pay
    match '/orders/:id/complete' => 'orders#complete', method: :post, as: :complete
    
    resources :orders do
      member do
        get :clear
      end
      
      resources :items, controller: 'orders/items' do
        member do
          get :destroy, as: :delete
        end
      end
    end
    
    match '/policy/delivery' => 'policies#delivery', as: :delivery
    match '/policy/privacy'  => 'policies#privacy',  as: :privacy
    match '/policy/return'   => 'policies#return',   as: :return
    match '/policy/faq'      => 'policies#faq',      as: :faq
    
    match 'about-us' => 'pages#about', as: :about_us
    match 'pages/bad_route' => 'pages#bad_route', as: :bad_route
    
    resource :search, only: [:show]
    resources :colors, only: [:show]
    
    match '/login' => 'users#login', as: :login
    match '/logout' => 'users#logout', as: :logout
    
    root :to => 'pages#home'
  
  end

end
