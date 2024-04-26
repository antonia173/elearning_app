Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root 'welcome#index'

  devise_for :users

  get 'quiz_submissions/create'
  get 'quiz_submissions/show'

  resources :quizzes do
    resources :questions
    resources :quiz_submissions, only: [:show, :create], as: 'submissions'
  end
  
  get 'welcome#index', to: 'welcome#index'
end
