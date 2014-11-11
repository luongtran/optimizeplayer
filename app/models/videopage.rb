class Videopage < ActiveRecord::Base
	belongs_to :project
	belongs_to :user
	serialize :template, ActiveRecord::Coders::Hstore
	serialize :settings, ActiveRecord::Coders::Hstore
	attr_accessible :widgets, :project_id, :template, :seo, :is_iframe, :settings, :slug, :user_id
end
