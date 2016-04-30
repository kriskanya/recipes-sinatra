class RecipeController < ApplicationController

  get '/recipes' do
    if session[:id]
      @recipes = Recipe.all
      erb :'/recipes/recipes'
    else
      redirect '/login'
    end
  end

  get '/recipes/new' do 
    if session[:id]
      erb :'/recipes/create_recipe'
    else
      redirect '/login'
    end
  end

  post '/recipes' do 
    if session[:id]
      @recipe = Recipe.new(name: params[:name], prep_time: params[:prep_time], directions: params[:directions])
      @recipe.ingredient_ids = params[:ingredient_ids]
      @recipe.user_id = session[:id]
      @recipe.save

      redirect "/recipes/#{@recipe.id}"
    else
      redirect '/recipes/new'
    end
  end

  get '/recipes/:recipe_id' do 
    if session[:id]
      @recipe = Recipe.find(params[:recipe_id])
      erb :'recipes/show_recipe'
    else
      redirect '/login'
    end
  end

  get '/recipes/:recipe_id/edit' do 
    if session[:id]
      @recipe = Recipe.find(params[:recipe_id])
      # make sure the user has permissing to edit the recipe
      if @recipe.user_id == session[:id]
        erb :'/recipes/edit_recipe'
      else
        redirect '/recipes'
      end
    else
      redirect '/login'
    end
  end

  patch '/recipes/:recipe_id' do 
    if session[:id]
      if params[:name].empty? || params[:prep_time].empty? || params[:directions].empty?
        redirect "/recipes/#{params[:recipe_id]}/edit"
      end

      @recipe = Recipe.find(params[:recipe_id])
      @recipe.name = params[:name]
      @recipe.prep_time = params[:prep_time]
      @recipe.directions = params[:directions]
      @recipe.save

      redirect "/recipes/#{@recipe.id}"
    else
      redirect '/login'
    end
  end

  delete '/recipes/:recipe_id/delete' do 
    if session[:id]
      recipe = Recipe.find(params[:recipe_id])
      if recipe.user_id == session[:id]
        recipe.destroy
      end
    end
    redirect '/recipes'
  end
end