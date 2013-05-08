module PassengerStandalone
  VERSION = "4.0.2.8"

  def self.passenger_version
    VERSION[/^\d+\.\d+\.\d+/]
  end
end
