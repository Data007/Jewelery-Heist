class Permissions < Aegis::Permissions
  role :guest
  role :customer
  role :employee
  role :manager
  role :owner, :default_permission => :allow
  
  # -- limited permissions for staff
  %w(item variation mold collection customer).each do |model|
    permission :"create_#{model}" do |user, klass|
      allow :manager, :employee
    end
    
    permission :"edit_#{model}" do |user, klass|
      allow :manager, :employee
    end
    
    permission :"cancel_#{model}" do |user, klass|
      allow :manager, :employee
    end
  end
  
  # -- greater permissions for staff
  %w(customer).each do |model|
    permission :"destroy_{#model}" do |user, klass|
      allow :manager, :employee
    end
  end
  
  permission :reassign_ticket do
    allow :manager, :owner
  end
end