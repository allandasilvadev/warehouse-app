require 'rails_helper'

describe 'Usuário vê estoque' do
	it 'na tela do galpão' do
		# Arrange
		user = User.create!(name:'João', email: 'joao@email.com', password: '123456')

    warehouse = Warehouse.new(
       name: 'Aeroporto SP', 
       code: 'GRU', 
       city: 'Guarulhos', 
       area: 100_000, 
       address: 'Avenida do Aeroporto, 1000',
       cep: '15000-000',
       description: 'Galpão destinado para cargas internacionais'
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
        estimated_delivery_date: 1.day.from_now,
        status: :delivered
    )

    produto_tv = ProductModel.create!(
			name: 'TV 32', 
			weight: 8000, 
			width: 70, 
			height: 45, 
			depth: 10, 
			sku: 'TV32-SAMSU-XPTO90123', 
			supplier: supplier
		)

		produto_soundbar = ProductModel.create!(
			name: 'SoundBar 7.1 Surrond', 
			weight: 3000, 
			width: 80, 
			height: 15, 
			depth: 20, 
			sku: 'SOU71-SAMSU-NOISE123', 
			supplier: supplier
		)

		produto_cadeira = ProductModel.create!(
			name: 'Cadeira Gamer', 
			weight: 3000, 
			width: 80, 
			height: 15, 
			depth: 20, 
			sku: 'CAD71-SAMSU-NOISE123', 
			supplier: supplier
		)

		3.times { StockProduct.create!( order: order, warehouse: warehouse, product_model: produto_tv ) }
		2.times { StockProduct.create!( order: order, warehouse: warehouse, product_model: produto_cadeira ) }

		# Act
		login_as user
		visit root_path
		click_on 'Aeroporto SP'
		# Assert
		expect(page).to have_content 'Itens em estoque:'
		expect(page).to have_content '3 x TV32-SAMSU-XPTO90123'
		expect(page).to have_content '2 x CAD71-SAMSU-NOISE123'
		expect(page).not_to have_content 'SOU71-SAMSU-NOISE123'
	end
end