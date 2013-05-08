module PassengerStandalone
  VERSION = "4.0.2.3"

  def self.passenger_version
    VERSION[/^\d+\.\d+\.\d+/]
  end
end
