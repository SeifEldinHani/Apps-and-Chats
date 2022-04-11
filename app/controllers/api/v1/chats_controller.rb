class Api::V1::ChatsController < ApplicationController



    def index   # Show all chats of a given app (Showcasing only chat numbers)
        if request.headers["token"] == nil
            render json: {message:  "Please provide a app token"} , status: 400
            return             
        end

        begin               #Check whether there's an app with the provided token 
            @app = App.find_by!(app_token: request.headers["token"])
        rescue ActiveRecord::RecordNotFound => e
            render json: {message:  "App with provided token isn't found"} , status: 404
            return             

        end

        @chats = Chat.where(app_token: request.headers["token"])

        if @chats.empty?
            render json: { "Message": "Didn't find data for given parameters" }, status: 404
        else
            render json: @chats.to_json(except: :id)
        end
        
    end


    def create

        if request.headers["token"] == nil
            render json: {message:  "Please provide a app token"} , status: 400
            return             
        end
        begin
            @app = App.find_by!(app_token: request.headers["token"])
        rescue ActiveRecord::RecordNotFound => e
            render json: {message:  "App with provided token isn't found"} , status: 404
            return             

        end

        chat_number = get_chat_number(request.headers["token"])
        params = {
            "app_token" =>  request.headers["token"],
            "chat_number" => chat_number,
            "messages_count" => 0
        }

        @chat = Chat.new(params)

        Publisher.publish("chat", @chat)
        @app.chat_count = increment_chats_count(request.headers["token"])
        @app.save

        render json: { "chat_number": chat_number }, status: 200
    end


    def get_chat_number(app_token)
        $redis.incr("chat_number_#{app_token}")
    
    end

    def increment_chats_count(app_token)
        $redis.incr("chat_count_#{app_token}")
    
    end

end