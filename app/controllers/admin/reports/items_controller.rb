class Admin::Reports::ItemsController < Admin::ReportsController
  def current
    @stock_items = ItemReport.current_stock
  end
end
