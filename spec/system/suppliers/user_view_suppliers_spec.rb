require 'rails_helper'

describe 'Usuário vê fornecedores' do
  it 'a partir do menu' do
  	# Arrange

  	# Act  	
  	visit root_path

    within('nav') do
  		click_on 'Fornecedores'
  	end

  	# Assert
  	expect(current_path).to eq suppliers_path
  end

  it 'com sucesso' do
    # Arrange
    Supplier.create!(
      corporate_name: 'Spark Industries Brasil LTDA', 
      brand_name: 'Spark', 
      registration_number: '2412154861', 
      full_address: 'Torre da industria, 1', 
      city: 'Teresina', 
      state: 'PI', 
      email: 'vendas@spark.com.br'
    )

    Supplier.create!(
      corporate_name: 'ACME LTDA', 
      brand_name: 'ACME', 
      registration_number: '434475160', 
      full_address: 'Av das Palmas, 100', 
      city: 'Bauru', 
      state: 'SP', 
      email: 'contato@acme.com.br'
    )

    # Act
    visit root_path
    within('nav') do
      click_on 'Fornecedores'
    end

    # Assert
    expect(page).to have_content('Fornecedores')
    expect(page).to have_content('ACME')
    expect(page).to have_content('Bauru - SP')
    expect(page).to have_content('Spark')
    expect(page).to have_content('Teresina - PI')

  end

  it 'e não existem fornecedores cadastrados' do
    # Arrange

    # Act
    visit root_path
    click_on 'Fornecedores'

    # Assert
    expect(page).to have_content 'Não existem fornecedores cadastrados.'
  end
end