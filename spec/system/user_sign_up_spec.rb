require 'rails_helper'

describe 'Usuário se cadastra' do
	it 'com sucesso' do
		# Arrange

		# Act
		visit root_path
		click_on 'Entrar'
		click_on 'Sign up'
		fill_in 'Nome', with: 'Maria'
		fill_in 'E-mail', with: 'maria@email.com'
		fill_in 'Senha', with: 'password'
		fill_in 'Confirme sua senha', with: 'password'
		click_on 'Sign up'

		# Assert
		expect(page).to have_content 'Você realizou seu registro com sucesso.'
		expect(page).to have_content 'maria@email.com'
		expect(page).to have_button 'Sair'
		user = User.last
		expect(user.name).to eq 'Maria'
	end
end