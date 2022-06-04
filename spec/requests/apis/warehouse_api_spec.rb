require 'rails_helper'

describe 'Warehouse API' do
	context 'GET /api/v1/warehouses/1' do
		it 'success' do
			# Arrange
			warehouse = Warehouse.create!(
       name: 'Aeroporto SP', 
       code: 'GRU', 
       city: 'Guarulhos', 
       area: 100_000, 
       address: 'Avenida do Aeroporto, 1000',
       cep: '15000-000',
       description: 'Galpão destinado para cargas internacionais'
    	)

			# Act
			get "/api/v1/warehouses/#{warehouse.id}"
			
			# Assert
			expect(response.status).to eq 200
			expect(response.content_type).to include 'application/json'

			json_response = JSON.parse(response.body)

			# expect(response.body).to include 'Aeroporto SP'
			expect(json_response["name"]).to include 'Aeroporto SP'
			expect(json_response["code"]).to include 'GRU'
			expect(json_response.keys).not_to include 'created_at'
			expect(json_response.keys).not_to include 'updated_at'
		end

		it 'fail if warehouse not found' do
			# Arrange
			# Act
			get "/api/v1/warehouses/248"

			# Assert
			expect(response.status).to eq 404
		end
	end

	context 'GET /api/v1/warehouses' do
		it 'list all warehouses ordered by name' do
			# Arrange
			Warehouse.create!(
       name: 'Aeroporto SP', 
       code: 'GRU', 
       city: 'Guarulhos', 
       area: 100_000, 
       address: 'Avenida do Aeroporto, 1000',
       cep: '15000-000',
       description: 'Galpão destinado para cargas internacionais'
    	)

    	Warehouse.create!(
       name: 'Galpão Rio de Janeiro', 
       code: 'RIO', 
       city: 'Rio', 
       area: 30_000, 
       address: 'Avenida das Nações, 2000',
       cep: '27000-000',
       description: 'Galpão do rio de janeiro'
    	)
			# Act
			get "/api/v1/warehouses"

			# Assert
			expect(response.status).to eq 200
			expect(response.content_type).to include 'application/json'
			json_response = JSON.parse(response.body)
			# expect(json_response.class).to eq Array
			expect(json_response.length).to eq 2
			expect(json_response[0]["name"]).to eq "Aeroporto SP"
			expect(json_response[1]["name"]).to eq "Galpão Rio de Janeiro"
		end

		it 'return empty if there is no warehouse' do
			# Arrange
			# Act
			get "/api/v1/warehouses"
			# Assert
			expect(response.status).to eq 200
			expect(response.content_type).to include 'application/json'
			json_response = JSON.parse(response.body)
			expect(json_response).to eq []
		end
	end
end