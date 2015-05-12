require_dependency "locale_diff/application_controller"

module LocaleDiff
  class DiffController < ApplicationController
    require 'locale_diff/runner'

    # TODO only load this page in development/with user login

    # TODO: Have INDEX check if a record is loaded. If it is, display it along with a button to refresh the diffs. Otherwise, indicate that there is no diff on record and advise the user to click the button

    def index

      binding.pry
      if params[:id].present?
        @batch = LocaleDiff::Batch.find_by_id(params[:id])
      else
        @batch = LocaleDiff::Batch.last
      end

      # TODO: flash error if can not find batch, use batch.last otherwise
      @records = LocaleDiff::Record.where(locale_diff_batch_id: @batch.id)
      @entries = LocaleDiff::Entry.where("locale_diff_records_id in (?)", @records.pluck(:id))
    end

    def refresh
      Runner.run
    end

    def clear_history
      # TODO
    end
    
  end
end
