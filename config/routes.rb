Rails.application.routes.draw do
  get 'searches/show'
  root "searches#new"
end
