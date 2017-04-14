local module = {}

module.ISWIFICONNECTED = false
USE_END_USER = true
module.CURRENT_IP = nil
module.PUMP_PIN = 2
module.FAN_LOW_PIN = 2
module.FAN_HIGH_PIN = 2
module.opStatus = {}

function module.start()
 gpio.mode(module.PUMP_PIN,gpio.OUTPUT)
 print("Pin: "..module.PUMP_PIN.." Configured as OUTPUT")
 gpio.write(module.PUMP_PIN,gpio.LOW)
 print("Pin: "..module.PUMP_PIN.." Set to LOW")
 module.opStatus["pump"] = module.pumpStatus()
 module.opStatus["fan"] = module.fanStatus()
end

function module.pumpStart()
    gpio.write(module.PUMP_PIN,gpio.HIGH)
    module.opStatus["pump"] = 1
end

function module.pumpStop()
    gpio.write(module.PUMP_PIN,gpio.LOW)
    module.opStatus["pump"] = 0
end

function module.pumpStatus()
    return gpio.read(module.PUMP_PIN)
end

function module.fanOff()
    gpio.write(module.FAN_LOW_PIN,gpio.LOW)
    gpio.write(module.FAN_HIGH_PIN,gpio.LOW)
    module.opStatus["fan"] = 0
end

function module.fanLow()    
    gpio.write(module.FAN_HIGH_PIN,gpio.LOW)
    gpio.write(module.FAN_LOW_PIN,gpio.HIGH)
    module.opStatus["fan"] = 1
end

function module.fanHigh()
    gpio.write(module.FAN_LOW_PIN,gpio.LOW)
    gpio.write(module.FAN_HIGH_PIN,gpio.HIGH)
    module.opStatus["fan"] = 2
end

function module.fanStatus()
    return gpio.read(module.PUMP_PIN)
end

return module
