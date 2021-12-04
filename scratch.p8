uico-8 cartridge // http://www.pico-8.com
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
 for x=0,(#text)*6 do
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
 box={
     x=64,
     y=064,
     vx=1,
     vy=1,
     maxv=1.5,
     w=55,
     h=20
    }
function randomrange(a,b)
 return flr(rnd(b-a))+1
end
 
c=1
c2=1
function _update60()
 cls()
year=stat(90)
month=stat(91)
day=stat(92)
h=stat(93)
m=stat(94)
s=stat(95)
if btn(0) then box.x-=box.vx end
if btn(1) then box.x+=box.vx end
if btn(2) then box.y+=box.vy end
if btn(3) then box.y-=box.vy end
if btnp(4) then c+=1 end
if btnp(5) then c2+=1 end
if box.vx >1.5 then box.vx=box.maxv end
if box.vy >1.5 then box.vy=box.maxv end
if box.x +box.w > 127 then box.vx*=-1 end
if box.x < 0 then box.vx*=-1 end
if box.y+box.h > 127 then box.vy*=-1 end
if box.y < 0 then box.vy*=-1 end

end
function _draw()
msg=scan_text(h..":"..m..":"..s)
msg2=scan_text(month.."/"..day.."/"..year)
msg3=scan_text("♥")
put_text(msg,box.x,box.y,1,2,4,4,c)
put_text(msg2,0,3,.5,.5,1,1,c2)
--put_text(msg3,40,40,3,3,6,6,09)
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
