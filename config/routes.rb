# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  resources :questions do
    resources :answers, shallow: true
  end

  # очень сомневаюсь в правильности маршрута с точки зрения REST, мб стоит добавить /best в конце?
  post 'question/:id/:answer_id', to: 'questions#toggle_best_answer', as: :toggle_best_answer

  root to: 'questions#index'
end
