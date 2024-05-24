module App
  class Index
    def call(_env)
      [
        200,
        { "Content-Type" => "text/html" },
        [body]
      ]
    end

    def body
      file = File.read(File.expand_path("templates/index.html.erb", __dir__))
      erb = ERB.new(file)
      erb.result(binding)
    end

    def local_ip
      ENV["LOCAL_IP"]
    end
  end
end
