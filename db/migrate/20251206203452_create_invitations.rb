class CreateInvitations < ActiveRecord::Migration[7.1]
  def change
    create_table :invitations do |t|
      t.string :username, null: false
      t.integer :invitation_type, null: false, default: 0
      t.string :cpf
      t.string :email
      t.string :code
      t.references :company, null: false, foreign_key: true
      t.boolean :active, default: true, null: false
      t.datetime :activated_at
      t.datetime :deactivated_at

      t.timestamps
    end

    add_index :invitations, :active
  end
end
