# encoding: utf-8

class Vehicle < ActiveRecord::Base
  extend Enumerize

  COLORS = %w(чёрный белый жёлтый красный зелёный синий)
  enumerize :color, in: COLORS
  TRANSMISSION = %w(механика автомат)
  enumerize :transmission, in: TRANSMISSION

  belongs_to :car_modification
  has_many :user_vehicles
  has_many :users, through: :user_vehicles
  has_many :car_feature_car_modifications, through: :car_modification
  alias_method :features, :car_feature_car_modifications

  attr_accessible :color, :engine_volume, :mileage, :transmission, :car_modification_id, :vin, :release_year
  attr_accessor :car_brand_id, :car_model_id
  accepts_nested_attributes_for :user_vehicles

  validates_presence_of :color, :mileage, :car_modification
  validates_numericality_of :mileage, :engine_volume

  delegate :car_model, to: :car_modification
  delegate :car_brand, to: :car_model

  def owner
    mapper = user_vehicles.detect{ |uv| uv.date_of_sale.nil? }
    mapper.user if mapper.present?
  end

  def name
    "#{car_brand.name} #{car_model.name}"
  end
end
