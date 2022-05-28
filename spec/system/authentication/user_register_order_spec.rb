require 'rails_helper'
describe 'Usuário cadastra um pedido' do
    it 'e deve estar autenticado' do
        # Arrange
        # Act
        visit root_path
        click_on 'Registrar pedido'

        # Assert
        expect(current_path).to eq new_user_session_path
    end

    it 'com sucesso' do
        # Arrange
        user = User.create!(name: 'João da Silva', email: 'joao@email.com', password: '123456')

        Warehouse.create!(
            name: 'Rio', 
            code: 'SDU', 
            city: 'Rio de Janeiro', 
            area: 60_000,
            address: 'Av. do Porto, 1000',
            cep: '20000-000',
            description: 'Galpão do Rio'
         )

        warehouse = Warehouse.create!(
            name: 'Aeroporto SP', 
            code: 'GRU', 
            city: 'Guarulhos', 
            area: 100_000, 
            address: 'Avenida do Aeroporto, 1000',
            cep: '15000-000',
            description: 'Galpão destinado para cargas internacionais'
          )        

        Supplier.create!(
			corporate_name: 'Star LTDA',
			brand_name: 'Star',
			registration_number: '4228126848132',
			full_address: 'Av das Nações, 4200',
			city: 'São Paulo',
			state: 'SP',
			email: 'contato@star.com'
		)

        supplier = Supplier.create!(
			corporate_name: 'ACME LTDA',
			brand_name: 'ACME',
			registration_number: '4228126848123',
			full_address: 'Av das Palmas, 100',
			city: 'Bauru',
			state: 'SP',
			email: 'contato@acme.com'
		)

        allow(SecureRandom).to receive(:alphanumeric).with(8).and_return('ABC12345')

        # Act
        login_as(user)
        visit root_path
        click_on 'Registrar pedido'
        select "#{warehouse.code} | #{warehouse.name}", from: 'Galpão destino'
        select supplier.corporate_name, from: 'Fornecedor'
        fill_in 'Data prevista de entrega', with: '20/12/2022'
        click_on 'Gravar'

        # Assert
        expect(page).to have_content 'Pedido registrado com sucesso.'
        expect(page).to have_content 'Pedido ABC12345'
        expect(page).to have_content 'Galpão destino: GRU | Aeroporto SP'
        expect(page).to have_content 'Fornecedor: ACME LTDA'
        expect(page).to have_content 'Responsável: João da Silva - joao@email.com'
        expect(page).to have_content 'Data prevista de entrega: 20/12/2022'
        expect(page).to have_content 'Status do pedido: Pendente'
    end
end