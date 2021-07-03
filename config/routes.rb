Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'lib#index'
  get 'lib' => 'lib#lib'
  get 'contact' => 'lib#contact'

  scope 'lib/' do
    get 'search_name_title' => 'lib#search_name_title'
    get 'search_name_author' => 'lib#search_name_author'
    get 'search_name_title_by_author' => 'lib#search_name_title_by_author'
    get 'search_class' => 'lib#search_class'
    get 'search_text' => 'lib#search_text'
    get 'next_result' => 'lib#next_result'
    get 'previous_result' => 'lib#previous_result'
  end

  scope '/' do
    get 'login' => 'session#login'
    get 'register' => 'session#signup'
  end

  scope 'my_bookshelf/' do
    get 'show' => 'my_bookshelf#show'
    get 'show_next' => 'my_bookshelf#show_next'
    get 'show_previous' => 'my_bookshelf#show_previous'
    get 'new' => 'my_bookshelf#new'
    delete 'delete' => 'my_bookshelf#delete'
  end

  devise_scope :user do
    post 'users/guest_sign_in' => 'users/sessions#guest_sign_in'
  end

end
