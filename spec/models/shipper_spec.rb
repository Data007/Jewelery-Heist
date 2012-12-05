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
            response.should be
          end

          it 'gets a fedex rate' do
            fedex = FedEx.new(key: 'wikjDtsCxIh2iohD', password: 'Cw10xEFUV6f0kmz861HJdf8NQ', account: '510087925', login: '118569532', test: true)
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
