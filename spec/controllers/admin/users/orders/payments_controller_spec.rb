require 'spec_helper'

describe Admin::Users::Orders::PaymentsController do

  describe "GET 'new'" do
    it "should be successful" do
      get 'new'
      response.should be_success
    end
  end

end
