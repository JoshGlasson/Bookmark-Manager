feature 'Adding and viewing tags' do
  feature 'a user can add and then view a tag' do
    scenario 'a comment is added to a bookmark' do
      sign_up
      visit '/bookmarks'
      add_bookmark_makers
      first('.bookmark').click_button 'Add Tag'

      fill_in 'tag', with: 'test tag'
      click_button 'Submit'

      expect(current_path).to eq '/bookmarks'
      expect(first('.bookmark')).to have_content 'test tag'
    end
  end

  feature 'a user can filter bookmarks by tag' do
    scenario 'adding the same tag to multiple bookmarks then filtering by tag' do

      sign_up
      visit('/bookmarks')
      add_bookmark_makers
      add_bookmark_das
      add_bookmark_google

      within page.first('.bookmark') do
        click_button 'Add Tag'
      end
      fill_in 'tag', with: 'testing'
      click_button 'Submit'

      within page.all('.bookmark').last do
        click_button 'Add Tag'
      end
      fill_in 'tag', with: 'testing'
      click_button 'Submit'

      first('.bookmark').click_link 'testing'

      expect(page).to have_link 'Makers Academy', href: 'http://www.makersacademy.com'
      expect(page).not_to have_link 'Destroy All Software',  href: 'http://www.destroyallsoftware.com'
      expect(page).to have_link 'Google', href: 'http://www.google.com'
    end
  end
end
