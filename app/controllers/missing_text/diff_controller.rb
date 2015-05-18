require_dependency "missing_text/application_controller"
require_dependency "missing_text/runner"

module MissingText
  class DiffController < ApplicationController

    # TODO only load this page in development/with user login
    def index

      @batch = MissingText::Batch.try(:find_by_id, params[:id])

      unless @batch.present?
        @batch = MissingText::Batch.last
      end

      if @batch.present?
        @records = MissingText::Record.where(missing_text_batch_id: @batch.id)
        @entries = MissingText::Entry.where("missing_text_records_id in (?)", @records.pluck(:id))
        @warnings = MissingText::Warning.where(missing_text_batch_id: @batch.id)
      end
    end

    def rerun
      MissingText::Runner.run
      redirect_to root_path
    end

    def clear_history
      MissingText::Batch.destroy_all
      MissingText::Record.destroy_all
      MissingText::Entry.destroy_all
      MissingText::Warning.destroy_all
      redirect_to root_path
    end
    
  end
end
