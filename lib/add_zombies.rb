module AddZombies
  module ZombieState
    def self.included(base)
      base.class_eval do
        scope :the_living,  :conditions => {:ghost => false}
        scope :the_dead,    :conditions => {:ghost => true}
      end
    end
  end
  
  def destroy
    self.ghost = true
    self.save!
  end
  
  def resurrect
    self.ghost = false
    self.save!
  end
end
