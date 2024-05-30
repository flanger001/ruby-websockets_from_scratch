class Renderer
  def render(file)
    file = File.read(File.expand_path("views/#{file}", __dir__))
    erb = ERB.new(file)
    erb.result(binding)
  end

  def local_ip
    ENV["LOCAL_IP"]
  end
end
