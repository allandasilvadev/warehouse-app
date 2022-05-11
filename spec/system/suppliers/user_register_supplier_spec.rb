require 'rails_helper'

describe 'Usuário cadastra um fornecedor' do
  it 'a partir do menu' do
  	# Arrange

  	# Act
  	visit root_path
  	click_on 'Fornecedores'
  	click_on 'Cadastrar novo fornecedor'

  	# Assert
  	expect(page).to have_field 'Nome Fantasia'
  	expect(page).to have_field 'Razão Social'
  	expect(page).to have_field 'CNPJ'
  	expect(page).to have_field 'Endereço'
  	expect(page).to have_field 'Cidade'
  	expect(page).to have_field 'Estado'
  	expect(page).to have_field 'E-mail'
  end

  it 'com sucesso' do
    # Arrange
    # Act
    visit root_path
    click_on 'Fornecedores'
    click_on 'Cadastrar novo fornecedor'
    fill_in 'Nome Fantasia', with: 'ACME'
    fill_in 'Razão Social', with: 'ACME LTDA'
    fill_in 'CNPJ', with: '4551124845123'
    fill_in 'Endereço', with: 'Rua das Palmas, 100'
    fill_in 'Cidade', with: 'Bauru'
    fill_in 'Estado', with: 'SP'
    fill_in 'E-mail', with: 'vendas@acme.com.br'
    click_on 'Enviar'

    # Assert
    expect(page).to have_content 'Fornecedor cadastrado com sucesso.'
    expect(page).to have_content 'ACME LTDA'
    expect(page).to have_content 'Documento: 4551124845123'
    expect(page).to have_content 'Endereço: Rua das Palmas, 100 - Bauru - SP'
    expect(page).to have_content 'E-mail: vendas@acme.com.br'

  end

  it 'com dados incompletos' do
    # Arrange

    # Act
    visit root_path
    click_on 'Fornecedores'
    click_on 'Cadastrar novo fornecedor'
    fill_in 'Nome Fantasia', with: ''
    fill_in 'Razão Social', with: ''
    fill_in 'CNPJ', with: ''
    fill_in 'E-mail', with: ''
    click_on 'Enviar'

    # Assert
    expect(page).to have_content 'Fornecedor não cadastrado'
    expect(page).to have_content 'Nome Fantasia não pode ficar em branco'
    expect(page).to have_content 'Razão Social não pode ficar em branco'
    expect(page).to have_content 'CNPJ não pode ficar em branco'
  end

  it 'ou volta para listagem de fornecedores' do
  	# Arrange
  	
  	# Act
  	visit root_path
  	click_on 'Fornecedores'
  	click_on 'Cadastrar novo fornecedor'
  	click_on 'Voltar'

  	# Assert
  	expect(current_path).to eq suppliers_path
  end
end