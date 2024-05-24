module App
  class Favicon
    def call(_env)
      [
        200,
        { "Content-Type" => "image/png" },
        [Base64.decode64("iVBORw0KGgoAAAANSUhEUgAAAAoAAAAKCAYAAACNMs+9AAAAFklEQVR42mNcwPD/PwMRgHFUIX0VAgDNexo3sUL33gAAAABJRU5ErkJggg==")],
      ]
    end
  end
end
