require 'rails_helper'

RSpec.describe Warehouse, type: :model do
  describe '#valid?' do
    context 'presence' do
      it 'false when name is empty' do
        # Arrange
        warehouse = Warehouse.new(name: '', code: 'Rio', address: 'Av. Principal, 200', cep: '26000-000', city: 'Rio', area: 1000, description: 'Galpão do Rio')

        # Act
        response = warehouse.valid?

        # Assert
        expect(response).to eq false
      end
    end

    context 'unique' do
      it 'false when code is already in use' do
        # Arrange
        first_warehouse = Warehouse.create(name: 'Rio', code: 'Rio', address: 'Av. Principal, 200', cep: '26000-000', city: 'Rio', area: 1000, description: 'Galpão do Rio')
        second_warehouse = Warehouse.new(name: 'Maceio', code: 'Rio', address: 'Av. Maritima, 200', cep: '52000-000', city: 'Maceio', area: 20000, description: 'Galpão de Maceio')

        # Act
        response = second_warehouse.valid?

        # Assert
        expect(response).to eq false
      end
    end
  end
end
