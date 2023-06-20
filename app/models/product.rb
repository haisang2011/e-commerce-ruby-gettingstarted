class Product < ApplicationRecord
  validates :name, presence: true
  validates :price, presence: true
  validates :name, uniqueness: { message: "Product with the given name already exists." }
  validates :is_deleted, inclusion: { in: [false, true], message: "is_deleted must be either 0 or 1" }

  def is_deleted=(value)
    self[:is_deleted] = value.nil? ? false : value
  end
end
