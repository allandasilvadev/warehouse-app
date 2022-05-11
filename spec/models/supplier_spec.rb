require 'rails_helper'

RSpec.describe Supplier, type: :model do
  describe '#valid?' do
    context 'presence' do
      it 'false when name is empty' do
        # Arrange
        supplier = Supplier.new(
          corporate_name: '',
          brand_name: 'ACME',
          registration_number: '2486284845',
          full_address: 'Rua das Palmas, 248',
          city: 'Bauru',
          state: 'SP',
          email: 'vendas@acme.com'
        )

        # Act
        response = supplier.valid?

        # Assert
        expect(response).to eq false
      end
    end

    context 'unique' do
      it 'false when code is already in use' do
        # Arrange
        first_supplier = Supplier.create(
          corporate_name: 'ACME LTDA',
          brand_name: 'ACME',
          registration_number: '2486284845',
          full_address: 'Rua das Palmas, 248',
          city: 'Bauru',
          state: 'SP',
          email: 'vendas@acme.com'
        )
        second_supplier = Supplier.new(
          corporate_name: 'Baby Soft LTDA',
          brand_name: 'BabySoft',
          registration_number: '2486284845',
          full_address: 'Rua das Palmas, 139',
          city: 'Belo Horizonte',
          state: 'MG',
          email: 'vendas@babysoft.com'
        )

        # Act
        response = second_supplier.valid?

        # Assert
        expect(response).to eq false
      end
    end
  end
end
