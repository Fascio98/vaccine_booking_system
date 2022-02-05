class Order < ApplicationRecord
  belongs_to :business_unit_slot
  belongs_to :patient

  before_create do
    self.order_code = order_next_code
  end

  validates_presence_of :order_code

  def order_next_code
    ActiveRecord::Base.connection.select_one("SELECT nextval('order_code');")['nextval']
  end

  def self.order_code(search)
    if search
      order_code = Order.find_by(order_code: search)

      if order_code
        self.where(id: order_code)
      end
    else
      @that_order=Order.all
    end
  end

  scope :finished,-> {where(finished:true)}
end
