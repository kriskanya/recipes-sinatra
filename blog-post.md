## Sinatra Recipe App

* This CRUD app was created with Sinatra for the purpose of creating, listing, editing, and deleting recipes.
* Each recipe has ingredients.
* Each recipe and each ingredient belong to a user, so they can be edited and deleted by that user.

### Process:
* The first step was to set up the structure of the app, which was based off the structure of the Fwitter app built for the course: https://github.com/kriskanya/sinatra-fwitter-group-project-v-000
* Migrations were created for the following models: user, recipe, and ingredient
```
class CreateUsersTable < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username
      t.string :email
      t.string :password_digest
    end
  end
end
```
* The user model, views, and controllers were the first to be created, followed by recipe and ingredient.

  * They all inherit from ApplicationController, which handles the session data.
  ```
  class ApplicationController < Sinatra::Base

    configure do
      set :public_folder, 'public'
      set :views, 'app/views'
      enable :sessions
      set :session_secret, "secret"
    end

    get '/' do
      erb :'index'
    end
  end
  ```
  * The user controller:
  ```
    class UserController < ApplicationController

      get '/signup' do
        if !session[:id]
          erb :'/users/create_user'
        else
          redirect '/recipes'
        end
      end

      post '/signup' do
        if params[:username].empty? || params[:email].empty? || params[:password].empty?
          erb :'/users/create_user', locals: {message: 'All fields required.'}
        else
          @user = User.new(username: params[:username], email: params[:email], password: params[:password])
          @user.save
          session[:id] = @user.id

          redirect '/recipes'
        end
      end

      get '/login' do
        if !session[:id]
          erb :'/users/login'
        else
          redirect '/recipes'
        end
      end

      post '/login' do
        user = User.find_by(username: params[:username])
        if user && user.authenticate(params[:password])
          session[:id] = user[:id]
          redirect '/tweets'
        else
          erb :'/users/login', locals: {message: "Incorrect Username/Password"}
        end
      end

      get '/logout' do
        if session[:id] != nil
          session.destroy
          redirect '/login'
        else
          redirect '/'
        end
      end

    end
  ```
  * The ingredient controller, which handles the CRUD operations, and is very similar to the recipe controller:
  ```
    `class IngredientController < ApplicationController

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
  ```
* Something to note is `layout.erb`, in which I placed the buttons relating to actions a user can take:
```
  <!DOCTYPE html>
  <html>
    <head>
    </head>
    <body>
      <% if !session[:id] %>
        <a href="/signup">Sign Up</a>
        <a href="/login">Login</a>
      <% else %>
        <a href="/logout">Log Out</a>
      <% end %>

      <a href="/recipes">All Recipes</a>
      <a href="/ingredients">All Ingredients</a>

      <%= yield %>
    </body>

  </html>
```
