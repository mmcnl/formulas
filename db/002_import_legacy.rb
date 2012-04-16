require 'sqlite3'

class LegacyDB < ActiveRecord::Base
  self.abstract_class = true
  establish_connection adapter: 'sqlite3', database: 'db/legacy.sqlite3'
end

class LegacyFormula   <  LegacyDB;   self.table_name = 'formulas'; end
class LegacyTonemarks <  LegacyDB;   self.table_name = 'tonemarks'; end
class LegacyFcategory <  LegacyDB;   self.table_name = 'fcategory'; end

class ImportLegacy < ActiveRecord::Migration
  def up
    LegacyFormula.all.each do | old |
      chinese = LegacyTonemarks.find_by_fpinyin(old.pinyin.downcase)
      new_attr =  old.attributes.select { |k,v| Formula.new.attributes.key?(k) }
      new_attr[:chinese_characters] = chinese.ftcc
      new_attr[:pinyin_plain] = chinese.fpinyin
      new_attr[:pinyin] = chinese.ftonemarks unless chinese.ftonemarks.blank?
      new_attr[:category] = LegacyFcategory.find(old.fcategory).item_name rescue ''
      Formula.create(new_attr)
    end
    Formula.connection.execute "
      ALTER TABLE formulas ADD COLUMN ft_symptoms tsvector;
      ALTER TABLE formulas ADD COLUMN ft_pulse tsvector;
      ALTER TABLE formulas ADD COLUMN ft_tongue tsvector;
      ALTER TABLE formulas ADD COLUMN ft_diagnosis tsvector;
      UPDATE formulas SET ft_symptoms =  
        setweight(to_tsvector(coalesce(symptoms,'')), 'A') ||  
        setweight(to_tsvector(coalesce(western_use,'')), 'C');
      UPDATE formulas SET ft_pulse =  
        setweight(to_tsvector(coalesce(pulse,'')), 'A');
      UPDATE formulas SET ft_tongue =  
        setweight(to_tsvector(coalesce(tongue,'')), 'B');
      UPDATE formulas SET ft_diagnosis =  
        setweight(to_tsvector(coalesce(diagnosis,'')), 'A');"
  end

  def down
    Formula.delete_all
  end
end
