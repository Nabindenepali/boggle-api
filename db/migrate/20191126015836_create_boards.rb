class CreateBoards < ActiveRecord::Migration[6.0]
  def change
    create_table :boards do |t|
      t.integer :rows
      t.string :dices

      t.timestamps
    end
  end
end
