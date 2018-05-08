class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy]

  # /products
  # /products.json?producer=&page=1
  def index
    if params[:producer].present?
      @producer = params[:producer]
      @products = Product.where(producer: @producer).paginate(:page => params[:page])
    else
      @products = Product.paginate(:page => params[:page])
    end
  end

  # /products/update_from_csv
  def update_from_csv
    # this action performs the import function manually
    t_start = Time.now
    Product.update_from_csv()
    t_end = Time.now
    render text: "Done in #{t_end - t_start} secs"
  end



# not relevent for the challenge
  def show
  end

  def new
    @product = Product.new
  end

  def edit
  end

  def create
    @product = Product.new(product_params)

    respond_to do |format|
      if @product.save
        format.html { redirect_to @product, notice: 'Product was successfully created.' }
        format.json { render :show, status: :created, location: @product }
      else
        format.html { render :new }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to @product, notice: 'Product was successfully updated.' }
        format.json { render :show, status: :ok, location: @product }
      else
        format.html { render :edit }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @product.destroy
    respond_to do |format|
      format.html { redirect_to products_url, notice: 'Product was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def product_params
      params.require(:product).permit(:name, :sku, :barcode, :photo_url, :producer, :price)
    end
end
