require 'spec_helper'

describe Variation do
  before do
    @item = Factory.create :item
  end

  it 'finds jewels' do
    variation_1 = @item.variations.create
    variation_2 = @item.variations.create
    variation_3 = @item.variations.create

    variation_1.jewels == %w(ruby emerald)
    variation_2.jewels == %w(ruby diamond)
    variation_3.jewels == ['sapphire', 'rudilated quartz']

    variation_1.save
    variation_2.save
    variation_3.save

    query = Variation.jewels_like('ru')
    query.should     == ['ruby', 'rudilated quartz']
    query.should_not    include('diamond')
  end

end
