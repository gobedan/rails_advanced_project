class AddBadgeRefToQuestions < ActiveRecord::Migration[6.0]
  def change
    add_reference :badges, :question, foreign_key: true
    add_reference :badges, :reciever, foreign_key: { to_table: :users }
  end
end
