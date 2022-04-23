pico-8 cartridge // http://www.pico-8.com
version 33
__lua__
poke4(0x5f10,0x8382.8180)
poke4(0x5f14,0x8786.8584)
poke4(0x5f18,0x8b8a.8988)
poke4(0x5f1c,0x8f8e.8d8c)
x=10
y=10
dx=1
dy=0
t=0
s=5
l=5
xa={}
ya={}
xo=6
yo=6
xr=6+flr(rnd(18))*xo
yr=6+flr(rnd(18))*yo
fr={133,134,135,136,137,138,140,141,143,146,147}
fruit=1+flr(rnd(#fr-1))
cl={1,2,3,4,8,9,10,11,12,13,14,15}
colr=1+flr(rnd(#cl-1))
collide=false
function artificialdumness()
 if x*xo<xr then 
  dx=1
  dy=0
 elseif x*xo> xr then
  dx=-1
  dy=0
 else
  dx=0
 end
 if y*yo<yr then
  dy=1
  dx=0
 elseif y*yo>yr then
  dy=-1
  dx=0
 else
  dy=0
 end
end

function _draw()
 cls()
 t+=1
 if t>s then t=0 end
     
 if btnp(0) then
  dx=-1
  dy=0
 end
 if btnp(1) then
  dx=1
  dy=0
 end
 if btnp(2) then
  dy=-1
  dx=0
 end
 if btnp(3) then
  dy=1
  dx=0
 end
 
 if t==0 then
  x+=dx
  y+=dy
 end
 x=x%22
 y=y%21

 if x==xr/xo and y==yr/yo then
   xr=6+flr(rnd(18))*xo
   yr=6+flr(rnd(18))*yo
   fruit=1+flr(rnd(#fr-1))
   colr=1+flr(rnd(#cl-1))
   l+=1
 end

 if t==s then
  add(xa,x*xo)
  add(ya,y*yo)
 end

 if #xa > l then
  del(xa,xa[1])
  del(ya,ya[1])
 end
 for i=0,19 do 
  print("█",i*8,0,10)
  print("█",i*8,120,10)
  print("█",0,i*6,10)
  print("█",120,i*6,10)
 end
 
 for i=1,#xa do
  c=i
  c=1+c%15
  collide= xa[i-1]==x*xo and ya[i-1]==y*yo or (x%22==0 or y%21==0)
  print("웃",xa[i],ya[i],c)
  if collide or opp_dir then
   print("whoops!")
   l-=1
  end
 end
 print(chr(fr[fruit]),xr,yr,cl[colr])
 print("웃",x*xo,y*yo,10)
 --artificialdumness()
 --print("█",6,6+(18*yo),8)
end
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
