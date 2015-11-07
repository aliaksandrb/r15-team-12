class CreateQuizzes < ActiveRecord::Migration
  def change
    create_table :quizzes do |t|
      t.string :name, null: false
      t.integer :fail_limit, null: false, default: 0
      t.string :author_email, null: false

      t.timestamps null: false
    end
  end
end
