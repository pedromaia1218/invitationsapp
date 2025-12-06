class CreateCompanies < ActiveRecord::Migration[7.1]
  def change
    create_table :companies do |t|
      t.string :name, null: false
      t.string :cnpj, null: false
      t.string :address
      t.boolean :active, default: true, null: false

      t.timestamps
    end

    add_index :companies, :name
    add_index :companies, :cnpj, unique: true
  end
end
