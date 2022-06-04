require 'rails_helper'

RSpec.describe StockProduct, type: :model do
	describe 'gera um número de série' do
		it 'ao criar um StockProduct' do
			# Arrange
			user = User.create!(name: 'Maria', email: 'maria@email.com', password: '1234656')

      warehouse = Warehouse.create!(
        name: 'Galpão Rio',
        code: 'RIO',
        address: 'Av. do Aeroporto, 5000',
        cep: '25000-000',
        city: 'RIO',
        area: 1000,
        description: 'Galpãp do Rio de Janeiro'
      )

      supplier = Supplier.create!(
        corporate_name: 'ACME LTDA',
        brand_name: 'ACME',
        registration_number: '2486284845486',
        full_address: 'Rua das Palmas, 248',
        city: 'Bauru',
        state: 'SP',
        email: 'vendas@acme.com'
      )

      order = Order.create!(
        user: user,
        warehouse: warehouse,
        supplier: supplier,
        status: :delivered,
        estimated_delivery_date: 1.week.from_now
      )

     product = ProductModel.create!(
			name: 'SoundBar 7.1 Surrond', 
			weight: 3000, 
			width: 80, 
			height: 15, 
			depth: 20, 
			sku: 'SOU71-SAMSU-NOISE123', 
			supplier: supplier
		)

      # Act
      stock_product = StockProduct.create!(order: order, warehouse: warehouse, product_model: product)

      # Assert
      expect(stock_product.serial_number.length).to eq 20
		end

		it 'e não é modificado' do
			# Arrange
			user = User.create!(name: 'Maria', email: 'maria@email.com', password: '1234656')

      warehouse = Warehouse.create!(
        name: 'Galpão Rio',
        code: 'RIO',
        address: 'Av. do Aeroporto, 5000',
        cep: '25000-000',
        city: 'RIO',
        area: 1000,
        description: 'Galpãp do Rio de Janeiro'
      )

      second_warehouse = Warehouse.create!(
        name: 'Aeroporto SP',
        code: 'GRU',
        address: 'Av. das Nações, 4000',
        cep: '92000-000',
        city: 'SP',
        area: 10_000,
        description: 'Galpão destinado a cargas internacionais.'
      )

      supplier = Supplier.create!(
        corporate_name: 'ACME LTDA',
        brand_name: 'ACME',
        registration_number: '2486284845486',
        full_address: 'Rua das Palmas, 248',
        city: 'Bauru',
        state: 'SP',
        email: 'vendas@acme.com'
      )

      product = ProductModel.create!(
				name: 'SoundBar 7.1 Surrond', 
				weight: 3000, 
				width: 80, 
				height: 15, 
				depth: 20, 
				sku: 'SOU71-SAMSU-NOISE123', 
				supplier: supplier
			)

      order = Order.create!(
        user: user,
        warehouse: warehouse,
        supplier: supplier,
        status: :delivered,
        estimated_delivery_date: 1.week.from_now
      )

      stock_product = StockProduct.create!(order: order, warehouse: warehouse, product_model: product)
      original_serial_number = stock_product.serial_number
      
      # Act
      stock_product.update( warehouse: second_warehouse )

      # Assert
      expect(stock_product.serial_number).to eq original_serial_number
		end
	end

  describe '#available' do
    it 'true se não tiver destino' do
      # Arrange
      user = User.create!(name: 'Maria', email: 'maria@email.com', password: '1234656')

      warehouse = Warehouse.create!(
        name: 'Galpão Rio',
        code: 'RIO',
        address: 'Av. do Aeroporto, 5000',
        cep: '25000-000',
        city: 'RIO',
        area: 1000,
        description: 'Galpãp do Rio de Janeiro'
      )

      supplier = Supplier.create!(
        corporate_name: 'ACME LTDA',
        brand_name: 'ACME',
        registration_number: '2486284845486',
        full_address: 'Rua das Palmas, 248',
        city: 'Bauru',
        state: 'SP',
        email: 'vendas@acme.com'
      )

      product = ProductModel.create!(
        name: 'SoundBar 7.1 Surrond', 
        weight: 3000, 
        width: 80, 
        height: 15, 
        depth: 20, 
        sku: 'SOU71-SAMSU-NOISE123', 
        supplier: supplier
      )

      order = Order.create!(
        user: user,
        warehouse: warehouse,
        supplier: supplier,
        status: :delivered,
        estimated_delivery_date: 1.week.from_now
      )

      # Act
      stock_product = StockProduct.create!(order: order, warehouse: warehouse, product_model: product)
      
      # Assert
      expect(stock_product.available?).to eq true
    end

    it 'false se tiver destino' do
      # Arrange
      user = User.create!(name: 'Maria', email: 'maria@email.com', password: '1234656')

      warehouse = Warehouse.create!(
        name: 'Galpão Rio',
        code: 'RIO',
        address: 'Av. do Aeroporto, 5000',
        cep: '25000-000',
        city: 'RIO',
        area: 1000,
        description: 'Galpãp do Rio de Janeiro'
      )

      supplier = Supplier.create!(
        corporate_name: 'ACME LTDA',
        brand_name: 'ACME',
        registration_number: '2486284845486',
        full_address: 'Rua das Palmas, 248',
        city: 'Bauru',
        state: 'SP',
        email: 'vendas@acme.com'
      )

      product = ProductModel.create!(
        name: 'SoundBar 7.1 Surrond', 
        weight: 3000, 
        width: 80, 
        height: 15, 
        depth: 20, 
        sku: 'SOU71-SAMSU-NOISE123', 
        supplier: supplier
      )

      order = Order.create!(
        user: user,
        warehouse: warehouse,
        supplier: supplier,
        status: :delivered,
        estimated_delivery_date: 1.week.from_now
      )

      # Act
      stock_product = StockProduct.create!(order: order, warehouse: warehouse, product_model: product)
      stock_product.create_stock_product_destination!(recipient: 'João', address: 'Ruas das Flores, 2400 - Campinas - SP')

      # Assert
      expect(stock_product.available?).to eq false
    end
  end
end
