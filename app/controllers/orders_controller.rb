class OrdersController < ApplicationController
    before_action :authenticate_user!
    # before_action :set_order_and_check_user, only: [:show, :edit, :update, :delivered, :canceled]
    def index
        @orders = current_user.orders
    end

    def new
        @order = Order.new
        @warehouses = Warehouse.all
        @suppliers = Supplier.all
    end

    def create
        order_params = params.require(:order).permit(:warehouse_id, :supplier_id, :estimated_delivery_date)
        @order = Order.new( order_params )
        @order.user = current_user
        @order.save!
        redirect_to @order, notice: 'Pedido registrado com sucesso.'
    end

    def show
        @order = Order.find(params[:id])
        if @order.user != current_user
            return redirect_to root_path, alert: 'Você não possui acesso a esse pedido.'
        end
    end

    def search
        @code = params[:query]
        # @order = Order.find_by(code: @code)
        @orders = Order.where("code LIKE ?", "%#{@code}%") 
    end

    def edit
        @order = Order.find(params[:id])
        if @order.user != current_user
            return redirect_to root_path
        end
        @warehouses = Warehouse.all
        @suppliers = Supplier.all
    end

    def update
        order_params = params.require(:order).permit(:warehouse_id, :supplier_id, :estimated_delivery_date)
        @order = Order.find(params[:id])
        if @order.user != current_user
            return redirect_to root_path
        end
        @order.update(order_params)
        flash[:notice] = 'Pedido atualizado com sucesso.'
        redirect_to order_path( @order.id )
        # redirect_to @order, notice: 'Pedido atualizado com sucesso.'
    end

    def delivered
        @order = Order.find(params[:id])
        @order.order_items.each do |item|
            item.quantity.times do
                StockProduct.create!(order: @order, product_model: item.product_model, warehouse: @order.warehouse)
            end
        end
        if @order.user != current_user
            return redirect_to root_path
        end
        # @order.update(status: :delivered)
        @order.delivered!
        redirect_to @order
    end

    def canceled
        @order = Order.find(params[:id])
        if @order.user != current_user
            return redirect_to root_path
        end
        # @order.update(status: :canceled)
        @order.canceled!
        redirect_to @order
    end

    private
    
    def set_order_and_check_user
        @order = Order.find(params[:id])
        if @order.user != current_user
            return redirect_to root_path
        end
    end

end