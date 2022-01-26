class AddFinishedToOrders < ActiveRecord::Migration[6.1]
  def change
    add_column :orders, :finished, :boolean, default:false, null:false
  end
end
