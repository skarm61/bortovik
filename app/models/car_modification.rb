# == Schema Information
#
# Table name: car_modifications
#
#  id           :integer          not null, primary key
#  name         :string
#  car_model_id :integer
#  created_at   :datetime
#  updated_at   :datetime
#  description  :text
#  slug         :string
#

class CarModification < Car
  default_scope { order(:name) }
  belongs_to :car_model
  has_many :car_feature_car_modifications, dependent: :destroy
  has_many :car_features, through: :car_feature_car_modifications

  delegate :car_brand, to: :car_model

  # search_method :car_brand_eq, :splat_param => true
  def self.car_brand_eq(id)
    joins([car_model: :car_brand]).where("#{CarBrand.table_name}.id = ?", id)
  end
end
