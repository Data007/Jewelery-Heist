require 'spec_helper'

describe 'Migrate Data' do

  it 'migrates users' do
    User.all.count.should == 0
    system 'rake migrate:users'
    User.all.count.should_not == 0
    User.first(conditions: {login: 'm3talsmith'}).should be
  end
end
