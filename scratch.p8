pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
		
floorsd={}

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


     
function drawnum()
 for n in all (nums) do
  print(n.x,n.y,n.n)
 end
end

function scan_text(text)
 cls()
 print(text,0,0,1)
 local scan={}
 for x=0,(#text)*4 do
  scan[x]={}
  for y=0,6 do
   scan[x][y]=pget(x,y)
  end
 end
 cls()
 return scan
end
function put_text(text,x,y,w,h,xscl,yscl,c)
 local i,j
 for i=0,#text do
  for j=0,6 do
   if text[i][j]==1 then 
    rectfill(i*xscl+x,j*yscl+y,(i*xscl+x)+w,(j*yscl+y)+h,c)
   end
  end
 end
end


function dice()
 return flr(rnd(8)+1)
end
			
 for i=0, 7 do
  floorsd[i]=dice()
  circ(40,40,dice())
  print(floorsd[i])
 end
 msg=scan_text('yorp')
 
function _update()
 cls()
year=stat(90)
month=stat(91)
day=stat(92)
h=stat(93)
m=stat(94)
s=stat(95)

end
function _draw()
msg=scan_text(h..":"..m..":"..s)
msg2=scan_text(month.."/"..day.."/"..year)
put_text(msg,0,30,1,2,2,2,12)
put_text(msg2,0,0,.5,.5,3,3,2)
end

__gfx__
00000000020b32020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000bb320b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0070070002b230b20000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000b33310000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0007700002bb33100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0070070000b231000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000bb331200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000002b311000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
