# file: app.rb
require 'sinatra'
require "sinatra/reloader"
require_relative 'lib/database_connection'
require_relative 'lib/album_repository'
require_relative 'lib/artist_repository'

DatabaseConnection.connect

class Application < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
    also_reload 'lib/album_repository'
    also_reload 'lib/artist_repository'
  end

#  get '/tasks/new' do
#    return erb(:new_task)
#  end

get '/albums/new' do
  return erb(:new_album)
end

get '/artists/new' do
  return erb(:new_artist)
end

  post '/albums' do
   @title = params[:title]
   release_year = params[:release_year]
   artist_id = params[:artist_id]

   new_album = Album.new
   new_album.title = @title
   new_album.release_year = release_year
   new_album.artist_id = artist_id
   AlbumRepository.new.create(new_album)
    return erb(:album_created)
  end

  post '/artists' do
    @name = params[:name]
    genre = params[:genre]
    
 
    new_artist = Artist.new
    new_artist.name = @name
    new_artist.genre = genre
    ArtistRepository.new.create(new_artist)
     return erb(:artist_created)
   end


  get '/albums' do 
    repo = AlbumRepository.new 
    @albums = repo.all

    return erb(:albums)
  end

  get '/albums/:id' do 
    repo = AlbumRepository.new 
    artist_repo = ArtistRepository.new
   
    @album = repo.find(params[:id])
    @artist = artist_repo.find(@album.artist_id)
    return erb(:album)
  end

  get '/artists/:id' do 
    repo = ArtistRepository.new 
    @artist = repo.find(params[:id])
    return erb(:artist)
  end

  get '/artists' do 
    repo = ArtistRepository.new 
    @artists = repo.all
    return erb(:artists)
  end
end