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
            ups = UPS.new(test_mode: true, :login => 'wexfordjewelers', :password => 'CROUP59\iota', :key => 'FCA9039C9A358F68')
            response = ups.find_rates(Shipper.wexford_jewelers_address, Shipper.sample_destination, Shipper.sample_packages)
            binding.pry
            response.should be
          end

          it 'gets a fedex rate' do
            fedex = FedEx.new(key: 'kjDtsCxIh2iohD', password: '1garnet', account: '510087925', login: 'wexfordjewelers')
            response = fedex.find_rates(Shipper.wexford_jewelers_address, Shipper.sample_destination, Shipper.sample_packages)
            response.should be
          end
        end
        context 'with a destination address' do
          before do
            @user = FactoryGirl.create :web_user_with_address 
            @address = @user.addresses.first
          end

          it 'gets ups rates' do
            Shipper.get_ups_rate(@address, Shipper.sample_packages)
          end
        end
      end
    end
  end
end
