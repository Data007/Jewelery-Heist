require 'spec_helper'
require 'digest/sha2'

describe User do
  
  context 'Validation' do

    before do
      @user = Factory.build :user
    end

    it 'validates presence of name' do
      @user.errors.should_not include(:name)
      @user.name = nil
      @user.save
      @user.errors.should     include(:name)
    end

  end

  context 'Contact Information' do

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

  context '#hash_password' do
    
    it 'hashes password' do
      User.hash_password('password').should == Digest::SHA256.hexdigest('password')
    end

    it 'hashes password on save' do
      user = Factory.build :user
      user.password_hash.should_not be
      user.save
      user.reload.password_hash.should == User.hash_password('password')
    end

    it 'does not hash on save with a bad password confirmation match' do
      user = Factory.build :user, :password_confirmation => 'passwor'
      user.errors.should_not include(:password_confirmation)
      user.save
      user.errors.should     include(:password_confirmation)
      user.reload.password_hash.should_not == User.hash_password('password')
    end

  end

  context '#authorize' do

    before do
      @user = Factory.create :user, is_active: true
    end

    it 'is not active' do
      @user.update_attribute :is_active, false
      User.authorize(@user.login, @user.password).should_not be
    end

    it 'is active' do
      User.authorize(@user.login, @user.password).should be
    end

    it 'is_admin' do
      @user.is_admin?.should_not be
      @user.role = 'admin'
      @user.is_admin?.should be
    end

  end

  context '#full_search' do

    before do
      3.times {|i| Factory.create :customer, login: "customer_#{i}", name: "Customer User #{i}"}
    end

    it 'finds users by any_of' do
      User.count.should == 3
      User.any_of(login: 'customer_1').length.should == 1
    end

    it 'finds users by login' do
      User.full_search({login: 'customer_1'}).length.should == 1
    end

    it 'finds users by login or name' do
      users = User.full_search({login: 'customer_1', name: 'Customer User 2'})
      users.length.should == 2
      users.should include(User.first(conditions: {login: 'customer_1'}))
      users.should include(User.first(conditions: {login: 'customer_2'}))
    end

    it 'finds users by phone'
    it 'finds users by email'
    it 'finds users by address'

  end

end
