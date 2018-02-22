class DevelopersController < ApplicationController
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
      erb :'dentists/show'
    else
      redirect to '/'
    end
  end

  post '/dentists/edit' do
    if !!session[:developer?]
      binding.pry
      @dentist = Dentist.find_by
      erb :'dentist/update'
    else
      redirect to '/'
    end
  end
end
