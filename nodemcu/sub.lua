  if wifi.sta.status() == 5 and wifi.sta.getip() ~= nil then
     tmr.stop(0)  
     m:connect("192.168.0.3", 1883, 0, function(conn)
       m:subscribe("home/coffee/com",0, function(conn)
       end)
     end)
   end

