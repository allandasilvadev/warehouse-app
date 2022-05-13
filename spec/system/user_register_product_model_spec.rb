require 'rails_helper'

describe 'Usuário cadastra modelo de produto' do
	it 'com sucesso' do
		# Arrange
		supplier = Supplier.create!(
			corporate_name: 'Sansung Eletronicos LTDA',
			brand_name: 'Sansung',
			registration_number: '2484584256871',
			full_address: 'Rua das Palmas, 100',
			city: 'Bauru',
			state: 'SP',
			email: 'vendas@sansung.com.br'
		)

		other_supplier = Supplier.create!(
			corporate_name: 'LG LTDA',
			brand_name: 'LG',
			registration_number: '2484584256872',
			full_address: 'Rua das Palmas, 200',
			city: 'São Paulo',
			state: 'SP',
			email: 'vendas@lg.com.br'
		)

		# Act
		visit root_path
		click_on 'Modelos de Produtos'
		click_on 'Cadastrar Novo'
		fill_in 'Nome', with: 'TV 40 polegadas'
		fill_in 'Peso', with: 10_000
		fill_in 'Altura', with: 60
		fill_in 'Largura', with: 40
		fill_in 'Profundidade', with: 10
		fill_in 'SKU', with: 'TV40-SAMSU-123456842'
		select 'LG', from: 'Fornecedor'

		click_on 'Enviar'

		# Assert
		expect(page).to have_content 'Modelo de produto cadastrado com sucesso.'
		expect(page).to have_content 'TV 40 polegadas'
		expect(page).to have_content 'Fornecedor: LG'
		expect(page).to have_content 'TV40-SAMSU-123456842'
		expect(page).to have_content 'Dimensões: 60cm X 40cm X 10cm'
		expect(page).to have_content 'Peso: 10000g'
	end

	it 'deve preencher todos os campos' do
		# Arrange
		supplier = Supplier.create!(
			corporate_name: 'Sansung Eletronicos LTDA',
			brand_name: 'Sansung',
			registration_number: '2484584256871',
			full_address: 'Rua das Palmas, 100',
			city: 'Bauru',
			state: 'SP',
			email: 'vendas@sansung.com.br'
		)

		# Act
		visit root_path
		click_on 'Modelos de Produtos'
		click_on 'Cadastrar Novo'
		fill_in 'Nome', with: ''
		fill_in 'SKU', with: ''
		select 'Sansung', from: 'Fornecedor'
		click_on 'Enviar'

		# Assert
		expect(page).to have_content 'Não foi possível cadastrar o modelo de produto.'
	end
end