Rails.application.routes.draw do

  mount LocaleDiff::Engine => "/missing_text"
end
