require 'sinatra'
enable :sessions

get '/' do
  erb(:index)
end

get '/story/:title' do
  @title = params[:title]
  erb(:story)
end

post '/story/:title' do
  # return params.to_s
  @title = params[:title]
  @post = params
  # puts params
  @counter = 0
  @text = ''
  File.open("./public/uploads/#{@title}.txt", 'r') do |f|
    f.each_line do |line|
      line.split(' ').each do |word|
        if word.include?('[') && word.include?(']')
          @text << params["param#{@counter}".to_sym] << ' '
          @counter += 1
        else
          @text << word << ' '
        end
      end
    end
  end
  puts @text
  session[:text] = @text
  session[:title] = @title
  # erb("/result/#{@title}".to_sym)
  # redirect "/result/#{@title}"
  redirect '/result'
end

get '/result' do
  puts 'Go to result'
  @text = session[:text]
  puts @text
  @title = session[:title]
  erb(:result)
end

get '/upload' do
  erb(:upload)
end

post '/upload' do
  @filename = params[:file][:filename]
  file = params[:file][:tempfile]
  File.open("./public/uploads/#{@filename}", 'wb') do |f|
    f.write(file.read)
  end
  redirect '/'
end