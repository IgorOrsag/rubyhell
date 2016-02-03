# doc
class Post < ActiveRecord::Base
  has_many :post_tags
  has_many :tags, through: :post_tags

  validates :author, presence: true
  validates :title, presence: true
  validates :body, presence: true

  def add_tags(tag_names)
    tags.clear
    tag_names = tag_names.split(/[","]|[" "]/)
    tag_names.each do |tag_name|
      tag = Tag.new(name: tag_name)
      !tag.save && tag = Tag.where(name: tag_name)
      tags << tag
    end
  end

  def tag_names
    tags = self.tags.map(&:name)
    tags.join(',')
  end
end
