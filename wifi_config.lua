local module = {}

module.ISWIFICONNECTED = false
module.USE_END_USER = true
module.CURRENT_IP = nil

function module.runWifiConfig()
    if USE_END_USER then
        enduser_setup.start(function()
          CURRENT_IP = wifi.sta.getip()
          print("Wifi Setup Complete, IP ADDR Obtained: "..CURRENT_IP)
         end);
    end
end

function module.forceWifiConfig(stopOnceConfigured)
    wifi.setmode(wifi.STATIONAP)
    wifi.ap.config({ssid="RHConnect", auth=wifi.WPA2_PSK, pwd="myESPAPPassword"})
    enduser_setup.manual(true)
    enduser_setup.start(
        function()
            print("Wifi Setup Complete, IP ADDR Obtained: "..wifi.sta.getip())
            module.ISWIFICONNECTED = true
            if stopOnceConfigured then
                print("stopOnConfigured == true")
                enduser_setup.stop()
                wifi.setmode(wifi.STATION)
            end
        end,
        function(err, str)
            print("enduser_setup: Err #" .. err .. ": " .. str)
        end
    );
end

function module.validateWifiConnection()
    local cur_ip = wifi.sta.getip()
    print(cur_ip)
    if cur_ip == nil then
        module.runWifiConfig()
    end
    return cur_ip      
end

function module.WifiSetup()
    
    wifi.setmode(wifi.STATIONAP)
    wifi.ap.config({ssid="MyPersonalSSID", auth=wifi.OPEN})
    enduser_setup.manual(true)
    enduser_setup.start(
  function()
    print("Connected to wifi as:" .. wifi.sta.getip())
  end,
  function(err, str)
    print("enduser_setup: Err #" .. err .. ": " .. str)
  end
    );
end

return module
