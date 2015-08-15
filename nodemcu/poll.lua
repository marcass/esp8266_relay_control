--poll.lua  

--To avoid debouncing:
--Hardware:
--resistor in series with load to button and
-- a capacator of 10-100MuF in parallel to load (-ve pin to gnd). 
-- T=RC where T=time constant of low pass filter
--Software:
--20-50ms delay before moving on through read part of callback function

--place a 10k ressitor in series with relay data line to reduce current

--Variables------------------------------------------------
--set pin mode for state pin (gpio5) as interrupt
spin = 1

--set pin mode for pushbutton toggle defaults to float on startup
-- set for internal pull-up
pin = 2
---------------------------------------------------------

--function definitions------------------------------------
--callback fucntion for button press
function toggle()
  s = gpio.read(pin)
  if s = 1 then  --must be on
    gpio.write(spin, gpio.LOW)
    --delay to avoid debounce
    tmr.delay(20000)
    off()
  --in case of reboot where state pin will be floating need nil test
  elseif s = nil or 0  then --must be off
    gpio.write(spin, gpio.HIGH)
    --delay to avoid debounce
    tmr.delay(20000)
    on()
  else
    print("Invalid: check your code")
  end
end

function on()
  gpio.write(pinon,gpio.HIGH)
  print("Turning coffee on..")
  m:publish(state,"ON",2,1, function(conn)
  end )
end

function off()
  gpio.write(pinon,gpio.LOW)
  print("Turning coffee off..")
  m:publish(state,"OFF",2,1, function(conn)
  end)
end)

--callback fucntion to change openhab state of the switch in case of manual operation
--perhaps a better state solution would be SCT-013-000 (a clamp current monitor)
function state(level)
  if level == 1 then
    print("Manual turn on for coffee")
    m:publish(csta,"ON",2,0, function(conn)
    end )
  elseif level == 0 then
        print("Manual turn off for coffee")
        m:publish(csta,"OFF",2,0, function(conn)
        end )
  end
end
---------------------------------------------------------------------

--the guts (do this if that)-------------------------------------
--set pin mode
gpio.mode(spin,gpio.INT)
gpio.mode(pin,gpio.INT,gpio.PULLUP)

--button press calls toggle function   
gpio.trig(pin,"high", toggle)
  
--update state on button press
gpio.trig(spin,"both",state)
----------------------------------------------------------------

--mqtt for openhab------------------------------------------
m = mqtt.Client(id, 180, buser, bpass)

m:lwt(lwttop, "offline", 0, 0)  
m:on("offline", function(conn)   
  print("MQTT reconnecting")
  dofile("offline.lua")
end)  

-- on published message received for coffee command event  
m:on("message", function(conn, ctop, data)  
 if (data == "ON") then
   on()
 elseif (data == "OFF") then
   off()
 end
 print(node.heap())
end)  

-- on published message received for coffee state event
m:on("message", function(conn, csta, data)
 if (data == "ON") then
   s = 1
 elseif (data == "OFF") then
   s = 0
 else print("State is garbage")
 end
end)

--do the subscription business
tmr.alarm(0, 1000, 1, function()  
 if wifi.sta.status() == 5 and wifi.sta.getip() ~= nil then
   tmr.stop(0)
   m:connect(broker, 1883, 0, function(conn)
     m:subscribe(ctop,2, function(conn)
     end)
   end)
 end
end)
---------------------------------------------------------

