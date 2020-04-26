# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  resources :questions do
    resources :answers, shallow: true
  end

  # очень сомневаюсь в правильности маршрута с точки зрения REST, мб стоит добавить /best в конце?
  post 'question/:question_id/:id/best', to: 'answers#best', as: :best_answer

  root to: 'questions#index'
end
