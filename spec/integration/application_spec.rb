require "spec_helper"
require "rack/test"
require_relative '../../app'

def reset_artists_table
  seed_sql = File.read('spec/seeds/music_library.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'music_library_test' })
  connection.exec(seed_sql)
end


describe Application do
  # This is so we can use rack-test helper methods.
  include Rack::Test::Methods

  # We need to declare the `app` value by instantiating the Application
  # class so our tests work.
  let(:app) { Application.new }

  before(:each) do 
    reset_artists_table
  end

  context 'GET /abums' do 
   it "return a list of albums" do
     response = get('/albums')
     expected_response = 'Doolittle,Surfer Rosa,Waterloo,Super Trouper,Bossanova,Lover,Folklore,I Put a Spell on You,Baltimore,Here Comes the Sun,Fodder on My Wings,Ring Ring'
     expect(response.status).to eq(200)
     expect(response.body).to eq(expected_response)
   end
  end
 
  context 'POST /abums' do 
    it "create a new album" do
      response = post('/albums', title: 'OK Computer', release_year: '1997', artist_id: '1')
      expect(response.status).to eq(200)
      expect(response.body).to eq('')

      response = get('/albums')
      expect(response.body).to include('OK Computer')
    end
   end

   context 'GET /artists' do 
    it " return all artists" do 
    response = get('/artists')
    expected_response = 'Pixies, ABBA, Taylor Swift, Nina Simone'
    expect(response.status).to eq(200)
    expect(response.body).to eq(expected_response)
    end
  end

  context 'POST /artists' do 
    it "create a new artist" do
      response = post('/artists', name: 'Wild nothing', genre: 'Indie')
      expect(response.status).to eq(200)
      expect(response.body).to eq('')

      response = get('/artists')
      expect(response.body).to include('Wild nothing')
    
    end

  
  end

end
