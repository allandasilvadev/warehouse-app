class ProductModel < ApplicationRecord
  belongs_to :supplier
  has_many :order_items

  # de quais pedidos esse produto faz parte
  has_many :orders, through: :order_items 

  validates :name, :weight, :width, :height, :depth, :sku, :supplier, presence: true
  validates :sku, length: { is: 20 }
  validates :sku, uniqueness: true
  validates :weight, :width, :height, :numericality => { :greater_than => 0 }
end
