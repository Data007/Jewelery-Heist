require 'spec_helper'

describe User do

  context 'Embedded Properties' do
    before do
      @user = Factory.create :user
    end

    it 'has emails' do
      @user.emails.should_not include('test@example.com')
      @user.emails << 'test@example.com'
      @user.emails.should include('test@example.com')
    end

    it 'has phones' do
      @user.phones.should_not include('2318843024')
      @user.phones << '2318843024'
      @user.phones.should include('2318843024')
    end

    it 'has addresses' do
      address_hash = {
        :address_1   => '1 Easy St.',
        :city        => 'Cadillac',
        :province    => 'MI',
        :postal_code => '49601',
        :country     => 'US'
      }

      @user.addresses.empty?.should be
      @user.addresses.create address_hash
      @user.addresses.where(address_hash).should be
    end
  end
end
