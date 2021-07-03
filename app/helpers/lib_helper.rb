require 'json'
require 'net/https'
require "uri"

module LibHelper
  def get_author_summary(author_name)
    uri = URI("https://ja.wikipedia.org/w/api.php?format=json&action=query&prop=extracts&exintro&explaintext&redirects=1&titles=" + URI.encode(author_name))
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    req = Net::HTTP::Get.new(uri)
    res = http.request(req)
    res_data=JSON.parse(res.body)

    for id in res_data["query"]["pages"]
      return res_data["query"]["pages"][id[0].to_s]["extract"]
    end
  end

  def get_author_image(author_name)
    uri = URI("https://ja.wikipedia.org/api/rest_v1/page/summary/" + URI.encode(author_name))
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    req = Net::HTTP::Get.new(uri)
    res = http.request(req)
    res_data=JSON.parse(res.body)

    return res_data["originalimage"]["source"]
  end
end
