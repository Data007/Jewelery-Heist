require 'spec_helper'

describe Item do

  context 'Asset sort' do
    
    before do
      @item = Factory.create :item
      @asset1 = @item.assets.create
      @asset2 = @item.assets.create
      @asset3 = @item.assets.create

      @asset1.position.should == 0
      @asset2.position.should == 1
      @asset3.position.should == 2
    end

    it 'puts asset 1 in the middle of the stack' do
      @item.update_asset_position(@asset1, 1)
      
      @asset1 = @item.assets.find(@asset1.id)
      @asset2 = @item.assets.find(@asset2.id)

      @asset1.position.should == 1
      @asset2.position.should == 0
    end

    it 'puts asset 3 on the top of the stack' do
      @item.update_asset_position(@asset3, 0)
      
      @asset1 = @item.assets.find(@asset1.id)
      @asset2 = @item.assets.find(@asset2.id)
      @asset3 = @item.assets.find(@asset3.id)

      @asset1.position.should == 1
      @asset2.position.should == 2
      @asset3.position.should == 0
    end

    it 'puts asset 2 on the bottom of the stack' do
      @item.update_asset_position(@asset2, 2)
      
      @asset3 = @item.assets.find(@asset3.id)
      @asset2 = @item.assets.find(@asset2.id)

      @asset3.position.should == 1
      @asset2.position.should == 2
    end

  end


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
      pending 'Id split in keywords causes problems'
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

  context 'Sizes' do

    before do
      @item = Factory.create :item
    end

    it 'parses a size range with a -' do
      @item.size_range = '1-4'
      @item.sizes.should == %w(1 1.5 2 2.5 3 3.5 4)
    end

    it 'parses a size range with a ,' do
      @item.size_range = '1,4'
      @item.sizes.should == %w(1 4)
    end

    it 'parses a size range with both a - and a ,' do
      @item.size_range = '1-4,5,10'
      @item.sizes.should == %w(1 1.5 2 2.5 3 3.5 4 5 10)
    end

    it 'saves a size range with a -' do
      @item.sizes = '1-4'
      @item.sizes.should == %w(1 1.5 2 2.5 3 3.5 4)
    end

    it 'saves a size range with a ,' do
      @item.sizes = '1,4'
      @item.sizes.should == %w(1 4)
    end

    it 'saves a size range with both a - and a ,' do
      @item.sizes = '1-4,5,10'
      @item.sizes.should == %w(1 1.5 2 2.5 3 3.5 4 5 10)
    end

  end

  context 'Clone Tool' do
    pending 'waiting for coverage stats'
  end

end
