require 'pg'

feature 'Viewing bookmarks' do

  feature '#visiting the homepage' do
    scenario 'the page title is visible' do
      visit '/'

      expect(page).to have_content 'Bookmark Manager'
    end

    scenario 'links to bookmarks page' do
      visit '/'
      click_button 'Sign Up'
      fill_in(:email, with: 'test@example.com')
      fill_in(:password, with: 'password123')
      click_button 'Submit'

      click_button 'Bookmarks'

      expect(page).to have_content 'Bookmarks'
    end
  end

  scenario 'bookmarks are visible' do
    Bookmark.create(url: 'http://www.makersacademy.com', title: 'Makers Academy')
    Bookmark.create(url: 'http://www.destroyallsoftware.com', title: 'Destroy All Software')
    Bookmark.create(url: 'http://www.google.com', title: 'Google')

    visit '/bookmarks'

    expect(page).to have_link('Makers Academy', href: 'http://www.makersacademy.com')
    expect(page).to have_link('Destroy All Software',  href: 'http://www.destroyallsoftware.com')
    expect(page).to have_link('Google', href: 'http://www.google.com')
  end
end
