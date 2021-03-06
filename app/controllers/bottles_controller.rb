class BottlesController < ApplicationController

	def index
    @bottles = Bottle.all
  end

  def new
    @bottle = Bottle.new
    @review = Review.new
  end

  def create
    @bottle = Bottle.new(bottle_params)
    if current_user == nil
      @bottle.save
      redirect_to bottle_path(@bottle)
      flash[:notice] = "You just created #{@bottle.name}!"
    else
      @bottle.save
      @review = Review.new(review_params)
      @review.save
      @review.user = current_user
      @bottle.reviews << @review
      redirect_to bottle_path(@bottle)
      flash[:notice] = "You just created #{@bottle.name}!"
    end
  end

  def show
    if current_user == nil
      @bottle = Bottle.find(params[:id])
    else 
      @bottle = Bottle.find(params[:id])
      @review = @bottle.reviews
    end
  end
  
  def destroy
    @bottle = Bottle.find(params[:id])
    @bottle.destroy
    redirect_to bottles_path
  end

  # def remove
  #   b = Bottle.find(params[:id])
  #   @user = current_user
  #   @user.bottles.delete(b)
  #   redirect_to user_path(@user)
  #   # flash[:notice] = "Bottle has been removed"
  # end

  def edit
    if current_user == nil
      @bottle = Bottle.find(params[:id])
    else
      @bottle = Bottle.find(params[:id])
      @review = @bottle.reviews.where(user_id: current_user.id).take
    end
  end

  def update

      @bottle = Bottle.find(params[:id])
      @review = @bottle.reviews.where(user_id: current_user.id).take
      @bottle.update_attributes(bottle_params)
      @review.update_attributes(review_params)
      redirect_to bottle_path(@bottle)

  end

  def favorite
    @user = current_user
    

  end 

  protected

  def bottle_params
    params.require(:bottle).permit(:name, :grape, :vintage, :year, :winery, :description, :label_image, :more_url )
  end

  def review_params
    params.require(:review).permit(:user_id, :bottle_id, :my_rating, :comment, :favorite)
  end
end