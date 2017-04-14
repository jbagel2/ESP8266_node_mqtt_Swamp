local module = {}    
    function module.getTemp_Humid(dht_data_pin)
         status, temp, humi, temp_dec, humi_dec = dht.readxx(dht_data_pin)
         if status == dht.OK then         
            return temp, humi      
         elseif status == dht.ERROR_CHECKSUM then
            return "checksum"
         elseif status == dht.ERROR_TIMEOUT then
            return "timeout"
         end
    end
return module
