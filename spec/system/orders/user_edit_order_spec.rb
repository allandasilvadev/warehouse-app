require 'rails_helper'

describe 'Usuário edita pedido' do
  it 'e deve estar autenticado' do
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
    visit edit_order_path( order.id )

    # Assert
    expect(current_path).to eq new_user_session_path
  end

  it 'com sucesso' do
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

    Supplier.create!(
      corporate_name: 'Star LTDA',
      brand_name: 'Star',
      registration_number: '2486284845468',
      full_address: 'Rua das Nações, 1400',
      city: 'Limeira',
      state: 'SP',
      email: 'contact@star.com'
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
    click_on 'Editar'
    fill_in 'Data prevista de entrega', with: '12/12/2022'
    select 'Star LTDA', from: 'Fornecedor'
    click_on 'Gravar'

    # Assert
    expect(page).to have_content 'Pedido atualizado com sucesso.'
    expect(page).to have_content 'Fornecedor: Star LTDA'
    expect(page).to have_content 'Data prevista de entrega: 12/12/2022'
  end

  it 'caso seja o responsável' do
    # Arrange
    joao = User.create!(name:'João', email: 'joao@email.com', password: '123456')
    andre = User.create!(name:'André', email: 'andre@email.com', password: '123456')

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
      user: joao,
      warehouse: warehouse,
      supplier: supplier,
      estimated_delivery_date: 1.day.from_now
    )

    # Act
    login_as(andre)
    visit edit_order_path( order.id )

    # Assert
    expect(current_path).to eq root_path
  end
end