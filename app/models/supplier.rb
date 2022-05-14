class Supplier < ApplicationRecord
	has_many :product_model
	validates :corporate_name, :brand_name, :full_address, :registration_number, :city, :state, :email, presence: true
	validates :registration_number, length: { is: 13 }
	validates :registration_number, uniqueness: true
end
