local module = {}

m = nil

function validate_publish_state()
    local state = app.pumpStatus()
    if state == 1 then
        module.publishData("ON")
    else
        module.publishData("OFF")
    end
end

function module.startMQTT()
    m = mqtt.Client("Cellar_1", 120, "user", "password")
    m:lwt("/lwt", "offline", 0, 0)
    
    m:on("connect", function(client) print ("connected") 
        
        end)
    m:on("offline", function(client) print ("offline")
        
        end)
    
    -- on publish message receive event
    m:on("message", function(client, topic, data) 
      print(topic .. ":" ) 
      if string.find(topic, "/homeauto/radiant/command") then
          if data ~= nil then
            if data == "pump=ON" then
                app.pumpStart()
                validate_publish_state()
            elseif data == "pump=OFF" then
                app.pumpStop()
                validate_publish_state()
            elseif data == "fan=LOW" then
                print("Setting Fan LOW")
            elseif data == "fan=HIGH" then
                print("Setting Fan HIGH")
            elseif data == "status=GET" then
                print("returning Status")            
            elseif data == "temp=GET" then
                print("Getting Temp Data")
                tempData, humidData=getDHT.getTemp_Humid(1)
                if tempData ~= "timeout" then                    
                    module.publishTempData(tempData)
                    module.publishTempDataF(tempData)
                    module.publishHumidData(humidData)
                end

            end
          end
      end
    end)
    
    m:connect("192.168.1.10", 1883, 0, 1, function(client) print("connected")
        m:subscribe("/homeauto/radiant/command",0, function(client) print("subscribe success") end)
    -- publish a message with data = hello, QoS = 0, retain = 0
        m:publish("/homeauto/radiant/status","OFF",0,0, function(client) print("sent") end)
        tempData, humidData=getDHT.getTemp_Humid(1)
                if tempData ~= "timeout" then                    
                    module.publishTempData(tempData)
                    module.publishTempDataF(tempData)
                    module.publishHumidData(humidData)
                end
        end, 
        function(client, reason) print("failed reason: "..reason) end)
    
    
    --m:close();
end

function module.publishData(data)

    m:publish("/homeauto/radiant/status",data,0,0, function(client) print("sent: "..data) end)

end

function module.publishTempData(tempdata)
    if tempdata ~= nil then
    m:publish("/homeauto/radiant/ambient/temp",tempdata,0,0, function(client) print("tempsent: "..tempdata) end)
    end
end

function module.publishTempDataF(tempdata)
    if tempdata ~= nil then
    ftempdata = ((1.8 * tempdata) + 32)
    m:publish("/homeauto/radiant/ambient/tempf",ftempdata,0,0, function(client) print("tempsent: "..ftempdata) end)
    end
end

function module.publishHumidData(humiddata)
    if humiddata ~= nil then
    m:publish("/homeauto/radiant/ambient/humid",humiddata,0,0, function(client) print("humidsent: "..humiddata) end)
    end
end

return module
