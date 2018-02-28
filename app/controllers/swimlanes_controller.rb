class SwimlanesController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :authenticate_user!

  def index
    @swimlanes.order(:created_at)
  end

  def show
      @swimlane = Swimlane.find(params[:id])
  end

  def edit
    @swimlane = Swimlane.find(params[:id])
  end

  def update
      @swimlane = Swimlane.find(params[:id])
      @user = current_user
      if @user.id == @swimlane.board.user_id
        @swimlane.update(:name => params[:name])
      end
      respond_to do |format|
        format.json { head :ok }
      end
  end

  def new
    @board = current_user.boards.find(params[:board_id])
    @swimlane = Swimlane.new(:board_id => @board.id)
    @swimlane.save!

    if @swimlane.save
      swimlane = @swimlane
      render :partial => 'swimlanes/swimlane', :object => swimlane, :status => :created
    else
      head :unprocessable_entity
    end
  end

  def destroy
      @swimlane=Swimlane.find(params[:id])
      if @swimlane.destroy
		 head :ok
	  else
		  render json: @swimlane, status: :unprocessable_entity
	  end
  end

  def create

  end

end