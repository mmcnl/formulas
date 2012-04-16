class CreateFormulas < ActiveRecord::Migration
  def up
    create_table "formulas" do |t|
      t.string  "pinyin",   :limit=> 100,           :null => false
      t.string  "pinyin_plain",   :limit=> 100,     :null => false
      t.string  "chinese_characters"
      t.string  "category"
      t.text    "symptoms",                         :null => false
      t.string  "tongue",                           :null => false
      t.string  "pulse",                            :null => false
      t.string  "functions",                        :null => false
      t.string  "diagnosis",                        :null => false
      t.text    "functions",                        :null => false
      t.text    "herb_breakdown",                   :null => false
      t.text    "western_use",                      :null => false
      t.integer "req_state_board",  :default => 0,  :null => false
      t.integer "impt",             :default => 0,  :null => false
    end
  end

  def down
     drop_table "formulas"
  end
end
