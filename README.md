#  Ultra Violet  sensor LTR-390
simple test driver for LTR-390 written in LUA 

## Dependencies

LTR390.lua have been tested with Lua 5.1.4 on ESP-IDF v3.3-beta1 integer build They require the following modules.
  i2c
  
## functions

Obtaining UV and ASL values ​​involves reading the global variables:
*uv_value and 
*light_value
These variables are updated in cycles from 200 to 1000 msec depending on the set resolution

setGain(g)
  if g==nil then print(' 1,3,6,9,18 ') end

setBits(b)
  if b==nil then print(' set 13, 16, 17, 18, 19, 20 bits ') end

