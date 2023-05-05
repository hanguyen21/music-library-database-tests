require "spec_helper"
require "rack/test"
require_relative '../../app'

def reset_artists_table
  seed_sql = File.read('spec/seeds/music_library.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'music_library_test' })
  connection.exec(seed_sql)
end


describe Application do

  include Rack::Test::Methods


  let(:app) { Application.new }

  before(:each) do 
    reset_artists_table
  end

     context 'GET /albums/new' do 
       it 'should return the html form to create a new task' do 
          response = get('albums/new')
          expect(response.status).to eq(200)
          expect(response.body).to include('<h1>Add a new album</h1>')
          expect(response.body).to include('form action="/albums" method="POST">')
        end
      end

      context 'GET /artists/new' do 
        it 'should return a form to create a new artist' do
          response = get('artists/new')
          expect(response.status).to eq(200)
          expect(response.body).to include('<h1>Add a new artist</h1>')
          expect(response.body).to include('form action="/artists" method="POST">')
        end
      end

      context "POST /artists" do
        it 'returns a success page' do
          # We're now sending a POST request,
          # simulating the behaviour that the HTML form would have.
          response = post(
            '/artists',
            name: 'Test',
            genre: 'Pop',
          )
          expect(response.status).to eq(200)
          expect(response.body).to include('<h1>You saved artist: Test</h1>')
        end
      end

      context "POST /albums" do
        it 'returns a success page' do
          # We're now sending a POST request,
          # simulating the behaviour that the HTML form would have.
          response = post(
            '/albums',
            title: 'Test',
            release_year: '1990',
            artist_id: '1'
          )
          expect(response.status).to eq(200)
          expect(response.body).to include('<h1>You saved album: Test</h1>')
        end
      end

    context 'GET /albums' do 
    it "return a list of albums" do
    response = get('/albums')
    # <a href="/albums/1">Doolittle</a>
    # <a href="/albums/2">Surfer Rosa</a>
    # <a href="/albums/3">Waterloo</a>
    # <br />
    expect(response.status).to eq(200)
    expect(response.body).to include('<a href="/albums/1">Doolittle</a><br />')
    expect(response.body).to include('<a href="/albums/2">Surfer Rosa</a><br />')
    expect(response.body).to include('<a href="/albums/3">Waterloo</a><br />')
  end
end
    context 'GET /artists' do 
      it " return all artists" do 
      response = get('/artists')
      expect(response.status).to eq(200)
      expect(response.body).to include('<a href="/artists/1">Pixies</a><br />')
      expect(response.body).to include('<a href="/artists/2">ABBA</a><br />')
      expect(response.body).to include('<a href="/artists/3">Taylor Swift</a><br />')
      expect(response.body).to include('<a href="/artists/4">Nina Simone</a><br />')
      end
    end

    context 'GET /albums/:id' do
      it 'returns the HTML content for single album 2' do 
        response = get('/albums/2')
        expect(response.status).to eq(200)
        expect(response.body).to include('<h1>Surfer Rosa</h1>')
        expect(response.body).to include('Release year: 1988')
        expect(response.body).to include('Artist: Pixies')
      end
    end
  
    context 'GET /artists/:id' do
     it 'returns the content for a single artists' do 
      response = get('/artists/1')
      expect(response.status).to eq(200)
      expect(response.body).to include('<h1>Pixies</h1>')
      expect(response.body).to include('Genre: Rock')
     end
    end
  end
  # context 'POST /artists' do 
  #   it "create a new artist" do
  #     response = post('/artists', name: 'Wild nothing', genre: 'Indie')
  #     expect(response.status).to eq(200)
  #     expect(response.body).to eq('')
  #     response = get('/artists')
  #     expect(response.body).to include('Wild nothing')
  #   end
  # end
#   context 'GET /albums' do 
#     it "return a list of albums" do
#     response = get('/albums')
#     expect(response.body).to include('Title: Doolittle')
#     expect(response.body).to include('Released: 1989')
#     expect(response.body).to include('Title: Surfer Rosa')
#   end
# end
  # context 'GET /abums' do 
  #  it "return a list of albums" do
  #    response = get('/albums')
  #    expected_response = 'Doolittle,Surfer Rosa,Waterloo,Super Trouper,Bossanova,Lover,Folklore,I Put a Spell on You,Baltimore,Here Comes the Sun,Fodder on My Wings,Ring Ring'
  #    expect(response.status).to eq(200)
  #    expect(response.body).to eq(expected_response)
  #  end
  # end
 
  # context 'POST /abums' do 
  #   it "create a new album" do
  #     response = post('/albums', title: 'OK Computer', release_year: '1997', artist_id: '1')
  #     expect(response.status).to eq(200)
  #     expect(response.body).to eq('')

  #     response = get('/albums')
  #     expect(response.body).to include('OK Computer')
  #   end
  #  end

    # context 'GET /' do 
    #  it 'returns a hello page if pw correct ' do
    #   response = get('/', password: 'abcd')
    #   expect(response.body).to include('Hello')
    #  end 

    #  it 'returns a forbidden if pw is incorrect ' do
    #   response = get('/', password: 'abcddef')
    #   expect(response.body).to include('Access forbidden!')
    #  end
    #  end

    #  context 'GET /' do 
    #   it 'returns the html list of names' do
    #    response = get('/')
    #    expect(response.body).to include('<p>Ha</p>')
    #    expect(response.body).to include('<p>Alex</p>')
    #    expect(response.body).to include('<p>Kim</p>')
    #    expect(response.body).to include('<p>Dave</p>')
    #   end
   
  #    it 'returns the html index' do
  #     response = get('/')
  #     expect(response.body).to include
  #     ('<h1>Hello!</h1>')
  #     # <img src="hello.jpg" />
  #     expect(response.body).to include('<img src="hello.jpg" />')
  #    end
  #  end

  #  context 'GET /' do
  #   it 'returns an html hello message with the given name' do
  #     response = get('/', name: 'Ha')
  #     expect(response.body).to include('<h1>Hello Ha!</h1>')
  #   end

    # it 'returns an html hello message with the different name' do
    #   response = get('/', name: 'Dana')
    #   expect(response.body).to include('<h1>Hello Dana!</h1>')
    # end


