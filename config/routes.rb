# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'questions#index'
  devise_for :users

  resources :questions do
    resources :answers, shallow: true
  end
  
  resources :attachments, only: :destroy
  post 'question/:question_id/:id/best', to: 'answers#best', as: :best_answer
end
