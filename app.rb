require 'sinatra'
require 'sinatra/reloader'
require 'csv'


get '/' do
    erb :index
end

get '/error' do
    erb :error
end

get '/new' do
    erb :new
end

post '/create' do
    #사용자가 입력한 정보를 받아서
    #csv 파일 가장 마지막에 등록
    # => 이 글의 글번호도 같이 저장해야 함
    # => 글 개수 + 1해서 저장
    title = params[:title]
    contents = params[:contents]
    id = CSV.read('./boards.csv').count + 1
    puts id
    CSV.open('./boards.csv', 'a+') do |row|
        row << [id,title,contents]
    end
     redirect '/boards'
end

get '/boards' do
    #파일을 읽기모드로 열고
    #각 줄마다 순회하면서
    #@가 붙어있는 변수에 넣어줌
    @boards = []
    CSV.open('./boards.csv','r+').each do |row|
        @boards << row
    end
    
    erb :boards
end

get '/board/:id' do
    #CSV파일에서 params[:id]로 넘어온 친구 같은 글번호를 가진 row를 선택
    #=>CSv파일을 전체 순회합니다. 순회하다 첫번째 column이 id와 같은
    #=>값을 만나면 순회를 정지하고 값을 변수에 담아줍니다.
    @board = []
    CSV.read('./boards.csv').each do |row|
        if row[0] == params[:id]
            @board = row
            break 
        end
    end
    erb :board
end

get '/user/new' do 
    erb :new_user
end

post '/user/create' do
        id=params[:id]
    if params[:password].eql? (params[:password_confirmation])
        users= []
        file = CSV.read('./user.csv','r+')
        file.each do |row|
            users << row[0]
        end
        unless users.include?(params[:id])
            password = params[:password]
            CSV.open('user.csv','a+') do |row|
            row << [id,password]
            end
        else
              redirect '/error'
              puts 로그인 실패
        end
        redirect "/user/#{id}"
    else
        redirect '/error'
        puts 로그인 실패
    end
end

get '/users' do
    @users = []
    CSV.read('./user.csv').each do |row|
     @users << row
    end
    erb :users
end

get '/user/:id' do
    @user = []
    CSV.open('./user.csv','r+').each do |row|
        if row[0].eql?(params[:id])
            @user = row
            break
        end
    end
    erb :user
end