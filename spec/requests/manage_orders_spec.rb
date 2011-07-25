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

    login_admin(@admin, 'password')
    visit admin_user_path(@customer)

    current_path.should == admin_user_path(@customer.id)
  end

  it 'creates an order' do
    click_link 'In Store Purchase'

    @customer.reload
    @order = @customer.orders.last
    
    current_path.should == admin_user_order_path(@customer.id, @order.id)
    page.should have_content('Line Items')
    page.should have_content('Payments')
    page.should have_content("Instore Purchase ##{@order.id}")

    click_button 'save line items'
    current_path.should == admin_user_order_path(@customer.id, @order.id)
  end

  it 'shows an order'
  
  context 'items', js: true do

    before do
      @item  = Factory.create(:item, variations: [Factory.create(:variation)])
      @order = @customer.orders.create
    end

    it 'adds a quick item' do
      visit admin_user_order_path(@customer.id, @order.id)

      click_on 'add a quick line item'
      fill_in  'Name', with: 'test quick item'
      fill_in  'Price', with: '30.00'
      uncheck  'Taxable?'
      click_on 'add new line item'

      current_path.should == admin_user_order_path(@customer.id, @order.id)
      page.should have_content('test quick item')

      @customer.reload
      @order     = @customer.orders.find(@order.id)
      @line_item = @order.line_items.first
      
      @line_item.should              be
      @line_item.price.should        == 30.00
      @line_item.taxable?.should_not be
    end

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
