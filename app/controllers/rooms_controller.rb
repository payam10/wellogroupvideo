class RoomsController < ApplicationController
	before_filter :config_opentok, except: [:index]

  def index
  	@rooms = Room.all 
  	@new_room = Room.new
  end

  def create
  	session = @opentok.create_session 
  	params[:room][:sessionId] = session.session_id

  	@new_room = Room.new(room_params)

  	# took out respond
  	if @new_room.save 
  		redirect_to("/wello/room/"+@new_room.id.to_s)
  	else
  		redirect_to root_path
  	end
  end

  def party
    @rooms = Room.order('created_at DESC')
  	@room = Room.find(params[:id])
  	# binding.pry
  	@tok_token = @opentok.generate_token @room.sessionId 
  	# binding.pry 
  end

  private
  def config_opentok
  	api_key = 45009462 # Replace with your OpenTok API key.
    api_secret = "13e77f5da3c67819f88962ee281cf44ff52d0612" # Replace with your OpenTok API secret.

    @opentok = OpenTok::OpenTok.new api_key, api_secret 
    session = @opentok.create_session :media_mode => :routed
    session_id = session.session_id
  end

  def room_params
  	params.require(:room).permit(:sessionId, :name)
  end
end
