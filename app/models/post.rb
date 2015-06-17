require 'elasticsearch/model'

class Post < ActiveRecord::Base
  POSTS_LIMIT = 10
  MIN_INTRO_SIZE = 140

  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  default_scope  { order('published_at DESC') }

  belongs_to :author, class_name: 'User'
  belongs_to :category
  acts_as_taggable

  validates :author_id, :body, :title, presence: true

  before_validation :preprocess

  delegate :name, to: :author, prefix: true

  scope :published, -> { where('published_at IS NOT NULL') }
  scope :unpublished, -> { where('published_at IS NULL') }
  scope :recent, -> { limit(POSTS_LIMIT) }
  scope :by_author, ->(author) { published.where(author_id: author) }

  def to_param
    "#{id} #{title}".parameterize
  end

  def published?
    published_at.present?
  end

  def preprocess
    Services::PostProcessor.new(self).process
  end

  def publication_year
    published_at.year
  end

  def related_by_author
    author.posts.published.where('id != ?', id).sample
  end

  def related_by_tags
    find_related_tags.published.limit(3).sample
  end
end
