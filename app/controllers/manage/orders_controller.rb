class Manage::OrdersController < ManageController
  before_filter :force_access_pin

end
