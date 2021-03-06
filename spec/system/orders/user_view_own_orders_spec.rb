require 'rails_helper'
describe 'Usuário vê seus próprios pedidos' do
  it 'e deve estar autenticado' do
    # Arrange
    # Act
    visit root_path
    click_on 'Meus Pedidos'
    # Assert
    expect(current_path).to eq new_user_session_path
  end

  it 'e não vê outros pedidos' do
    # Arrange
    joao = User.create!(name:'João', email: 'joao@email.com', password: '123456')
    maria = User.create!(name:'Maria', email: 'maria@email.com', password: '123456')

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

    first_order = Order.create!(
        user: joao,
        warehouse: warehouse,
        supplier: supplier,
        estimated_delivery_date: 1.day.from_now,
        status: 'pending'
    )

    second_order = Order.create!(
        user: maria,
        warehouse: warehouse,
        supplier: supplier,
        estimated_delivery_date: 1.day.from_now,
        status: 'delivered'
    )

    third_order = Order.create!(
        user: joao,
        warehouse: warehouse,
        supplier: supplier,
        estimated_delivery_date: 1.week.from_now,
        status: 'canceled'
    )
    # Act
    login_as(joao)
    visit root_path
    click_on 'Meus Pedidos'
    # Assert
    expect(page).to have_content first_order.code
    expect(page).to have_content 'Pendente'
    expect(page).not_to have_content second_order.code
    expect(page).not_to have_content 'Entregue'
    expect(page).to have_content third_order.code
    expect(page).to have_content 'Cancelado'
  end

  it 'e visita um pedido' do
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
        estimated_delivery_date: 1.day.from_now
    )

    # Act
    login_as(user)
    visit root_path
    click_on 'Meus Pedidos'
    click_on order.code

    # Assert
    expect(page).to have_content 'Detalhes do pedido'
    expect(page).to have_content 'Galpão destino: GRU | Aeroporto SP'
    expect(page).to have_content 'Fornecedor: ACME LTDA'
    formatted_date = I18n.localize(1.day.from_now.to_date)
    expect(page).to have_content "Data prevista de entrega: #{formatted_date}"
  end

  it 'e não visita pedidos de outros usuários' do
    # Arrange
    user = User.create!(name:'João', email: 'joao@email.com', password: '123456')
    maria = User.create!(name: 'Maria', email: 'maria@email.com', password: '123456')

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
    first_order = Order.create!(
        user: user,
        warehouse: warehouse,
        supplier: supplier,
        estimated_delivery_date: 1.day.from_now
    )

    second_order = Order.create!(
      user: maria,
      warehouse: warehouse,
      supplier: supplier,
      estimated_delivery_date: 1.day.from_now
  )

  third_order = Order.create!(
    user: user,
    warehouse: warehouse,
    supplier: supplier,
    estimated_delivery_date: 1.day.from_now
)

    # Act
    login_as(maria)
    visit order_path( first_order.id )

    # Assert
    expect(current_path).not_to eq order_path( first_order.id )
    expect(current_path).to eq root_path
    expect(page).to have_content 'Você não possui acesso a esse pedido.'
  end

  it 'e vê itens do pedido' do
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

    OrderItem.create!(product_model: proda, order: order, quantity: 20 )
    OrderItem.create!(product_model: prodc, order: order, quantity: 12 )

    # Act
    login_as(user)
    visit root_path
    click_on 'Meus Pedidos'
    click_on order.code

    # Assert
    expect(page).to have_content 'Itens do pedido'
    expect(page).to have_content '20 x TV 32'
    expect(page).to have_content '12 x TV Colorida 20 polegadas'
  end
end