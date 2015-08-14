--poll.lua  


--set pin mode for state gpio5 as interrupt
gpio.mode(1,INT)

--change state of the switch in case of manual operation
gpio.trig(1,"both",function(state)
  if state == 1 then
    print("Manual turn on for coffee")
    m:publish(csta,"ON",2,1, function(conn)
    end )	
  elseif state == 0 then
        print("Manual turn off for coffee")
        m:publish(csta,"OFF",2,1, function(conn)
        end )	
  end

m = mqtt.Client(id, 180, buser, bpass) --Last 2 values are user and password for broker

m:lwt(lwttop, "offline", 0, 0)  
m:on("offline", function(conn)   
  print("MQTT reconnecting")
  dofile("offline.lua")
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
 if wifi.sta.status() == 5 and wifi.sta.getip() ~= nil then
   tmr.stop(0)
   m:connect(broker, 1883, 0, function(conn)
     m:subscribe(ctop,2, function(conn)
     end)
   end)
 end
end)


