Universitas::Application.routes.draw do
  devise_for :users, :controllers => {:registrations => 'registrations'} do
    get 'profile/edit', :to => 'registrations#edit', :as => 'edit_profile'
  end

  resources :users, :only => [:index, :show] do
		resources :documents, :controller => 'user_documents', :except => [:new, :create, :destroy] do
			member do
				post :add
				delete :remove
			end
		end
    member do
      post :follow
 			delete :unfollow
    end
  end
  
  resources :groups, :except => :destroy do
		resources :documents, :only => [:index, :destroy], :controller => 'group_documents' do
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
      post :join
      delete :leave
			put :update_status
			post :promote
    end
  end

	resources :documents, :only => [:index, :show, :create, :new] do
		member do
			get :download
			get :view
		end
	end
	
	resources :updates, :except => [:update]
	
	resources :authentications
	
	resources :comments
		
	resource :home, :only => :show, :controller => 'home'
	resource :about, :only => [:show, :create], :controller => 'about'
  
  get 'textile_guide' => 'posts#textile', :as => 'textile'
	get 'users/:id' => 'users#show', :as => 'profile'
  get ':id' => 'groups#show', :as => 'group'
	put ':id' => 'groups#update', :as => 'group'
	
	match '/auth/:provider/callback' => 'authentications#create'
	match '/auth/failure' => 'authentications#failure'
  
  root :to => 'home#show'
end
