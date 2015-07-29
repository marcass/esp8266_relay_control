-- file to deal with mqtt input

print("starting switch")
print(node.heap())
if h == 1  then
      gpio.write(5,gpio.LOW) gpio.write(6,gpio.HIGH)
      print("Turning coffee on..")
	m:publish("home/coffee/state","1",0,0, function(conn)
        end )
elseif h == 0  then
      gpio.write(5,gpio.HIGH) gpio.write(6,gpio.LOW)
      print("Turning coffee off..")
        m:publish("home/coffee/state","0",0,0, function(conn)
        end )
else
      print("Invalid - Ignoring")   
end
print(node.heap())
