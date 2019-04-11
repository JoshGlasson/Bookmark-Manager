def sign_up
  visit '/'
  click_button 'Sign Up'
  fill_in(:email, with: 'test@example.com')
  fill_in(:password, with: 'password123')
  click_button 'Sign up'
end

def add_bookmark_makers
  click_button 'Add a Bookmark'
  fill_in(:url, with: 'http://www.makersacademy.com')
  fill_in(:title, with: 'Makers Academy')
  click_button 'Submit'
end

def add_bookmark_das
  click_button 'Add a Bookmark'
  fill_in(:url, with: 'http://www.destroyallsoftware.com')
  fill_in(:title, with: 'Destroy All Software')
  click_button 'Submit'
end

def add_bookmark_google
  click_button 'Add a Bookmark'
  fill_in(:url, with: 'http://www.google.com')
  fill_in(:title, with: 'Google')
  click_button 'Submit'
end
