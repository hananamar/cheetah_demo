Rails.application.routes.draw do

  resources :products do
    get 'update_from_csv', on: :collection
  end
end
