--handling of connection dropouts that result in esp hanging wiuth mqtt trying to reconnect
print("offline started") print(node.heap())

--kill bad broker connecton
m:close();

--stop the temp timer
tmr.stop(1)

--empty m to conserve memory
m = nil

--cycle until connected again
tmr.alarm(4, 10000, 1, function()
  if wifi.sta.status() == 5 and wifi.sta.getip() ~= nil then
    print("All OK, subscribing")
    dofile("poll.lua")
  elseif  wifi.sta.status() == 1 then
    print("Connecting to wifi")
  elseif wifi.sta.status() == 2 then
    print("Check pass")
  elseif wifi.sta.status() == 3 or 4 then
    print("restarting")
    dofile("init.lua")
  end
end)

