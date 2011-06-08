class Admin::TicketsController < AdminController
  def index
    if params[:user_id]
      @current_tickets = User.find(params[:user_id]).tickets.opened.paginate(pagination_hash)
    else
      case params[:type]
      when "mine"
        @current_tickets = @current_user.tickets.opened.paginate(pagination_hash)
      when "assigned"
        @current_tickets = Ticket.assigned.paginate(pagination_hash)
      when "open"
        @current_tickets = Ticket.opened.paginate(pagination_hash)
      when "closed"
        @current_tickets = Ticket.closed.paginate(pagination_hash)
      else
        @current_tickets = Ticket.opened.paginate(pagination_hash)
      end
    end
  end
  
  def accept
    safe_find do
      @ticket = Ticket.find(params[:id])
      if @ticket.update_attributes :assigned_id => @current_user.id
        flash[:notice] = "A new item as been assigned to you"
      else
        flash[:error] = "We could not assign this ticket to you"
      end
    end
    
    redirect_to @ticket ? admin_ticket_path(@ticket) : admin_tickets_path
  end

  def new
  end

  def create
  end

  def edit
  end

  def update
    safe_find do
      @ticket = Ticket.find(params[:id])
      if @ticket.update_attributes params[:ticket]
        if @ticket.current_stage == "close"
          flash[:notice] = "This ticket has been closed."
          redirect_to admin_tickets_path and return
        else
          flash[:notice] = "This ticket has been updated"
        end
      else
        flash[:error] = "We couldn't update your ticket"
      end
    end
    
    redirect_to @ticket ? admin_ticket_path(@ticket) : admin_tickets_path
  end

  def show
    safe_find do
      @ticket = Ticket.find(params[:id])
      @order = @ticket.order_id ? @ticket.order : nil
    end
  end
  
  def find
    redirect_to admin_ticket_path(params[:id])
  end

  def destroy
  end
end
