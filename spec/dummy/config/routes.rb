Rails.application.routes.draw do

  mount LocaleDiff::Engine => "/locale_diff"
end
