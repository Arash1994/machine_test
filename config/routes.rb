Rails.application.routes.draw do
  resources :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :api do
  	resources :conversations, only: [:index, :create]do
  		get :message_history
  		post :send_sms
  		get :clear_conversation
  	end
	end
end
