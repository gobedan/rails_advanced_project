# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  resources :questions do
    resources :answers, shallow: true
  end

  post 'question/:id/:answer_id', to: 'questions#assign_best'

  root to: 'questions#index'
end
