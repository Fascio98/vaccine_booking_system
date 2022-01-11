class VaccinesItem < ApplicationRecord
  validates :name, presence: true
  scope :active, -> {where(active: true)}
end
