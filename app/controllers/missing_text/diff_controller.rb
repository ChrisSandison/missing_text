require_dependency "missing_text/application_controller"
require_dependency "missing_text/runner"

module MissingText
  class DiffController < ApplicationController

    def index

      # if no batch is specified, just load the last batch
      # this will ensure that we don't get any nil errors
      @batch = MissingText::Batch.try(:find_by_id, params[:id])

      unless @batch.present?
        @batch = MissingText::Batch.last
      end

      # only load the diff information if a batch is found
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
      MissingText::Batch.delete_all
      MissingText::Record.delete_all
      MissingText::Entry.delete_all
      MissingText::Warning.delete_all
      redirect_to root_path
    end
    
  end
end
