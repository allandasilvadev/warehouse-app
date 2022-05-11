require 'rails_helper'

describe 'Usuário remove um galpão' do
  it 'com sucesso' do
  	# Arrage
  	w = Warehouse.create!(
  	  name: 'Aeroporto SP',
  	  code: 'GRU',
  	  city: 'Guarulhos',
  	  area: 100_000,
  	  address: 'Avenida do Aeroporto, 1000',
  	  cep: '15000-000',
  	  description: 'Galpão destinado para cargas internacionais'
  	)

  	# Act
  	visit root_path
  	click_on 'Aeroporto SP'
  	click_on 'Remover'

  	# Assert
  	expect(current_path).to eq root_path
  	expect(page).to have_content 'Galpão removido com sucesso.'
  	expect(page).not_to have_content 'Aeroporto SP'
  	expect(page).not_to have_content 'GRU'
  end

  it 'e não apaga outros galpões' do
  	# Arrage
  	first_warehouse = Warehouse.create!(
  	  name: 'Aeroporto SP',
  	  code: 'GRU',
  	  city: 'Guarulhos',
  	  area: 100_000,
  	  address: 'Avenida do Aeroporto, 1000',
  	  cep: '15000-000',
  	  description: 'Galpão destinado para cargas internacionais'
  	)

  	second_warehouse = Warehouse.create!(
  	  name: 'Cuiaba',
  	  code: 'CWB',
  	  city: 'Cuiaba',
  	  area: 80_000,
  	  address: 'Avenida do Aeroporto, 50',
  	  cep: '18000-000',
  	  description: 'Galpão no centro do pais'
  	)

  	# Act
  	visit root_path
  	click_on 'Cuiaba'
  	click_on 'Remover'

  	# Assert
  	expect(current_path).to eq root_path
  	expect(page).to have_content 'Galpão removido com sucesso.'
  	expect(page).to have_content 'Aeroporto SP'
  	expect(page).not_to have_content 'Cuiaba'

  end
end