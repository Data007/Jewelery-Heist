require 'spec_helper'

describe Item do

  context '#search' do
    
    before do
      @item_1 = Factory.create :item, name: 'Test Item 1'
      @item_2 = Factory.create :item, name: 'Test Item 2'
    end

    it 'finds one by ID + old_id'
    it 'finds one by old_id'
    it 'finds one by ID + old_id + - + old_variation_id'
    it 'finds one by old_id + - + old_variation_id'
    it 'finds one by ID + id_hash'
    it 'finds one by id_hash'

    it 'finds one by name' do
      items = Item.search('Item 1')
      items.length.should == 1
      items.should        include(@item_1)
    end
    
    it 'finds two by name' do
      items = Item.search('Test Item')
      items.length.should == 2
      items.should        include(@item_1)
      items.should        include(@item_2)
    end
    
    it 'finds one by description'
    it 'finds two by description'

  end
end
