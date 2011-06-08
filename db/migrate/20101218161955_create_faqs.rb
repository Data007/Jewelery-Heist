class CreateFaqs < ActiveRecord::Migration
  def self.up
    create_table :faqs do |t|
      t.text :header, :body
      t.timestamps
    end
    
    Faq.reset_column_information
    
    Faq.create()
  end

  def self.down
    drop_table :faqs
  end
end
