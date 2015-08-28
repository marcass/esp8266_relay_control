# esp8266_relay_control
A circuit diagram and code for switching a solid state relay to contol any electrical device (within relay's ratings), in this case a coffee machine. Uses:
* MQTT to communicate with openhab so that it can be actuated with phone
* A physical switch at the device so switching can be performed locally also
* nodemcu on an esp8266
