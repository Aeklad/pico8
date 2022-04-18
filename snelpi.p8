pico-8 cartridge // http://www.pico-8.com
version 34
__lua__
-->8
--init
x=15
y=8
dx=1
dy=0
t=0
s=5
l=0
xa={}
ya={}
xo=6
yo=7
xr=flr(rnd(21))*xo
yr=flr(rnd(18))*yo
fr={133,134,135,136,137,138,140,141,143,146,147}
fruit=1+flr(rnd(#fr-1))
cl={1,2,3,4,8,9,10,11,12,13,14,15}
colr=1+flr(rnd(#cl-1))
-->8
--functions
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
-->8
--draw
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
x=x%32
 y=y%21

if x==xr/xo and y==yr/yo then
   xr=flr(rnd(21))*xo
   yr=flr(rnd(18))*yo
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
 
 for i=1,#xa do
  c=i
  c=1+c%15
  print("웃",xa[i],ya[i],c)
  if xa[i-1]==x*xo and ya[i-1]==y*yo then
   print("whoops!")
   l-=1
  end
 end
 
 print("웃",x*xo,y*yo,10)
 
 print(chr(fr[fruit]),xr,yr,cl[colr])
 artificialdumness()
 
end
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
