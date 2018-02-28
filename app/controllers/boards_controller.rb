class BoardsController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  before_filter :find_board, :only => [:index]

  def show
	  if params[:id] == 'last' && current_user.boards.last
		  redirect_to board_path(current_user.boards.last)
	  elsif params[:id] == 'last'
		  redirect_to new_board_path 
	  else
      find_board
	  end
  end

  def index
    @boards = current_user.boards
  end

  def sort
    params[:order].each do |key,value|
      Card.find(value[:id]).update_attribute(:position,value[:position])
      Card.find(value[:id]).update_attribute(:swimlane_id,value[:swimlane_id])
    end
    render :nothing => true
  end

  def create
    @board = Board.new(board_params)
    @board.user = current_user
    @board.save!
    redirect_to boards_path
  end

  def new
    @board = Board.new
  end

   private

   def board_params
      params.require(:board).permit(:name)
   end

  def find_board
    unless params[:id].blank?
      @board = Board.find(params[:id])
      redirect_to 404 if current_user.id != @board.user.id
    end
  end
end
