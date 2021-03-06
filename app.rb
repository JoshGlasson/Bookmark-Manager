require 'sinatra/base'
require_relative './lib/bookmark'
require_relative './database_connection_setup'
require 'sinatra/flash'
require_relative './lib/comment'
require_relative './lib/tag'
require_relative './lib/bookmark_tag'
require_relative './lib/user'

class BookmarkManager < Sinatra::Base
  enable :sessions, :method_override
  register Sinatra::Flash

  get '/' do
    @user = User.find(id: session[:user_id])
    erb :'bookmarks/home'
  end

  get '/bookmarks' do
    @user = User.find(id: session[:user_id])
    @bookmarks = Bookmark.all(user_id: session[:user_id])
    erb :'bookmarks/index'
  end

  get '/bookmarks/new' do
     erb :'bookmarks/new'
  end

  post '/bookmarks' do
    unless Bookmark.create(url: params[:url], title: params[:title], user_id: session[:user_id])
      flash[:notice] = "You must submit a valid URL."
    else
      flash[:notice] = 'Bookmark Added.'
    end
    redirect '/bookmarks'
  end

  delete '/bookmarks/:id' do
    BookmarkTag.delete(id: params[:id])
    Comment.delete(id: params[:id])
    Bookmark.delete(id: params[:id])
    flash[:notice] = 'Bookmark Deleted.'
    redirect '/bookmarks'
  end

  get '/bookmarks/:id/edit' do
    @bookmark = Bookmark.find(id: params[:id], user_id: session[:user_id])
    erb :'bookmarks/edit'
  end

  patch '/bookmarks/:id' do
    Bookmark.update(id: params[:id], title: params[:title], url: params[:url], user_id: session[:user_id])
    flash[:notice] = 'Bookmark Changed.'
    redirect '/bookmarks'
  end

  get '/bookmarks/:id/comments/new' do
    @bookmark_id = params[:id]
    erb :'comments/new'
  end

  post '/bookmarks/:id/comments' do
    Comment.create(text: params[:comment], bookmark_id: params[:id])
    flash[:notice] = 'Comment Added.'
    redirect '/bookmarks'
  end

  get '/bookmarks/:id/tags/new' do
    @bookmark_id = params[:id]
    erb :'/tags/new'
  end

  post '/bookmarks/:id/tags' do
    tag = Tag.create(content: params[:tag], user_id: session[:user_id])
    BookmarkTag.create(bookmark_id: params[:id], tag_id: tag.id)
    flash[:notice] = 'Tag Added.'
    redirect '/bookmarks'
  end

  get '/tags/:id/bookmarks' do
    @tag = Tag.find(id: params['id'], user_id: session[:user_id])
    @user = User.find(id: session[:user_id])
    erb :'tags/index'
  end

  get '/users/new' do
    erb :'users/new'
  end

  post '/users' do
    user = User.create(email: params[:email], password: params[:password])
    session[:user_id] = user.id
    redirect '/'
  end

  get '/sessions/new' do
    erb :"sessions/new"
  end

  post '/sessions' do
    user = User.authenticate(email: params[:email], password: params[:password])

    if user
      session[:user_id] = user.id
      redirect('/')
    else
      flash[:notice] = 'Please check your email or password.'
      redirect('/sessions/new')
    end
  end

  post '/sessions/destroy' do
    session.clear
    flash[:notice] = 'You have signed out.'
    redirect '/'
  end

  run! if app_file == $0
end
