class CreateVerifySmsMessages < ActiveRecord::Migration[6.1]
  def change
    create_table :verify_sms_messages do |t|
      t.references :booking, null: false, foreign_key: true
      t.string :code, limit:16, null:false, index: true
      t.datetime :approved_at, null:false
      t.datetime :sent_at, null:false

      t.timestamps
    end
  end
end
