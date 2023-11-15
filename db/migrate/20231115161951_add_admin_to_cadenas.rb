class AddAdminToCadenas < ActiveRecord::Migration[7.0]
  def change
    add_reference :cadenas, :admin, foreign_key: { to_table: :participants }
  end
end
