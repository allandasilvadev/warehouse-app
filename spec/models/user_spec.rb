require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#description' do
    it 'exibe o nome e o e-mail' do
      # Arrange
      u = User.new(name: 'Julia Almeida', email: 'julia@email.com')
      # Act
      res = u.description()
      # Assert
      expect(res).to eq 'Julia Almeida - julia@email.com'
    end
  end
end
