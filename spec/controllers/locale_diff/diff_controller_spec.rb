require 'rails_helper'

module LocaleDiff
  RSpec.describe DiffController, type: :controller do

    describe "GET #index" do
      it "returns http success" do
        get :index
        expect(response).to have_http_status(:success)
      end
    end

  end
end
