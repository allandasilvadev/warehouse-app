require 'rails_helper'
describe 'Usuário adiciona itens ao pedido' do
  it 'com sucesso' do
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

    proda = ProductModel.create!(
			name: 'TV 32', 
			weight: 8000, 
			width: 70, 
			height: 45, 
			depth: 10, 
			sku: 'TV32-SAMSU-XPTO90123', 
			supplier: supplier
		)

		prodb = ProductModel.create!(
			name: 'SoundBar 7.1 Surrond', 
			weight: 3000, 
			width: 80, 
			height: 15, 
			depth: 20, 
			sku: 'SOU71-SAMSU-NOISE123', 
			supplier: supplier
		)

    prodc = ProductModel.create!(
			name: 'TV Colorida 20 polegadas', 
			weight: 10_000, 
			width: 80, 
			height: 15, 
			depth: 20, 
			sku: 'SOU71-SAMSU-NOISE111', 
			supplier: supplier
		)

    order = Order.create!(
        user: user,
        warehouse: warehouse,
        supplier: supplier,
        estimated_delivery_date: 1.day.from_now
    )
    # Act
    login_as(user)
    visit root_path
    click_on 'Meus Pedidos'
    click_on order.code
    click_on 'Adicionar item'
    select 'TV Colorida 20 polegadas', from: 'Produto'
    fill_in 'Quantidade', with: '8'
    click_on 'Gravar'
    # Assert
    expect(current_path).to eq order_path( order.id )
    expect(page).to have_content 'Item adicionado ao pedido com sucesso.'
    expect(page).to have_content '8 x TV Colorida 20 polegadas'
  end

  it 'e não vê produtos de outro fornecedor' do
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

      acme = Supplier.create!(
        corporate_name: 'ACME LTDA',
        brand_name: 'ACME',
        registration_number: '2486284845486',
        full_address: 'Rua das Palmas, 248',
        city: 'Bauru',
        state: 'SP',
        email: 'vendas@acme.com'
    )

    star = Supplier.create!(
      corporate_name: 'Star LTDA',
      brand_name: 'Star',
      registration_number: '2486284845427',
      full_address: 'Rua das Figueiras, 1600',
      city: 'Limeira',
      state: 'SP',
      email: 'vendas@star.com'
  )

    proda = ProductModel.create!(
			name: 'TV 32', 
			weight: 8000, 
			width: 70, 
			height: 45, 
			depth: 10, 
			sku: 'TV32-SAMSU-XPTO90123', 
			supplier: acme
		)

		prodb = ProductModel.create!(
			name: 'SoundBar 7.1 Surrond', 
			weight: 3000, 
			width: 80, 
			height: 15, 
			depth: 20, 
			sku: 'SOU71-SAMSU-NOISE123', 
			supplier: star
		)

    prodc = ProductModel.create!(
			name: 'TV Colorida 20 polegadas', 
			weight: 10_000, 
			width: 80, 
			height: 15, 
			depth: 20, 
			sku: 'SOU71-SAMSU-NOISE111', 
			supplier: acme
		)

    order = Order.create!(
        user: user,
        warehouse: warehouse,
        supplier: acme,
        estimated_delivery_date: 1.day.from_now
    )

    login_as(user)
    visit root_path
    click_on 'Meus Pedidos'
    click_on order.code
    click_on 'Adicionar item'

    # Assert
    expect(page).to have_content 'TV 32'
    expect(page).to have_content 'TV Colorida 20 polegadas'
    expect(page).not_to have_content 'SoundBar 7.1 Surrond'
  end
end