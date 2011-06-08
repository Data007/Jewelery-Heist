class Admin::Orders::TicketsController < AdminController
  before_filter :find_order
  
  def update
    logger.debug "-- Ticket params[:ticket].inspect => #{params[:ticket].inspect}"
    ticket = Ticket.find(params[:id])
    #ticket.current_stage_id = params[:ticket][:current_stage_id]
    #params[:ticket].delete(:current_stage_id)
    ticket.update_attributes params[:ticket]
    redirect_to admin_order_path(ticket.order)
  end
end
