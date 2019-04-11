require_relative './database_connection'
require_relative './bookmark'

class Tag
  def self.create(content:, user_id:)
    result = DatabaseConnection.query("SELECT * FROM tags WHERE content = '#{content}' AND user_id = '#{user_id}';").first
    if !result
      result = DatabaseConnection.query("INSERT INTO tags (content, user_id) VALUES('#{content}', #{user_id}) RETURNING id, content, user_id;").first
    end
    Tag.new(id: result['id'], content: result['content'], user_id: result['user_id'])
  end

  def self.where(bookmark_id:, user_id:)
    result = DatabaseConnection.query("SELECT id, content, user_id FROM bookmarks_tags INNER JOIN tags ON tags.id = bookmarks_tags.tag_id WHERE bookmarks_tags.bookmark_id = '#{bookmark_id}';")
    result.map do |tag|
      Tag.new(id: tag['id'], content: tag['content'], user_id: tag['user_id'])
    end
  end

  def self.find(id:, user_id:)
    result = DatabaseConnection.query("SELECT * FROM tags WHERE id = #{id};")
    Tag.new(id: result[0]['id'], content: result[0]['content'], user_id: user_id)
  end


  attr_reader :id, :content, :user_id

  def initialize(id:, content:, user_id:)
    @id = id
    @content = content
    @user_id = user_id
  end

  def bookmarks(bookmark_class = Bookmark)
    bookmark_class.where(tag_id: id, user_id: user_id.to_i)
  end
end
