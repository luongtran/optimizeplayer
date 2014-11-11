class Folder < ActiveRecord::Base
  attr_accessible :account_id, :name, :parent_id
  has_many :projects, order: :position
  belongs_to :account
  belongs_to :parent, foreign_key: 'parent_id'
  has_many :subfolders, class_name: 'Folder', foreign_key: 'parent_id'
  validates :name, presence: true

  def projects_count
    projects.count
  end

  def as_json(options = {})
    super options.merge(
      only:     [:id, :name, :parent_id],
      methods:  [:projects_count],
      include:  {subfolders: {
        only:     [:id, :name, :parent_id, :projects_count],
        methods:  [:projects_count]
      } }
    )
  end

  def only_favorite_projects_count
    projects.where{ (favorite == true) & (dashboard != true) }.count
  end

  def two_stars_projects_count
    projects.where{ (favorite == true) & (dashboard == true) }.count
  end

  def no_star_projects_count
    projects.where{ (favorite != true) & (dashboard != true) }.count 
  end
end
