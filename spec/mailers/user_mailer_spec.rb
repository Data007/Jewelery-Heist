require "spec_helper"

describe UserMailer do
  describe "forgot_password" do
    let(:mail) { UserMailer.forgot_password }

    it "renders the headers" do
      mail.subject.should eq("Forgot password")
      mail.to.should eq(["to@example.org"])
      mail.from.should eq(["from@example.com"])
    end

    it "renders the body" do
      mail.body.encoded.should match("Hi")
    end
  end

  describe "order_completed" do
    let(:mail) { UserMailer.order_completed }

    it "renders the headers" do
      mail.subject.should eq("Order completed")
      mail.to.should eq(["to@example.org"])
      mail.from.should eq(["from@example.com"])
    end

    it "renders the body" do
      mail.body.encoded.should match("Hi")
    end
  end

end
