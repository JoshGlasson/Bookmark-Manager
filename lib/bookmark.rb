require 'pg'
require_relative 'database_connection'
require 'uri'
require_relative './comment.rb'
require_relative './tag'

class Bookmark
  attr_reader :id, :title, :url, :user_id

  def initialize(id:, title:, url:, user_id:)
    @id  = id
    @title = title
    @url = url
    @user_id = user_id
  end

  def self.all(user_id:)
    if ENV['ENVIRONMENT'] == 'test'
      connection = PG.connect(dbname: 'bookmark_manager_test')
    else
      connection = PG.connect(dbname: 'bookmark_manager')
    end
    bookmarks = DatabaseConnection.query("SELECT * FROM bookmarks WHERE user_id = '#{user_id}' ORDER BY id")
    bookmarks.map do |bookmark|
      Bookmark.new(
        url: bookmark['url'],
        title: bookmark['title'],
        id: bookmark['id'],
        user_id: bookmark['user_id']
      )
    end
  end

  def self.create(url:, title:, user_id:)
    return false unless is_url?(url)
    result = DatabaseConnection.query("INSERT INTO bookmarks (url, title, user_id) VALUES('#{url}', '#{title}', #{user_id}) RETURNING id, title, url, user_id;")
    Bookmark.new(id: result[0]['id'], title: result[0]['title'], url: result[0]['url'], user_id: result[0]['user_id'])
  end

  def self.delete(id:)
    DatabaseConnection.query("DELETE FROM bookmarks WHERE id = #{id}")
  end

  def self.update(id:, url:, title:, user_id:)
    result = DatabaseConnection.query("UPDATE bookmarks SET url = '#{url}', title = '#{title}', user_id = #{user_id} WHERE id = #{id} RETURNING id, url, title, user_id;")
    Bookmark.new(id: result[0]['id'], title: result[0]['title'], url: result[0]['url'], user_id: result[0]['user_id'])
  end

  def self.find(id:)
    result = DatabaseConnection.query("SELECT * FROM bookmarks WHERE id = #{id}")
    Bookmark.new(id: result[0]['id'], title: result[0]['title'], url: result[0]['url'], user_id: result[0]['user_id'])
  end

  def comments(comment_class = Comment)
    comment_class.where(bookmark_id: id)
  end

  def tags(tag_class = Tag)
    tag_class.where(bookmark_id: id)
  end

  def self.where(tag_id:)
    result = DatabaseConnection.query("SELECT id, title, url FROM bookmarks_tags INNER JOIN bookmarks ON bookmarks.id = bookmarks_tags.bookmark_id WHERE bookmarks_tags.tag_id = '#{tag_id}';")
    result.map do |bookmark|
      Bookmark.new(id: bookmark['id'], title: bookmark['title'], url: bookmark['url'], user_id: result[0]['user_id'])
    end
  end

  private

  def self.is_url?(url)
    url =~ /\A#{URI::regexp(['http', 'https'])}\z/
  end
end
