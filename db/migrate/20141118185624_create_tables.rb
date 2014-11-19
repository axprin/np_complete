class CreateTables < ActiveRecord::Migration
  def change
  	create_table :items do |t|
  		t.string :name
  		t.float :cost
  		t.timestamps
  	end
  	create_table :totals do |t|
  		t.float :amount
  		t.timestamps
  	end
  end
end
