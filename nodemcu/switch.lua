-- file to deal with mqtt input

print("starting switch")
if h == 1  then
  gpio.write(pinoff,gpio.LOW) gpio.write(pinon,gpio.HIGH)
  print("Turning coffee on..")
  m:publish(state,"ON",2,1, function(conn)
  end )
elseif h == 0  then
  gpio.write(pinoff,gpio.HIGH) gpio.write(pinon,gpio.LOW)
  print("Turning coffee off..")
  m:publish(state,"OFF",2,1, function(conn)
  end )
else
  print("Invalid - Ignoring")   
end
print(node.heap())
