class CardsController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :set_card, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  def show
      @card = Card.find(params[:id])
  end

  def index
    @cards = current_user.cards
  end

  def edit
    @cards = Card.find(params[:id])
  end

  def update
      @cards = Card.find(params[:id])
      if @cards.swimlane.board.user == current_user
        @cards.update(card_params)
      end
      respond_to :html, :js
  end

  def create
    @card = Card.new(card_params)
	  @card.user_id = current_user.id if current_user
    @card.save!
    render :json => @card
  end

  def new
    @card = Card.new
  end

  def destroy
    @card.destroy
  end

   private

    def set_card
      @card = Card.find(params[:id])
    end

   def card_params
      params.require(:card).permit(:swimlane_id, :company, :title, :logo, :url, :salary, :description, :location, :user)
   end
end
