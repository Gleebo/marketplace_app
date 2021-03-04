module ListingsHelper
  def convert_price price
    (price.to_f / 100).to_s
  end
end
