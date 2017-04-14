function deviceStart()
 tmr.stop(1)
 app = require "app"
 wifi_config = require "wifi_config"
 myMQTT = require "mqtt_service"
 getDHT = require "DHT22_Class"
 app.start()
 myMQTT.startMQTT()
end

tmr.alarm(1,10000, 1, deviceStart)
