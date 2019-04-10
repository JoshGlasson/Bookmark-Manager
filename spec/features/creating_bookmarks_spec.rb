feature 'Adding a new bookmark' do
  scenario 'A user can add a new bookmark to Bookmark Manager' do
    sign_up
    visit('/bookmarks/new')
    fill_in('url', with:'http://www.testbookmark.com')
    fill_in('title', with: 'Test Bookmark')
    click_button 'Submit'
    expect(page).to have_link('Test Bookmark', href: 'http://www.testbookmark.com')
  end

  scenario 'The bookmark must be a valid url' do
    sign_up
    visit('/bookmarks/new')
    fill_in('url', with: 'not a real bookmark')
    click_button('Submit')

    expect(page).not_to have_content "not a real bookmark"
    expect(page).to have_content "You must submit a valid URL."
  end
end
