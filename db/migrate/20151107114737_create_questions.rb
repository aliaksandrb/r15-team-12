class CreateQuestions < ActiveRecord::Migration
  def change
    enable_extension 'hstore'

    create_table :questions do |t|
      t.integer :quiz_id, null: false, index: true
      t.string :text, null: false
      t.integer :answer, null: false
      t.integer :time_limit, null: false, default: 30
      t.hstore :options, array: true, default: []

      t.timestamps null: false
    end
  end
end
