pico-8 cartridge // http://www.pico-8.com
__lua__

function init()
 nums= {}
 bricks= {}
 brickcountwidth = 2
 brickcountheight = 2
 for i=0, brickcountheight, 1 do
  for j=0, brickcountwidth, 1 do
   local brick = {
    x= 50+j*9,
    y= 50+i*9,
    width=3,
    height=3,
    c=1
   }
   add(bricks,brick)
  end
 end
 --create numbers
 for i=0, brickcountheight, 1 do
  for j=0, brickcountwidth, 1 do
   local num = {
    x=80+j*8,
    y=50+i*8,
    n=i,
   }
   add(nums,num)
  end
 end
end
function drawmatrix()
 local m=0
 for b in all(bricks) do
  m=m+8 
  print(b.x,m,10)
  print(b.y,m,30)
  print(b.width,m,50)
  print(b.height,m,70)
  rect(b.x,
       b.y,
       b.width,
       b.height,
       b.c)
      end
     end
version 18
__lua__
pixels ={}
col=3
row=6
w=2
h=2
c1=0
c2=1
eight={1,4,7,9,10,12,13,16,17,19,20,22,25,28}

function led(table,_x,_y,_c1,_c2)
 for i = 0, col do
  for j = 0, row do
  local pixel = {
   x=_x+i*4,
   y=_y+j*4,
   c=_c1
  }
   add(table,pixel)
  end
 end
 for k, v in pairs(table) do
  rectfill(v.x,v.y,v.x+w,v.y+h,_c1)
 end
 for n in all(eight) do
  del(table,table[n])
 end
end

function _update()
 cls()
 led(pixels,20,20,1,2)
end
function _draw()
 
end

__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
