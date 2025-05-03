-- 106 LTR lib t1ak --date= 2025-05-03 12:59:20
--[[
  ruszyło maj 2025 istotny był [false] w i2c.write
 + funkcje setGain i setBits
 jako lib korzystaj ze zmiennych globalnych uv_value i light_value
-- Define LTR390 I2C address ]]

local LTR390_ADDR = 0x53
id = 0 --i2c.SW -- hardware interface

-- I2C functions (assuming they exist in your NodeMCU firmware)
-- i2c.setup(id, sda, scl, speed)
-- i2c.write(id, addr, ...)
-- i2c.read(id, addr, len)

-- LTR390 Register Addresses (from datasheet)
local LTR390_MAIN_CTRL = 0x00
local LTR390_UVSDATA = 0x10
local LTR390_ALSDATA = 0x0D

function read_byte(dev_address, dev_register , callback )
  i2c.start(id)
  i2c.address(id, dev_address, i2c.TRANSMITTER)
  i2c.write(id, dev_register,false)
  --i2c.stop(id)
  i2c.start(id) -- repeated start condition
  i2c.address(id, dev_address, i2c.RECEIVER)
  x=i2c.read(id, 3)
  --print(x:byte(1),x:byte(2),x:byte(3))
  i2c.stop(id)
  return x --i2c.transfer(id, callback)
end

function write_data(data)
  i2c.start(id)
  i2c.address(id, LTR390_ADDR, i2c.TRANSMITTER)
  i2c.write(id, data,false)
  i2c.stop(id)
end

-- Function to initialize LTR390
function init_ltr390(Ao2,gain,Bits)
  -- i2c.setup(id, 21, 22, i2c.SLOW) -- Example: I2C on bus 0, SDA on pin 1, SCL on pin 2
  write_data({LTR390_MAIN_CTRL,Ao2}) -- 0A = UV; 02 = Lux
  write_data({0x04, Bits}) --0x04}) --22 13-20 bits 25-2000 ms
  write_data({0x05, gain}) --Gain Range 0x01
  write_data({0x19, 0x14}) --14 
  write_data({0x1A, 0x00})
end

-- Function to read UV data
function read_uvs()
  local data=read_byte(LTR390_ADDR, LTR390_UVSDATA)
  local uvs_raw = (data:byte(3) * 65536) + (data:byte(2) * 256) + data:byte(1)
  return uvs_raw
end

function read_als()
  local data=read_byte(LTR390_ADDR, LTR390_ALSDATA)
  local raw = (data:byte(3) * 65536) + (data:byte(2) * 256) + data:byte(1)
  return raw
end

n=0 ggain=0x01 iBity=0x23 --> default 18 Bit i 100ms

TmrG=tmr.create() --10 000 = 10 sec
TmrG:register(4000, tmr.ALARM_AUTO, --120 tys = 2 minuty
 function(t)
   n=n+1 --print('start',n)
   if n==1 then
     init_ltr390(0x0A,ggain,iBity)
     uv_value = read_uvs()    --print("UV raw:", uv_value)
   end
   if n==2 then
     init_ltr390(0x02,ggain,iBity)
     light_value = read_als() --print("Light Raw:", light_value)
   end
   if n>1 then
     n=0
     --print('UV:'..(uv_value),'Lux:'..(light_value))
   end
   --t:unregister()
 end)

uv_value=-888 light_value=-888
TmrG:start()

 function setBits(iB)
   if iB==nil then print(' set 13, 16, 17, 18, 19, 20 bits ') end
   if iB==20 then iBity=0x05 end
   if iB==19 then iBity=0x14 end
   if iB==18 then iBity=0x23 end
   if iB==17 then iBity=0x32 end
   if iB==16 then iBity=0x41 end
   if iB==13 then iBity=0x50 end
 end
 
function setGain(gein)
   if gein==nil then print(' 1,3,6,9,18 ') end
   if gein==1 then ggain=0x00 end
   if gein==3 then ggain=0x01 end
   if gein==6 then ggain=0x02 end
   if gein==9 then ggain=0x03 end
   if gein==18 then ggain=0x04 end
 end
   
--[[

-- Example usage
init_ltr390(0x0A,0x01)
uv_value = read_uvs()
print("UV raw:", uv_value)
light_value = read_als()
print("Light Raw:", light_value)

init_ltr390(0x02,0x01)
uv_value = read_uvs()
print("UV raw:", uv_value)
light_value = read_als()
print("Light Raw:", light_value) ]]
