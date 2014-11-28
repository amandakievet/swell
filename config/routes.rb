Rails.application.routes.draw do
  get 'searches/show'
  root "searches#new" # It is standard to put the 'root' route at the top: it makes it clear where the starting point is.
end
