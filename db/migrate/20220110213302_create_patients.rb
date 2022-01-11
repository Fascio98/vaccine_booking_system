class CreatePatients < ActiveRecord::Migration[6.1]
  def change
    create_table :patients do |t|
      t.string :first_name, null: false, limit: 50
      t.string :last_name, null: false, limit: 50
      t.string :pin, null:false, limit: 50, index: true
      t.date :birth_date, null: false
      t.boolean :non_resident, null:false, default:false
      t.string :mobile_phone, null: false, limit: 50, index: true
      t.string :email, limit:255

      t.timestamps
    end
  end
end
