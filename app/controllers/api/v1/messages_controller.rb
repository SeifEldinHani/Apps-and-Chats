class Api::V1::MessagesController < ApplicationController

    def index

        if request.headers["token"] == nil
            render json: {message:  "Please provide a app token"} , status: 400
            return             
        end

        if params[:query].present?              #Elasticsearch searching
            query = {
                "body" => params[:query],
                "app_token" => request.headers["token"],
                "chat_number" =>params[:chat_number]
            }
            @messages = Message.search(query)

            
        else                                        #Getting messages for a given chat number and 
            @messages = Message.where(app_token: request.headers["token"], chat_number: params[:chat_number])
        end

        if @messages.empty?                         #Return meaningful message when nth is returned
            render json: { "Message": "Didn't find data for given parameters" }, status: 404
        else
            render json: @messages.to_json(except: :id)
        end
    end

    def create

        if request.headers["token"] == nil
            render json: {message:  "Please provide a app token"} , status: 400
            return             
        end

        begin
            if app_params[:chat_number].present?
                @chat = Chat.find_by!(app_token: request.headers["token"], chat_number: app_params[:chat_number])
            else render json: {message:  "Please provide a chat number "} , status: 400
                return 
            end 

        rescue ActionController::ParameterMissing => e
                render json: {message:  e} , status: 400
            return             
        end
        parameters = {
            "message_number" => get_message_number(app_params[:chat_number] ,request.headers["token"]),
            "body" => app_params[:body],
            "app_token" => request.headers["token"],
            "chat_number" =>app_params[:chat_number]
        }

        @message = Message.new(parameters)
        if @message.valid? 
            @chat.messages_count = increment_message_count(app_params[:chat_number] , request.headers["token"])
            Publisher.publish("message", @message)
            @chat.save
            render json: { "message_number": @message.message_number }, status: 200

        else
            render json: { "Message": "Invalid input to create message" }, status: 400
        end  
    end

    def show
        if request.headers["token"] == nil
            render json: {message:  "Please provide a app token"} , status: 400
            return             
        end
        
        begin
        @message = Message.where(app_token: request.headers["token"] , chat_number: params[:chat_number] , message_number: params[:id])
        rescue ActiveRecord::RecordNotFound => e
            render json: {message:  "Message isn't found"} , status: 400
            return             
        end
        render json: @message.to_json(except: :id)
    end


    def app_params
        params.require(:message).permit(:chat_number , :body, :id , :query)
    end


    def get_message_number(chat_number , app_token)
        $redis.incr("message_number_#{chat_number}_#{app_token}")
    
    end

    def increment_message_count(chat_number , app_token)
        $redis.incr("message_count_#{chat_number}_#{app_token}")
    end

end

