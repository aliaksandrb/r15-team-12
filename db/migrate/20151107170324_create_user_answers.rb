class CreateUserAnswers < ActiveRecord::Migration
  def change
    create_table :user_answers do |t|
      t.references :question, index: true, foreign_key: true
      t.integer :value, null: false
      t.references :game, index: true, foreign_key: true
      t.integer :timeout, null: false, default: 30

      t.timestamps null: false
    end
  end
end
