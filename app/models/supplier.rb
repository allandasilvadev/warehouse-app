class Supplier < ApplicationRecord
	validates :corporate_name, :brand_name, :full_address, :registration_number, :city, :state, :email, presence: true
	validates :registration_number, uniqueness: true
end
