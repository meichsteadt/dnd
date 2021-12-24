class InkarnateApi
  @@token = nil
  @@token = '2vQh5kf3WRotsWowkzg8t3byEpHx2e6PX1kA5tn8t86uQYmyHE'
  def self.login(email, password)
    res = RestClient.post("https://api2.inkarnate.com/api/tokens", {email: email, password: password})
    json = JSON.parse(res.to_s)
    token = json["authToken"]
    @@token = token
    json
  end

  def self.token=(token)
    @@token = token
  end

  def self.token
    @@token
  end

  def self.get_maps(token = @@token)
    require "uri"
    require "net/http"

    url = URI("https://api2.inkarnate.com/api/scenes")

    https = Net::HTTP.new(url.host, url.port)
    https.use_ssl = true

    request = Net::HTTP::Get.new(url)
    request["Authorization"] = "Bearer #{token}"

    response = https.request(request)
    items = JSON.parse(response.read_body)["items"]
    if items
      return items.map {|e| TempMap.new(e["title"], e["preview"], e["preview"].split("/").last)}
    else
      []
    end
  end
end

TempMap = Struct.new(:name, :preview, :id) do
  def save(user_id)
    Map.create(user_id: user_id, name: self.name, preview: self.preview, ink_id: self.id)
  end
end
