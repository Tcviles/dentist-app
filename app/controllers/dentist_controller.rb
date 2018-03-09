class DentistController < ApplicationController
  get '/dentists/:id' do
    puts "Hello world"
    @dentist = Dentist.find_by_id(params[:id])
    @comments = Comment.all.collect{|comment| comment.dentist_id == params[:id]}
    erb :'dentists/show'
  end

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
    if !!session[:developer?]
      erb :'dentists/devshow'
    else
      erb :'dentists/index'
    end
  end

  post'/dentists' do
    if !!params[:edit]
      @dentist = Dentist.find_by_id(params[:edit])
      redirect to "/dentists/#{@dentist.id}/edit"
    elsif !!params[:delete]
      @dentist = Dentist.find_by_id(params[:delete])
      redirect to "/dentists/#{@dentist.id}/delete"
    else
      redirect to '/dentists'
    end
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
      redirect to '/dentists'
    end
  end
end
