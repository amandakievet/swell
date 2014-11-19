Rails.application.routes.draw do
  post 'searches/create'
  get 'searches/show'
  root "searches#new"
end
