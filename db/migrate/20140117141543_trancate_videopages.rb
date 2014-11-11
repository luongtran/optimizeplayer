class TrancateVideopages < ActiveRecord::Migration
  def change
  	ActiveRecord::Base.connection.execute("TRUNCATE TABLE videopages")
  end
end
