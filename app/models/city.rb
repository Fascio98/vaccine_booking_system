class City < ApplicationRecord
  belongs_to :country

  validates :name, :code, presence: true

  scope :active, -> { where(active: true)}
end
