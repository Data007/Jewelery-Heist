class Admin::ItemsController < AdminController

  before_filter :find_item, :except => [:index, :published, :new, :create]

  def new
    @item = Item.new
    render template: 'admin/items/new'
  end

  def create
    @item = Item.new params[:item]
    if @item.save
      redirect_to edit_admin_item_path(@item.pretty_id), notice: "#{@item.name.titleize} has been created for you."
    else
      render template: 'admin/items/new'
    end
  end

  def clone
    @new_item           = @item.clone
    @new_item.pretty_id = nil
    @new_item.cloned    = true
    @new_item.save
    @new_item.update_attribute :assets, []
    @new_item.reload

    @item.assets.each do |asset|
      asset_hash = {
        image_file_name:    asset.image_file_name,
        image_content_type: asset.image_content_type,
        image_file_size:    asset.image_file_size,
        image_updated_at:   asset.image_updated_at,
        migratory_url:      asset.image.url(:original),
        position:           asset.position,
        cloned:             true
      }

      new_asset = @new_item.assets.create(asset_hash)
      new_asset.refresh_image
    end

    redirect_to edit_admin_item_path(@new_item.pretty_id), notice: "Cloned from #{@item.name.titleize}"
  end
  
  def show
  end

  def edit
  end

  def update
    if @item.update_attributes(params[:item])
      flash[:notice] = 'The item has been saved'
      redirect_to edit_admin_item_path(@item.pretty_id)
    else
      flash[:error] = "We couldn't save the item"
      render 'admin/items/edit'
    end
  end

  def destroy
    @item.update_attribute :ghost, true
    redirect_to admin_item_path(@item.pretty_id)
  end

  def remove
    @item.update_attribute :ghost, true
    redirect_to admin_item_path(@item.pretty_id)
  end

  def cancel
    @item.destroy
    redirect_to [:admin, :items]
  end

  def restore
    @item.update_attribute :ghost, false
    redirect_to admin_item_path(@item.pretty_id)
  end

  def index
    @items = Item.all.paginate(pagination_hash)
  end

  def published
    @items = Item.published.paginate(pagination_hash)
    render template: 'admin/items/index'
  end

  def current
    @items = Item.listable.paginate(pagination_hash)
    render template: 'admin/items/index'
  end

  def old
    @items = Item.not_available.paginate(pagination_hash)
    render template: 'admin/items/index'
  end

  def instore
    @items = Item.listable.unpublished.paginate(pagination_hash)
    render template: 'admin/items/index'
  end

  def ooak
    @items = Item.ooak.paginate(pagination_hash)
    render template: 'admin/items/index'
  end

  def find
  end

private

  def find_item
    @item      = params[:item_id] ? Item.where(pretty_id: params[:item_id]).first : Item.where(pretty_id: params[:id]).first
    @variation = @item.variations.where(pretty_id: params[:variation_id]).first if (@item && params[:variation_id])
  end
end
