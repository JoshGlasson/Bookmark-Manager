require 'pg'

feature 'Viewing bookmarks' do

  feature '#visiting the homepage' do
    scenario 'the page title is visible' do
      visit '/'

      expect(page).to have_content 'Bookmark Manager'
    end

    scenario 'links to bookmarks page' do
      visit '/'
      sign_up

      click_button 'Bookmarks'

      expect(page).to have_content 'Bookmarks'
    end
  end

  scenario 'bookmarks are visible' do

    sign_up
    visit '/bookmarks'
    add_bookmark_makers
    add_bookmark_das
    add_bookmark_google

    expect(page).to have_link('Makers Academy', href: 'http://www.makersacademy.com')
    expect(page).to have_link('Destroy All Software',  href: 'http://www.destroyallsoftware.com')
    expect(page).to have_link('Google', href: 'http://www.google.com')
  end

  scenario 'a user can only see bookmarks they have added' do
    Bookmark.create(url: 'https://joshlearningto.code.blog/', title: 'Joshs Blog', user_id: 0)
    sign_up
    visit '/bookmarks'
    add_bookmark_makers
    add_bookmark_das
    add_bookmark_google

    expect(page).to have_link('Makers Academy', href: 'http://www.makersacademy.com')
    expect(page).to have_link('Destroy All Software',  href: 'http://www.destroyallsoftware.com')
    expect(page).to have_link('Google', href: 'http://www.google.com')
    expect(page).not_to have_link('Joshs Blog', href: 'https://joshlearningto.code.blog/')
  end
end
