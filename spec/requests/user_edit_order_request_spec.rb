require 'rails_helper'
describe 'Usuário edita um pedido' do
  it 'e não é o dono' do
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
    patch( order_path( order.id ), params: { order: { supplier_id: 3 } } )
    # Assert
    expect(response).to redirect_to root_path
  end
end