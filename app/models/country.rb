class Country < ApplicationRecord
  validates :name, :code, presence:true

  scope :active,-> {where(active:true)}
end
