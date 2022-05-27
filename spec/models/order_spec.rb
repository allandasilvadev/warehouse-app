require 'rails_helper'
RSpec.describe Order, type: :model do
  describe '#valid?' do
    it 'deve ter um código' do
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

      order = Order.new(
        user: user,
        warehouse: warehouse,
        supplier: supplier,
        estimated_delivery_date: '2022-10-01'
      )

      # Act
      res = order.valid?

      # Assert
      expect(res).to be true
    end

    it 'data estimada de entrega deve ser obrigatória' do
      # Arrange
      order = Order.new(estimated_delivery_date: '')

      # Act
      order.valid?

      # Assert
      expect(order.errors.include? :estimated_delivery_date).to be true
    end

    it 'data estimada de entrega não deve ser anterior a data atual' do
      # Arrange
      order = Order.new(estimated_delivery_date: 1.day.ago)
      # Act
      order.valid?
      # Assert
      expect(order.errors.include? :estimated_delivery_date).to be true
      expect(order.errors[:estimated_delivery_date]).to include(' deve ser futura')
    end

    it 'data estimada de entrega não deve ser hoje' do
      # Arrange
      order = Order.new(estimated_delivery_date: Date.today)
      # Act
      order.valid?
      # Assert
      expect(order.errors.include? :estimated_delivery_date).to be true
      expect(order.errors[:estimated_delivery_date]).to include(' deve ser futura')
    end

    it 'data estimada de entrega deve ser igual ou maior que amanhã' do
      # Arrange
      order = Order.new(estimated_delivery_date: 1.day.from_now)
      # Act
      order.valid?
      # Assert
      expect(order.errors.include? :estimated_delivery_date).to be false
    end
  end

  describe 'gera um código aleatório' do
    it 'ao criar um novo pedido' do
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

      order = Order.new(
        user: user,
        warehouse: warehouse,
        supplier: supplier,
        estimated_delivery_date: '2022-10-01'
      )

      # Act
      order.save!
      res = order.code
      # Assert
      expect(res).not_to be_empty
      expect(res.length).to eq 8
    end

    it 'e o código é único' do
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

      first_order = Order.create!(
        user: user,
        warehouse: warehouse,
        supplier: supplier,
        estimated_delivery_date: '2022-10-01'
      )

      second_order = Order.new(
        user: user,
        warehouse: warehouse,
        supplier: supplier,
        estimated_delivery_date: '2022-06-01'
      )

      # Act
      second_order.save!

      # Assert
      expect(second_order.code).not_to eq first_order.code
    end
  end
end