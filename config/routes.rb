Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get 'aozora_lib' => 'lib#index'
  get 'aozora_lib/lib' => 'lib#lib'
  get 'aozora_lib/contact' => 'lib#contact'

  scope 'aozora_lib/lib/' do
    get 'search_name_title' => 'lib#search_name_title'
    get 'search_name_author' => 'lib#search_name_author'
    get 'search_name_title_by_author' => 'lib#search_name_title_by_author'
    get 'search_class' => 'lib#search_class'
    get 'next_result' => 'lib#next_result'
    get 'previous_result' => 'lib#previous_result'
  end
end
