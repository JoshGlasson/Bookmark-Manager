feature 'Deleting a bookmark' do
  scenario 'A user can delete a bookmark' do
    sign_up
    visit('/bookmarks')
    add_bookmark_makers
    expect(page).to have_link('Makers Academy', href: 'http://www.makersacademy.com')

    first('.bookmark').click_button 'Delete'

    expect(current_path).to eq '/bookmarks'
    expect(page).not_to have_link('Makers Academy', href: 'http://www.makersacademy.com')
  end
end
