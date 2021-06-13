Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get 'aozora_lib' => 'lib#index'
  get 'aozora_lib/lib' => 'lib#lib'
  get 'aozora_lib/contact' => 'lib#contact'
end
