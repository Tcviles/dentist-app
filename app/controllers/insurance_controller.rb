class InsuranceController < ApplicationController
  get '/insurance/new' do
    if !!session[:developer?]
      erb :'insurance/create'
    else
      redirect to '/'
    end
  end

  post '/insurance/new' do
    Insurance.create(params)
    redirect to '/insurance'
  end

  get '/insurance' do
    if !!session[:developer?]
      @insurances = Insurance.all
      erb :'insurance/show'
    else
      redirect to '/'
    end
  end

  post'/insurance' do
    if !!params[:edit]
      @insurance = Insurance.find_by_id(params[:edit])
      redirect to "/insurance/#{@insurance.id}/edit"
    elsif !!params[:delete]
      @insurance = Insurance.find_by_id(params[:delete])
      redirect to "/insurance/#{@insurance.id}/delete"
    else
      redirect to '/insurance'
    end
  end

  patch '/insurance/:id' do
    @insurance = Insurance.find_by_id(params[:id])
    @insurance.update(:company => params[:company], :coverage => params[:coverage])
    redirect to '/insurance'
  end

  get '/insurance/:id/edit' do
    if !!session[:developer?]
      @insurance = Insurance.find_by_id(params[:id])
      erb :'insurance/update'
    else
      redirect to '/'
    end
  end

  get '/insurance/:id/delete' do
    if !!session[:developer?]
      @insurance = Insurance.find_by_id(params[:id])
      @insurance.delete
      redirect to '/insurance'
    end
  end
end
