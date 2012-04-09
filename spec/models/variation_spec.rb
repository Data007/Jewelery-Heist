require 'spec_helper'

describe Variation do
  before do
    @item = FactoryGirl.create :item
  end

  it 'finds jewels' do
    variation_1 = @item.variations.create
    variation_2 = @item.variations.create
    variation_3 = @item.variations.create

    variation_1.jewels = %w(ruby emerald)
    variation_2.jewels = %w(ruby diamond)
    variation_3.jewels = ['sapphire', 'rudilated quartz']

    variation_1.save
    variation_2.save
    variation_3.save

    query = Variation.jewels_like('ru')

    query.should     include('ruby')
    query.should     include('rudilated quartz')
    query.should_not include('diamond')
  end

  it 'stores and return metal_csv' do
    metals    = 'sterling silver,14ky gold'
    variation = @item.variations.create

    variation.metal_csv = metals

    variation.metal_csv.should == metals
    variation.metals.should       include('sterling silver')

    variation.save
    variation = @item.variations.find(variation.id)

    variation.metal_csv.should == metals
    variation.metals.should       include('sterling silver')
  end

end
