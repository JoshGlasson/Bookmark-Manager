require 'tag'
require 'bookmark'
require 'bookmark_tag'
require 'database_helpers'

describe Tag do
  let(:bookmark_class) { double(:bookmark_class) }

  describe '.create' do
    context 'tag does not exist' do
      it 'creates a new Tag object' do
        tag = Tag.create(content: 'test tag', user_id: 1)

        persisted_data = persisted_data(id: tag.id, table: 'tags')

        expect(tag).to be_a Tag
        expect(tag.id).to eq persisted_data.first['id']
        expect(tag.content).to eq 'test tag'
      end
    end
    context 'tag already exists' do
      it 'returns the existing tag' do
        tag1 = Tag.create(content: 'test tag', user_id: 1)
        tag2 = Tag.create(content: 'test tag', user_id: 1)

        expect(tag2.id).to eq tag1.id
      end
    end
  end

  describe '.where' do
    it 'returns tags linked to the given bookmark id' do
      bookmark = Bookmark.create(url: "http://www.makersacademy.com", title: "Makers Academy", user_id: 1)
      tag1 = Tag.create(content: 'test tag 1', user_id: 1)
      tag2 = Tag.create(content: 'test tag 2', user_id: 1)
      BookmarkTag.create(bookmark_id: bookmark.id, tag_id: tag1.id)
      BookmarkTag.create(bookmark_id: bookmark.id, tag_id: tag2.id)

      tags = Tag.where(bookmark_id: bookmark.id, user_id: 1)
      tag = tags.first

      expect(tags.length).to eq 2
      expect(tag).to be_a Tag
      expect(tag.id).to eq tag1.id
      expect(tag.content).to eq tag1.content
    end
  end

  describe '.find' do
    it 'returns a tag with the given id' do
      tag = Tag.create(content: 'test tag', user_id: 1)

      result = Tag.find(id: tag.id, user_id: 1)

      expect(result.id).to eq tag.id
      expect(result.content).to eq tag.content
    end
  end

  describe '#bookmarks' do
    it 'calls .where on the bookmark class' do
      tag = Tag.create(content: 'test tag', user_id: 1)

      expect(bookmark_class).to receive(:where).with(tag_id: tag.id,  user_id: 1)

      tag.bookmarks(bookmark_class)
    end
  end
end
