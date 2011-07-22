require 'spec_helper'


describe 'Orders' do

  before do
    @admin = Factory.create :admin

    @customer = Factory.create :customer, phones: ['231-884-3024'], emails: ['customer_1@example.net']
    @customer.addresses.create!({
      address_1:   '1 CIRCULAR DR',
      city:        'LOGIC',
      province:    'MI',
      postal_code: '49601'
    })

    visit admin_user_path(@customer)
  end

  it 'creates an order'
  it 'shows an order'
  
  context 'items' do

    before do
      # create an item
      # create an order
    end

    it 'adds a quick item'
    it 'adds a stock item'

  end

  context 'payments' do

    before do
      # create an item
      # create an order
    end

    it 'adds a partial payment'
    it 'adds a full payment'
    it 'applies in store credit'
    it 'pays off an order'
  
  end

  context 'print'
  context 'ticket'

end
