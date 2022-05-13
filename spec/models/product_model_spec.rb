require 'rails_helper'

RSpec.describe ProductModel, type: :model do
  describe '#valid?' do
    before(:each) do
      @supplier = Supplier.new(
        corporate_name: 'Sansung Eletronicos LTDA',
        brand_name: 'Sansung',
        registration_number: '1234567897891',
        full_address: 'Rua das Palmas, 100',
        city: 'Bauru',
        state: 'SP',
        email: 'vendas@sansung.com'
      )
    end

    context 'presence' do
      it 'false when name is empty' do
        # Arrange
        pm = ProductModel.new(
          name: '', 
          weight: 8000, 
          width: 70, 
          height: 45, 
          depth: 10, 
          sku: 'TV32-SAMSU-XPTO90123', 
          supplier: @supplier
        )

        # Act
        response = pm.valid?

        # Assert
        expect(response).to eq false
      end
    end

    context 'unique' do
      it 'false when sku is already in use' do
        # Arrange
        tv = ProductModel.create(
          name: 'TV 32', 
          weight: 8000, 
          width: 70, 
          height: 45, 
          depth: 10, 
          sku: 'TV32-SAMSU-XPTO90123', 
          supplier: @supplier
        )

        dvd = ProductModel.new(
          name: 'DVD Player', 
          weight: 4000, 
          width: 160, 
          height: 25, 
          depth: 24, 
          sku: 'TV32-SAMSU-XPTO90123', 
          supplier: @supplier
        )

        # Act
        response = dvd.valid?

        # Assert
        expect(response).to eq false
      end
    end

    context 'valid' do
      it 'valido se peso maior que 0' do
        # Arrange
        pm = ProductModel.new(
          name: 'TV 32', 
          weight: 0, 
          width: 70, 
          height: 45, 
          depth: 10, 
          sku: 'TV32-SAMSU-XPTO90123', 
          supplier: @supplier
        )

        radio = ProductModel.new(
          name: 'Radio HD', 
          weight: -12, 
          width: 70, 
          height: 45, 
          depth: 10, 
          sku: 'RDAB-SAMSU-XPTO90123', 
          supplier: @supplier
        )

        # Act

        # Assert
        expect(pm.valid?).to eq false
        expect(radio.valid?).to eq false
      end

      it 'valido se altura maior que 0' do
        pm = ProductModel.new(
          name: 'TV 32', 
          weight: 26, 
          width: 70, 
          height: 0, 
          depth: 10, 
          sku: 'TV32-SAMSU-XPTO90123', 
          supplier: @supplier
        )

        radio = ProductModel.new(
          name: 'Radio HD', 
          weight: 42, 
          width: 70, 
          height: -8, 
          depth: 10, 
          sku: 'RDAB-SAMSU-XPTO90123', 
          supplier: @supplier
        )

        # Act

        # Assert
        expect(pm.valid?).to eq false
        expect(radio.valid?).to eq false
      end

      it 'valido se largura maior que 0' do
        pm = ProductModel.new(
          name: 'TV 32', 
          weight: 26, 
          width: 0, 
          height: 26, 
          depth: 10, 
          sku: 'TV32-SAMSU-XPTO90123', 
          supplier: @supplier
        )

        radio = ProductModel.new(
          name: 'Radio HD', 
          weight: 42, 
          width: -16, 
          height: 68, 
          depth: 10, 
          sku: 'RDAB-SAMSU-XPTO90123', 
          supplier: @supplier
        )

        # Act

        # Assert
        expect(pm.valid?).to eq false
        expect(radio.valid?).to eq false
      end
    end
  end
end
