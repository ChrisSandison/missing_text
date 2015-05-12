require_dependency "locale_diff/application_controller"
require_dependency "locale_diff/runner"

module LocaleDiff
  class DiffController < ApplicationController

    # TODO only load this page in development/with user login
    def index

      @batch = LocaleDiff::Batch.try(:find_by_id, params[:id])

      unless @batch.present?
        @batch = LocaleDiff::Batch.last
      end

      if @batch.present?
        @records = LocaleDiff::Record.where(locale_diff_batch_id: @batch.id)
        @entries = LocaleDiff::Entry.where("locale_diff_records_id in (?)", @records.pluck(:id))
      end
    end

    def rerun
      LocaleDiff::Runner.run
      redirect_to root_path
    end

    def clear_history
      LocaleDiff::Batch.destroy_all
      LocaleDiff::Record.destroy_all
      LocaleDiff::Entry.destroy_all
      redirect_to root_path
    end
    
  end
end
