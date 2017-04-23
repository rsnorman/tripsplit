module Api::ApiHelper
  AWS_PRIVATE_IMAGE_TTL = 1.week

  def api_link(path)
    "#{request.base_url}#{path}"
  end

  def to_money(amount)
    return amount.round.to_s if amount.round == amount
    sprintf('%.2f', amount)
  end

  def cache_json_image(jbuilder, resource, image_attribute, version: 'v1')
    jbuilder.cache! ["#{version}-#{image_attribute}", resource], expires_in: AWS_PRIVATE_IMAGE_TTL do
      jbuilder.set! image_attribute, resource.public_send(image_attribute).as_json
    end
  end
end
