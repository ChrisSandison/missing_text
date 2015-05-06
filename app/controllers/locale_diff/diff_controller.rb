require_dependency "locale_diff/application_controller"

module LocaleDiff
  class DiffController < ApplicationController
    require 'locale_diff/runner'

    # TODO only load this page in development/with user login

    # TODO: Have INDEX check if a record is loaded. If it is, display it along with a button to refresh the diffs. Otherwise, indicate that there is no diff on record and advise the user to click the button

    def index
      Runner.run
    end
    
  end
end
