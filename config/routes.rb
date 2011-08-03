Universitas::Application.routes.draw do
  devise_for :users, :controllers => {:registrations => 'registrations'} do
    get 'profile/edit', :to => 'registrations#edit', :as => 'edit_profile'
  end
  resources :users, :only => [:index, :show] do
		resources :documents, :controller => 'user_documents' do
			member do
				post :add
				delete :remove
			end
			collection do
				get :search
			end
		end
    member do
			get :timeline
      post :follow
 			delete :unfollow
    end
  end
  
  resource :dashboard, :only => :show, :controller => 'dashboard' do
    put :update_status, :as => 'update_status'
  end
  
  resources :groups, :except => :destroy do
		resources :documents, :except => [:edit, :show], :controller => 'group_documents' do
			collection do
				post :add_multiple
			end
			member do
				put :accept
			end
		end
		resources :forums do
			resources :topics do
				resources :posts
				collection do
					get :textile
				end
			end
		end
    member do
			get :timeline
      post :join
      delete :leave
			put :update_status
			post :promote
    end
  end

	resources :documents, :only => [:index, :show] do
		member do
			get :download
		end
	end
	
	resources :authentications
		
	resource :home, :only => :show, :controller => 'home'
	resource :about, :only => [:show, :create], :controller => 'about'
  
  get "/track.js" => "home#track"
  get 'textile_guide' => 'posts#textile', :as => 'textile'
	get 'users/:id' => 'users#show', :as => 'profile'
  get ':id' => 'groups#show', :as => 'group'
	put ':id' => 'groups#update', :as => 'group'
	delete 'dashboard/:id/destroy' => 'dashboard#destroy', :as => 'delete_update'
	
	match '/auth/:provider/callback' => 'authentications#create'
	match '/auth/failure' => 'authentications#failure'
  
  root :to => 'home#show'
  
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get :short
  #       post :toggle
  #     end
  #
  #     collection do
  #       get :sold
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get :recent, :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
