LocaleDiff::Engine.routes.draw do
  root to: 'diff#index'
  get '/refresh', to: 'diff#refresh'
  get '/clear_history', to: 'diff#clear_history'
end
