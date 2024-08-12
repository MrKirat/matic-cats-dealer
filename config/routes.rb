# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  mount ActionCable.server => '/cable'

  root 'api/v1/cats#index'

  namespace :api do
    namespace :v1 do
      resources :cats, only: %i[index] do
        collection do
          post :search
        end
      end
    end
  end
end
