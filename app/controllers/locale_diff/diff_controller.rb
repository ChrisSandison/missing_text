require_dependency "locale_diff/application_controller"

module LocaleDiff
  class DiffController < ApplicationController
    require 'locale_diff/runner'

    def index
      Runner.run!
    end
    
  end
end
