require 'spec_helper'
require 'rake'

describe 'Phone as String saved as an Object' do
  before do
    @user = FactoryGirl.create :phone_migration_user
    @user.set(:phones, ['1234567890', '2319205678'])
    @user.reload
  end

  context 'with a User' do
    it 'moves a phone string into a String Object' do
      execute_rake('phone.rake','phone_string_to_object')
    end
  end
end
