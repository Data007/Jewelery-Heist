require 'spec_helper'

describe Shipper do
  use_vcr_cassette

  context 'with a shipper' do
    before do
      @user = FactoryGirl.create :web_user_with_address
    end

    it 'creates default packages' do
      Shipper.sample_packages.should be
    end

    context 'with a package' do
      context 'with an origin' do
        context 'with a location' do
          it 'gets a UPS rate' do
            ups = UPS.new(:login => 'auntjudy', :password => 'secret', :key => 'xml-access-key')
            response = ups.find_rates(Shipper.sample_origin, Shipper.sample_destination, Shipper.sample_packages)
            response.should be
          end
        end
      end
    end
  end
end
