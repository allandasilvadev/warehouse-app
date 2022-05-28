require 'rails_helper'
describe 'Usuário busca por um pedido' do
  it 'e deve estar autenticado' do
    # Arrange
    user = User.create!(name:'João', email: 'joao@email.com', password: '123456')
    # Act
    login_as(user)
    visit root_path
    # Assert
    within('header nav') do
        expect(page).to have_field('Buscar pedido')
        expect(page).to have_button('Buscar')
    end    
  end

  it 'a partir do menu' do
    # Arrage
    # Act
    visit root_path
    # Assert
    within('header nav') do
       expect(page).not_to have_field('Buscar pedido')
       expect(page).not_to have_button('Buscar')
    end    
  end

  it 'e encontra um pedido' do
    # Arrange
    user = User.create!(name:'João', email: 'joao@email.com', password: '123456')
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
        estimated_delivery_date: 1.day.from_now
    )


    # Act
    login_as(user)
    visit root_path
    fill_in 'Buscar pedido', with: order.code
    click_on 'Buscar'
    # Assert
    expect(page).to have_content "Resultados da busca por: #{order.code}"
    expect(page).to have_content '1 pedido encontrado'
    expect(page).to have_content "Código: #{order.code}"
    expect(page).to have_content "Galpão destino: RIO | Galpão Rio"
    expect(page).to have_content "Fornecedor: ACME LTDA"

  end

  it 'e encontra múltiplos pedidos' do
    # Arrange
    user = User.create!(name:'João', email: 'joao@email.com', password: '123456')

    wsp = Warehouse.new(
      name: 'Aeroporto SP', 
      code: 'GRU', 
      city: 'Guarulhos', 
      area: 100_000, 
      address: 'Avenida do Aeroporto, 1000',
      cep: '15000-000',
      description: 'Galpão destinado para cargas internacionais'
    )

    wrio = Warehouse.create!(
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

    allow(SecureRandom).to receive(:alphanumeric).with(8).and_return('GRU12345')
    A_order = Order.create!(
        user: user,
        warehouse: wsp,
        supplier: supplier,
        estimated_delivery_date: 1.day.from_now
    )

    allow(SecureRandom).to receive(:alphanumeric).with(8).and_return('GRU67891')
    B_order = Order.create!(
      user: user,
      warehouse: wsp,
      supplier: supplier,
      estimated_delivery_date: 2.day.from_now
  )

  allow(SecureRandom).to receive(:alphanumeric).with(8).and_return('RIO12345')
  C_order = Order.create!(
    user: user,
    warehouse: wrio,
    supplier: supplier,
    estimated_delivery_date: 6.day.from_now
  )

    # Act
    login_as(user)
    visit root_path
    fill_in 'Buscar pedido', with: 'GRU'
    click_on 'Buscar'
    # Assert
    expect(page).to have_content '2 pedidos encontrados.'
    expect(page).to have_content 'GRU12345'
    expect(page).to have_content 'GRU67891'
    expect(page).to have_content 'Galpão destino: GRU | Aeroporto SP'
    expect(page).not_to have_content 'RIO12345'
    expect(page).not_to have_content 'Galpão destino: RIO | Galpão Rio'
  end
end