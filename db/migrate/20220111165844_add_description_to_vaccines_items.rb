class AddDescriptionToVaccinesItems < ActiveRecord::Migration[6.1]
  def change
    add_column :vaccines_items, :description, :text
  end
end
