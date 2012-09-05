require 'spec_helper'

describe 'Dashboard' do
  
  before do
    @user = User.first
  end

  it 'clicks the navigation links' do
    visit url_for [@user, :dashboard]
    current_url.should == url_for([@user, :dashboard])
  end

end
