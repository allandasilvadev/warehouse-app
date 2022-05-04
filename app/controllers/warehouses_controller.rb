class WarehousesController < ApplicationController
  def show
  	id = params[:id]
  	@warehouse = Warehouse.find(id)
  end

  def new
  end

  def create
    # strong parameters
    warehouse_params = params.require(:warehouse).permit(:name, :code, :city, :description, :address, :cep, :area)
    w = Warehouse.new( warehouse_params )
    w.save()
    redirect_to root_path
  end
end