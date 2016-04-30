class IngredientController < ApplicationController

  get '/ingredients' do 
    if session[:id]
      @ingredients = Ingredient.all
      erb :'/ingredients/ingredients'
    else
      redirect '/login'
    end
  end

  get '/ingredients/new' do 
    if session[:id]
      erb :'/ingredients/create_ingredient'
    else
      redirect '/login'
    end
  end

  post '/ingredients' do 
    if session[:id]
      @ingredient = Ingredient.new(name: params[:name], cost: params[:cost], amount: params[:amount])
      @ingredient.user_id = session[:id]
      @ingredient.save

      redirect '/ingredients'
    else
      redirect '/login'
    end
  end

  get '/ingredients/:ingredient_id' do 
    if session[:id]
      @ingredient = Ingredient.find(params[:ingredient_id])
      erb :'/ingredients/show_ingredient'
    else
      redirect '/login'
    end
  end

  get '/ingredients/:ingredient_id/edit' do 
    if session[:id]
      @ingredient = Ingredient.find(params[:ingredient_id])

      if @ingredient.user_id = session[:id]
        erb :'/ingredients/edit_ingredient'
      else
        redirect "/ingredients/#{params[:ingredient_id]}"
      end
    else
      redirect '/login'
    end
  end

  patch '/ingredients/:ingredient_id' do
    if session[:id] 
      if params[:name].empty? || params[:cost].empty? || params[:amount].empty?
        redirect "/ingredients/#{params[:ingredient_id]}/edit"
      end

      @ingredient = Ingredient.find(params[:ingredient_id])
      @ingredient.name = params[:name]
      @ingredient.cost = params[:cost]
      @ingredient.amount = params[:amount]
      @ingredient.save

      redirect "/ingredients/#{params[:ingredient_id]}"
    else
      redirect '/login'
    end
  end

  delete '/ingredients/:ingredient_id/delete' do 
    if session[:id]
      ingredient = Ingredient.find(params[:ingredient_id])
      if ingredient.user_id == session[:id]
        ingredient.destroy
      end
    end
    redirect '/ingredients'
  end

end