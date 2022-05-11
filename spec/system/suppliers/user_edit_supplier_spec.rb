require 'rails_helper'

describe 'Usuário edita fornecedor' do
	it 'a partir da página detalhes' do
		# Arrange
		Supplier.create!(
			corporate_name: 'ACME LTDA',
			brand_name: 'ACME',
			registration_number: '434475160',
			full_address: 'Rua das Palmas, 100',
			city: 'Bauru',
			state: 'SP',
			email: 'vendas@acme.com.br'
		)

		# Act
		visit root_path
		click_on 'Fornecedores'
		click_on 'ACME'
		click_on 'Editar'

		# Assert
		expect(page).to have_content 'Editar Fornecedor'

		expect(page).to have_field('Nome Fantasia', with: 'ACME')
		expect(page).to have_field('Razão Social', with: 'ACME LTDA')
		expect(page).to have_field('CNPJ', with: '434475160')
		expect(page).to have_field('Endereço', with: 'Rua das Palmas, 100')
		expect(page).to have_field('Cidade', with: 'Bauru')
		expect(page).to have_field('Estado', with: 'SP')
		expect(page).to have_field('E-mail', with: 'vendas@acme.com.br')
	end

	it 'com sucesso' do
		# Arrange
		Supplier.create!(
			corporate_name: 'ACME LTDA',
			brand_name: 'ACME',
			registration_number: '434475160',
			full_address: 'Rua das Palmas, 100',
			city: 'Bauru',
			state: 'SP',
			email: 'vendas@acme.com.br'
		)

		# Act
		visit root_path
		click_on 'Fornecedores'
		click_on 'ACME'
		click_on 'Editar'
		fill_in 'Endereço', with: 'Rua das Palmas, 200'
		fill_in 'E-mail', with: 'vendas@acme.com'
		click_on 'Enviar'

		# Assert
		expect(page).to have_content 'Fornecedor atualizado com sucesso.'

  	expect(page).to have_content 'Endereço: Rua das Palmas, 200'
  	expect(page).to have_content 'E-mail: vendas@acme.com'
	end

	it 'e mantém os campos obrigatórios' do
		# Arrange
		Supplier.create!(
			corporate_name: 'ACME LTDA',
			brand_name: 'ACME',
			registration_number: '434475160',
			full_address: 'Rua das Palmas, 100',
			city: 'Bauru',
			state: 'SP',
			email: 'vendas@acme.com.br'
		)

		# Act
		visit root_path
		click_on 'Fornecedores'
		click_on 'ACME'
		click_on 'Editar'
		fill_in 'Endereço', with: ''
		fill_in 'E-mail', with: ''
		click_on 'Enviar'

		# Assert
  	expect(page).to have_content 'Não foi possível atualizar o fornecedor.'
	end

	it 'ou volta para página de detalhes' do
		# Arrange
		s = Supplier.create!(
			corporate_name: 'ACME LTDA',
			brand_name: 'ACME',
			registration_number: '434475160',
			full_address: 'Rua das Palmas, 100',
			city: 'Bauru',
			state: 'SP',
			email: 'vendas@acme.com.br'
		)

		# Act
		visit root_path
		click_on 'Fornecedores'
		click_on 'ACME'
		click_on 'Editar'
		click_on 'Voltar'

		# Assert
		expect(current_path).to eq( supplier_path( s.id ) )

	end
end