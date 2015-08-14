-- init.lua 

-- set the following variables in-file (short on memory)
ssid	= ""
pass	= ""
id	= "coffee"		--client id for mqtt
broker	= "192.168.0.3"	--url/ip of broker
buser	= ""		--broker username
bpass	= ""		--broker password
lwtt	= "lwt/coffee"		--last will and testament topic
ctop	= "coffee/com"		--coffee com topic
csta	= "coffee/state"		--coffee state topic
pinon	= 6
pinoff 	= 5 

-- Set pin state so it dones't turn heatpump on at power failure
gpio.mode(pinon, gpio.OUTPUT)
gpio.write(pinon, gpio.LOW)
gpio.mode(pinoff, gpio.OUTPUT)
gpio.write(pinoff, gpio.LOW)

-- set counter variables
local  a  = 0      -- Counter of trys to connect to wifi
local  b  = 200    -- Maximum number of WIFI Testings while waiting for connection


function checkWIFI() 
 if ( a > b ) then
   print("Sorry. Not able to connect")
 else
   if ( ( wifi.sta.getip() ~= nil ) and  ( wifi.sta.getip() ~= "0.0.0.0" ) )then
     tmr.alarm( 1 , 2000 , 0 , function()
       --launch file
       dofile("poll.lua")
     end )
   else
     -- Reset alarm again
     tmr.alarm( 0 , 2500 , 0 , checkWIFI)
     print("Checking WIFI..." .. a)
     a = a + 1
    end 
  end 
end

print("-- Starting up! ")

-- Lets see if we are already connected by getting the IP
if ( ( wifi.sta.getip() == nil ) or  ( wifi.sta.getip() == "0.0.0.0" ) ) then
  -- We aren't connected, so let's connect
  print("Configuring WIFI....")
  wifi.setmode( wifi.STATION )
  wifi.sta.config(ssid, password)
  print("Waiting for connection")
  tmr.alarm( 0 , 2500 , 0 , checkWIFI )  -- Call checkWIFI 2.5S in the future.
else
 -- We are connected, so just run the launch code.
  print("IP Address: " .. wifi.sta.getip())
  a = nil
  b = nil
  dofile("poll.lua")
end


