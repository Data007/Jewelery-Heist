module TicketErrors
  class CloseError < StandardError; end
  class InvalidKind < StandardError; end
end

class Ticket
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Sequence
  include TicketErrors

  field :notes
  field :assigned_id
  field :current_stage_id,   type: Integer
  field :kind
  field :closed,             type: Boolean, default: false
  field :closed_note
  field :current_stage_notes
  field :due_at,             type: DateTime

  field :pretty_id,    type: Integer
  sequence :pretty_id  

  embedded_in :order
  
  STAGES = {
    :"website purchase" => [
      "new",
      "customer lookup",
      "addressing",
      'adding items',
      "payments",
      "paid",
      "handed off",
      "obtaining parts",
      "injecting",
      "carving",
      "casting",
      "processing",
      'repairing',
      "finished",
      "shipping",
      "restocked",
      "delivered",
      'close'
    ],
    :"website custom" => [
      'new',
      "customer lookup",
      "addressing",
      'adding items',
      'sketching',
      'sketch approval',
      'awaiting deposit',
      "payments",
      'handed off',
      'obtaining parts',
      'injecting',
      'carving',
      'wax approval',
      'casting',
      'processing',
      'finished',
      'photographing',
      'final approval',
      'balance paid',
      'shipping',
      'restocked',
      'delivered',
      'close'
    ],
    :"instore custom" => [
      'new',
      "customer lookup",
      "addressing",
      'adding items',
      'sketching',
      'sketch approval',
      'awaiting deposit',
      "payments",
      'handed off',
      'obtaining parts',
      'injecting',
      'carving',
      'wax approval',
      'casting',
      'processing',
      'finished',
      'photographing',
      'final approval',
      'balance paid',
      'restocked',
      'delivered',
      'close'
    ],
    :"instore repair" => [
      'new',
      "customer lookup",
      "addressing",
      'adding items',
      'deposit',
      "payments",
      'handed off',
      'photographing',
      'obtaining parts',
      'queueing',
      'repairing',
      'finished',
      'photographing',
      'customer called',
      'awaiting pickup',
      'delivered',
      'close'
    ],
    :"instore production" => [
      'new',
      'handed off',
      'obtaining parts',
      'carving',
      'molding',
      'investing',
      'casting',
      'processing',
      'photographing',
      'inventorying',
      'stocked',
      'close'
    ],
    :"instore purchase" => [
      'new',
      'customer lookup',
      'addressing',
      'adding items',
      'handed off',
      'payments',
      'repairing',
      'customer called',
      'awaiting pickup',
      'restocked',
      'delivered',
      'close'
    ]
  }
  
  default_scope :order => "due_at ASC"
    
  def before_save
    raise InvalidKind, "#{self.kind} is not a valid kind of ticket" unless STAGES[:"#{self.kind}"]
    self.close if self.current_stage.present? && self.current_stage == "close"
  end
  
  def before_create
    self.current_stage_id = 0 if self.current_stage_id == nil
    self.assigned_id = self.order.clerk_id if self.order_id
  end
  
  def current_stage
    return STAGES[:"#{self.kind}"][0] unless self.current_stage_id
    return STAGES[:"#{self.kind}"][self.current_stage_id]
  end
  
  def current_stage=(id)
    new_id = id.class == String ? STAGES[:"#{self.kind}"].index(id) : id
    self.current_stage_id = new_id if new_id != nil && STAGES[:"#{self.kind}"][new_id]
    self.save
  end
  
  def last_stage?
    return self.current_stage_id == STAGES[:"#{self.kind}"].length - 1 ? true : false
  end
  
  def last_stage
    self.current_stage = STAGES[:"#{self.kind}"].length - 1
  end
  
  def next_stage
    self.current_stage = self.last_stage? ? self.current_stage : (self.current_stage_id + 1)
    return self.current_stage
  end
  
  def next_stage?
    return self.last_stage? ? self.current_stage : STAGES[:"#{self.kind}"][self.current_stage_id + 1]
  end
  
  def previous_stage_was
    return self.current_stage_id == 0 ? "new" : STAGES[:"#{self.kind}"][self.current_stage_id - 1]
  end
  
  def stages
    return STAGES[:"#{self.kind}"].inject_with_index([]) {|stages, stage, index| stages << [stage, index]}
  end
  
  def close notes=nil
    # raise CloseError, "You must include a note when closing a ticket" if notes == nil
    write_attribute :closed, true
    write_attribute :closed_note, notes
  end
end
