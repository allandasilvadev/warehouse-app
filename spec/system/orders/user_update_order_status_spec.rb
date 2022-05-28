require 'rails_helper'

describe 'Usuário informa novo status do pedido' do
  it 'e o pedido foi entregue' do
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
        status: :pending
    )

    # Act
    login_as(user)
    visit root_path
    click_on 'Meus Pedidos'
    click_on order.code
    click_on 'Marcar como entregue'

    # Assert
    expect(current_path).to eq order_path( order.id )
    expect(page).to have_content 'Status do pedido: Entregue'
    expect(page).not_to have_button 'Marcar como entregue'
    expect(page).not_to have_button 'Marcar como cancelado'
  end
  it 'e o pedido foi cancelado' do
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
        status: :pending
    )

    # Act
    login_as(user)
    visit root_path
    click_on 'Meus Pedidos'
    click_on order.code
    click_on 'Marcar como cancelado'

    # Assert
    expect(current_path).to eq order_path( order.id )
    expect(page).to have_content 'Status do pedido: Cancelado'
  end
end