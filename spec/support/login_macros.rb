def login(user)
	click_on 'Entrar'
	fill_in 'E-mail', with: user.email
	fill_in 'Senha', with: user.password
	within('form#new_user') do
		click_on 'Entrar'
	end
end