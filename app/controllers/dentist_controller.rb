class DentistController < ApplicationController

  get '/dentists/new' do
    if !!session[:developer?]
      erb :'dentists/create'
    else
      redirect to '/'
    end
  end

  post '/dentists/new' do
    Dentist.create(params)
    redirect to '/dentists'
  end

  get '/dentists' do
    @dentist = Dentist.all
    erb :'dentists/index'
  end

  get '/dentists/:id' do
    @dentist = Dentist.find_by_id(params[:id])
    @user = User.find_by_id(session[:user_id])
    @comments = Comment.all.select{|comment| comment.dentist_id == params[:id].to_i}
    erb :'dentists/show'
  end

  post '/dentists/:id' do
    @comment = Comment.new(:content => params[:content])
    @comment.dentist = Dentist.find_by_id(params[:id])
    @comment.user = User.find_by_id(session[:user_id])
    @comment.save
    redirect to "/dentists/#{@comment.dentist_id}"
  end

  patch '/dentists/:id' do
    @dentist = Dentist.find_by_id(params[:id])
    @dentist.update(:name => params[:name], :fee => params[:fee])
    redirect to '/dentists'
  end

  get '/dentists/:id/edit' do
    if !!session[:developer?]
      @dentist = Dentist.find_by_id(params[:id])
      erb :'dentists/update'
    else
      redirect to '/'
    end
  end

  get '/dentists/:id/delete' do
    if !!session[:developer?]
      @dentist = Dentist.find_by_id(params[:id])
      @dentist.delete
    end
    redirect to '/dentists'
  end

  get '/comments/:id/edit' do
    @comments = Comment.all.select{|comment| comment.user_id == session[:user_id].to_i}
    @comment = Comment.find_by_id(params[:id])
    @dentist = Dentist.find_by_id(@comment.dentist_id)
    if session[:user_id] == @comment.user_id
      @dentist = Dentist.find_by_id(params[:id])
      erb :'comments/update'
    else
      redirect to '/'
    end
  end

  patch '/comments/:id' do
    @comment = Comment.find_by_id(params[:id])
    @comment.update(:content => params[:content])
    redirect to "/dentists/#{@comment.dentist_id}"
  end

  get '/comments/:id/delete' do
    @comment = Comment.find_by_id(params[:id])
    @dentist = Dentist.find_by_id(@comment.dentist_id)
    if session[:user_id] == @comment.user_id
      @comment.delete
      redirect to "/dentists/#{@dentist.id}"
    end
  end
end
