class Api::V1::AppsController < ApplicationController

    # POST /apps
    def create
        begin
            app_name = app_params[:name]
        rescue ActionController::ParameterMissing => e
            render json: {message:  e} , status: 400
        return     
        end
        app_token = app_name + "_token"
        chat_count = 0 
        @app = App.new({"name" => app_name , "app_token" => app_token , "chat_count" => chat_count})

        begin
            @app.save
            render json: {"app_token" => app_token}

        rescue ActiveRecord::RecordNotUnique => e
            render json: { message: 'App with provided name already exists' }, status: 400
            return
        end

    end

    def app_params
        params.require(:app).permit(:name)
    end

end



