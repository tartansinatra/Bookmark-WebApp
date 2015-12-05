require 'sinatra'
require 'sinatra/contrib/all' if development?
require 'pry-byebug'
require 'pg'

get '/' do
  redirect to('/bookmarks')
end

#SHOW BOOKMARKS
get '/bookmarks' do 
  # Get all bookmarks from DB
  sql = "SELECT * FROM bookmarks"
  @bookmarks = run_sql(sql)
  erb :index
end

# SET UP ADDING A NEW BOOKMARK (RENDER A FORM)
get '/bookmarks/new' do
  erb :new
end

post '/bookmarks' do
  # PERSIST NEW BOOKMARK TO THE DB
  url = params[:url]
  name = params[:name]
  genre = params[:genre]
  sql = "INSERT INTO bookmarks (url, name, genre) VALUES ('#{url}', '#{name}',' #{genre}')"
  run_sql(sql)
  redirect to('/bookmarks')
end

get '/bookmarks/:id' do
  # Show a specific bookmark on it's own
  bookmark_id = params[:id]
  sql = "SELECT * FROM bookmarks WHERE id = #{bookmark_id}"
  @result = run_sql(sql)
  erb :show
end


get '/bookmarks/:id/edit' do
  # Grab bookmark from DB and render form
   bookmark_id = params[:id]
   sql = "SELECT * FROM bookmarks WHERE id = #{bookmark_id}"
   @bookmark = run_sql(sql).first
   erb :edit
end

post '/bookmarks/:id' do
  url = params[:url]
  name = params[:name]
  genre = params[:genre]
  sql = "UPDATE bookmarks SET url = '#{url}', name = '#{name}', genre = '#{genre}' WHERE id = #{params[:id]}"
# WE HAVE USED THE PARAMS[:id] OPTION INSTEAD OF DEFINING THE VARIABLE ABOVE THE LINE.  BOTH OPTIONS ARE FINE.
  run_sql(sql)
  redirect to("/bookmarks/#{params[:id]}")
end







  def run_sql(sql)
    conn = PG.connect(dbname: 'bookmarks', host: 'localhost')
    result = conn.exec(sql)
    conn.close
    result
  end
