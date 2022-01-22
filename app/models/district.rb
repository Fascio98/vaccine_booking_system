class District < ApplicationRecord
  belongs_to :city

  validates :name, :code, presence:true

  scope :active,-> {where(active:true)}
end
