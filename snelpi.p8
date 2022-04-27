pico-8 cartridge // http://www.pico-8.com
version 33
__lua__
--poke4(0x5f10,0x8382.8180)
--poke4(0x5f14,0x8786.8584)
--poke4(0x5f18,0x8b8a.8988)
--poke4(0x5f1c,0x8f8e.8d8c)
function _init()
 bc=1
 x=10
 y=10
 dx=1
 dy=0
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
 title=0
 playing=1
 gameover=2
 state=title
 t=0
 distance=abs(x*xo-xr)>abs(y*yo-yr)
end

function init_play()
 cls()
 x=10
 y=10
 dx=1
 dy=0
 xa={}
 ya={}
 l=5
 xr=6+flr(rnd(18))*xo
 yr=6+flr(rnd(18))*yo
 fr={133,134,135,136,137,138,140,141,143,146,147}
 fruit=1+flr(rnd(#fr-1))
 cl={1,2,3,4,8,9,10,11,12,13,14,15}
 colr=1+flr(rnd(#cl-1))
 collide=false
end

function artificialdumness()
 if y*yo<yr then
  dy=1
  dx=0
 elseif y*yo>yr then
  dy=-1
  dx=0
 else
  dy=0
 end
 if x*xo<xr then 
  dx=1
  dy=0
 elseif x*xo> xr then
  dx=-1
  dy=0
 else
  dx=0
 end
end

function ternary()
 if distance then
  dy=0
  dx=x*xo<xr and 1 or -1 
  distance=x*xo != xr
 else
  dx=0
  dy=y*yo<yr and 1 or -1
  distance=y*yo != yr
 end
end

function _update()
 
 cls()
 t+=1
 if t>s then t=0 end
 
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
  distance=abs(x*xo-xr)>abs(y*yo-yr)
 end

 if t==s then
  add(xa,x*xo)
  add(ya,y*yo)
 end

 if #xa > l then
  del(xa,xa[1])
  del(ya,ya[1])
 end
 if l!=0 and l%16 !=0 then 
  bc=l
 end
 if state==title then
  --artificialdumness()
  ternary()
  if btnp(4) then
   init_play()
   state=playing
  end
 elseif state==playing then
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
 else 
  state=gameover
  t=0
  dx=0
  dy=0
  if btnp(4) then 
   _init()
  end
 end
end

function _draw()
 for i=0,19 do 
  print("█",i*8,0,bc)
  print("█",i*8,120,bc)
  print("█",0,i*6,bc)
  print("█",120,i*6,bc)
 end
 
 for i=1,#xa do
  c=i
  c=1+c%15
  collide= xa[i-1]==x*xo and ya[i-1]==y*yo or (x%22==0 or y%21==0)
  print("웃",xa[i],ya[i],c)
  if collide or opp_dir then
   if state==playing then
    state=gameover 
   elseif state==title then
    _init()
   end
  end
 end
 print(chr(fr[fruit]),xr,yr,cl[colr])
 print("웃",x*xo,y*yo,10)
 if state==gameover then
  print("game over",40,10,bc)
  print("press x to play again",15,20,bc)
 elseif state==title then
  print("welcome to snelpscii snake",12,10,bc)
  print("press x to play",30,20,bc)
 end
 print(distance)
end
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
