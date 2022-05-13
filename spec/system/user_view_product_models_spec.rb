require 'rails_helper'

describe 'Usuário vê modelos de produtos' do
	it 'a partir do menu' do
		# Arrange

		# Act
		visit root_path
		within('nav') do
			click_on 'Modelos de Produtos'
		end

		# Assert
		expect(current_path).to eq product_models_path
	end

	it 'com sucesso' do
		# Arrange
		supplier = Supplier.create!(
			corporate_name: 'Sansung Eletronicos LTDA',
			brand_name: 'Sansung',
			registration_number: '2482564875123',
			full_address: 'Av. das Nações Unidas, 100',
			city: 'Bauru',
			state: 'SP',
			email: 'vendas@sansung.com'
		)

		# para uma tela de listagem o indicado e criar ao menos dois produtos
		ProductModel.create!(
			name: 'TV 32', 
			weight: 8000, 
			width: 70, 
			height: 45, 
			depth: 10, 
			sku: 'TV32-SAMSU-XPTO90123', 
			supplier: supplier
		)

		ProductModel.create!(
			name: 'SoundBar 7.1 Surrond', 
			weight: 3000, 
			width: 80, 
			height: 15, 
			depth: 20, 
			sku: 'SOU71-SAMSU-NOISE123', 
			supplier: supplier
		)

		# Act
		visit root_path
		within('nav') do
			click_on 'Modelos de Produtos'
		end

		# Assert
		expect(page).to have_content 'TV 32'
		expect(page).to have_content 'TV32-SAMSU-XPTO90123'
		expect(page).to have_content 'Sansung'
		expect(page).to have_content 'SoundBar 7.1 Surrond'
		expect(page).to have_content 'SOU71-SAMSU-NOISE123'
		expect(page).to have_content 'Sansung'
	end

	it 'e não existem produtos cadastrados' do
		# Arrange

		# Act
		visit root_path
		click_on 'Modelos de Produtos'

		# Assert
		expect(page).to have_content 'Nenhum modelo de produto cadastrado.'
	end
end