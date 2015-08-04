--poll.lua  
--set pin mode for state gpio5 as interrupt
gpio.mode(1,INT)

--change state of the switch in case of manual operation
gpio.trig(1,"both",function(state)
  if state == 1 then
	print("Manual turn on for coffee")
        m:publish("home/coffee/state","1",2,1, function(conn)
	end )	
  elseif state == 0 then
        print("Manual turn off for coffee")
        m:publish("home/coffee/state","0",2,1, function(conn)
        end )	
  end

m = mqtt.Client("ESP8266 daikin", 180, "", "") --Last 2 values are user and password for broker

 m:lwt("coffee", "offline", 0, 0)  
 m:on("offline", function(con)   
   print("MQTT reconnecting")
   --do the subscription business
   tmr.alarm(0, 1000, 1, function()
   dofile("sub.lua")
   end)
 end)  

 -- on publish message receive event  
 m:on("message", function(conn, topic, data)  
  if (data == "ON") then
	h = 1
  elseif (data == "OFF") then
	h = 0
  end
  dofile("switch.lua")	
  print(node.heap())
 end)  

--do the subscription business
 tmr.alarm(0, 1000, 1, function()  
   dofile("sub.lua")
 end)


