#  Ultra Violet  sensor LTR-390
simple test driver for LTR-390 written in LUA (c) Tad1ak 2025

## Dependencies

LTR390.lua have been tested with Lua 5.1.4 on ESP-IDF v3.3-beta1 integer build They require the following modules.
  i2c
  
## functionalities

Obtaining UV and ASL values ​​involves reading the two global variables:
* uv_value
* light_value

These variables are updated in cycles from 200 to 1000 msec depending on the set resolution


### function setGain(g)

  if g==nil then print(' g: 1,3,6,9,18 ') end

### function setBits(b)
  if b==nil then print(' b: 13, 16, 17, 18, 19, 20 bits ') end

## Averaged measurements from the LTR390 sensor illuminated with constant light from a UV diode, voltage: 3.17 V and current 21 mA

https://alfard.ovh/index.php/pomiary-ultrafioletu/#LTR390cal

