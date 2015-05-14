MissingText::Engine.routes.draw do
  root to: 'diff#index'
  get '/rerun', to: 'diff#rerun'
  get '/clear_history', to: 'diff#clear_history'
  get '/:id', to: 'diff#index'
end
