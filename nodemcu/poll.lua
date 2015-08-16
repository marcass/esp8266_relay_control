--poll.lua  

--To avoid debouncing:
--Hardware:
--resistor 2.2k resistor in series with load to button and
-- a capacator of 1MuF in parallel to load (-ve pin to gnd). 
-- T=RC where T=time constant of low pass filter
--Software:
--500ms delay before moving on through read part of callback function

--place a 10k ressitor in series with relay data line to reduce current if not already there in realy board

--Variables------------------------------------------------
--set pin mode for state pin (gpio5) as interrupt (also trip relay)
spin = 1  -- is gpio5

--set pin mode for pushbutton toggle defaults to float on startup
-- set for internal pull-up
pin = 2  -- is gpio4

--mqtt
m = mqtt.Client(id, 180, buser, bpass)
---------------------------------------------------------

--function definitions------------------------------------
--callback fucntion for button press
function toggle()
  s = gpio.read(spin)
  print("state pin = ") print(s)
  if s == 1 then  --must be on
    --delay to avoid debounce
    tmr.delay(500000)
    print("Button turned off")
    off()
  --in case of reboot where state pin will be floating need nil test
  elseif s == nil or 0  then --must be off
    --delay to avoid debounce
    tmr.delay(500000)
    print("Button turned on")
    on()
  else
    print("Invalid: check your code")
  end
end

function on()
  gpio.write(spin,gpio.HIGH)
  print("Turning coffee on..")
  m:publish(csta,"ON",2,0, function(conn)
  end )
end

function off()
  gpio.write(spin,gpio.LOW)
  print("Turning coffee off..")
  m:publish(csta,"OFF",2,0, function(conn)
  end)
end

---------------------------------------------------------------------

--the guts (do this if that)-------------------------------------
--set pin mode
gpio.mode(spin,gpio.OUTPUT)
gpio.mode(pin,gpio.INT)

--button press calls toggle function   
gpio.trig(pin,"high", toggle)
  
----------------------------------------------------------------

--mqtt for openhab------------------------------------------
m:lwt(lwtt, "offline", 0, 0)  
m:on("offline", function(conn)   
  print("MQTT reconnecting")
  dofile("offline.lua")
end)  

-- on published message received for coffee command event  
m:on("message", function(conn, topic, data)  
 print("Message received")
 if (data == "ON") then
   on()
 elseif (data == "OFF") then
   off()
 end
 print(node.heap())
end)  

--do the subscription business
tmr.alarm(0, 1000, 1, function()  
 if wifi.sta.status() == 5 and wifi.sta.getip() ~= nil then
   tmr.stop(0)
   m:connect(broker, 1883, 0, function(conn)
     print("connected to broker")
     m:subscribe(ctop,2, function(conn)
     print("subscribed to coffee topic")
     end)
   end)
 end
end)
---------------------------------------------------------

