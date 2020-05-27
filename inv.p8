pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
fake_pi = .5
turnspeed = 5 * (fake_pi/180)
shake=0
function _init()
musicplayed=false 
gamestate=0

 inv= {
  s=6,
  x=16,
  y=110,
  w=2,
  h=2,
  flp=false,
  dx=0,
  dy=0,
  max_dx=2,
  max_dy=3,
  acc=0.5,
  boost=5,
  anim=0,
  running=false,
  jumping=false,
  falling=false,
  sliding=false,
  landing=false,
  health=200
 }
 gravity = 0.3
 friction=0.85
 t=0
 score = 0
 enemycount = 0
 maxenemycount = 0
 hitcount = 0
 bullets={}
 enemies={}
 createEnemy(1)
 motherships={}

end

function collide(b)
 local invx = inv.x-8
 local invy = inv.y-8
 local invw = inv.x+8
 local invh = inv.y+8
 return invw > b.x and invx < b.x and invh > b.y and invy < b.y
end
function createEnemy(n)
 local b = {
  s=10,
  x=flr(rnd(40)+80),
  y=102,
  w=1,
  h=1,
  flp=false,
  dx=0,
  dy=0,
  max_dx=2,
  max_dy=3,
  acc=0.1,
  boost=5,
  anim=0,
  running=false,
  jumping=false,
  falling=false,
  sliding=false,
  landing=false,
  state=0 ,
  time=time(),
 }
 for i=1,n do
  add(enemies,b)
  enemycount+=1
 end
end

function fire()
 for enemy in all(enemies) do
  local b = {
   sp=14,
   x=enemy.x+4,
   y=enemy.y+4,
   w=2,
   h=2,
   dx=0,
   dy=0,
   angle=0
  }
  if #bullets<5 then
   add(bullets,b)
   sfx(1)
  end
 end
end

function createmothership()
 local b = {
  x= 0,
  y= 64,
  sp= 42,
  w=4,
  h=2,
  dx=0,
  dy=0
 }
 add(motherships,b)
end

function updatemothership()
 for mshp in all(motherships) do
  mshp.x+=1
  if collide(mshp) then
   sfx(3)
   del(motherships,mshp)
   inv.health+=10
  end
  if mshp.x > 128 then
   del(motherships,mshp)
  end
 end
end
  
function hcenter(s)
 --screen center minus the string length
 --times half a characters width in pixels
 return 64-#s*2
end

function player_update()

 inv.dy+=gravity
 inv.dx*=friction 

 if btn(0) then
  inv.dx-=inv.acc
  inv.running=true
  inv.flp=true
 end

 if btn(1) then
  inv.dx+=inv.acc
  inv.running=true
  inv.flp=false
 end

 if inv.running and not btn(1) and not btn(0) and not inv.falling and not inv.jumping then
  inv.running=false
  inv.sliding=true
 end
 
 if btn(2) and inv.landed  then
  inv.dy-=inv.boost
  inv.landed=false
 end

 if inv.dy > 0 then
  inv.falling=true
  inv.landed=false
  inv.jumping=false
  
  if inv.y >= 94 then
   inv.landed=true
   inv.falling=false
   inv.dy=0
   inv.y=94
  end
 
 elseif inv.dy < 0 then
  inv.falling=false
  inv.jumping=true
 end

 inv.x%=(136)

 inv.x+=inv.dx
 inv.y+=inv.dy

end

function player_animate()

 if inv.running or inv.jumping then

  if time()-inv.anim > .5 then
   inv.anim=time()
   inv.s+=2
   if inv.s>8 then
    inv.s=6
   end
  end

 end

end

function enemy_update()
 for enemy in all(enemies) do
  enemy.dx*=friction

  if t%39==0 then
   enemy.state=flr(rnd(3))
  end
  
  if enemy.x>115 then
   enemy.state=1
  elseif enemy.x<5 then
   enemy.state=2
  end

  if enemy.state==1 then
   enemy.dx-=enemy.acc
   enemy.running=true
   enemy.flp=true
  end

  if enemy.state==2 then
   enemy.dx+=enemy.acc
   enemy.running=true
   enemy.flp=false
  end

  if enemy.running and enemy.state==0 and not enemy.falling and not enemy.jumping then
   enemy.running=false
   enemy.sliding=true
  end
  enemy.x += enemy.dx
  
  if collide(enemy) then

   shake=.08
   sfx(0)
   del(enemies,enemy)
   inv.health +=1
   enemycount-=1
   if enemycount <score*.10 and enemycount < 10 then
    createEnemy(2)
   else
    createEnemy(1)
   end
   score+=1
  end
  if enemy.state==flr(rnd(3)) then
   fire()
  end

 end
end

function enemy_animate()
 for enemy in all(enemies) do

  if enemy.running then

   if time()-enemy.anim > .1 then
    enemy.anim=time()
    enemy.s+=1

    if enemy.s>13 then
     enemy.s=10
    end
   end
  end
 end
end

function draw_intro()
 cls()
 print("press z to start",hcenter("press z to start"),64,6)
end

function draw_gover()
 cls()
 print("game over",hcenter("game over"),64,6)
 print("you scored "..score.." points",hcenter("you scored "..score.." points"),80,6)
 print("press x to play again",hcenter("press x to play again"),90,6)
end

function doshake()
 local shakex,shakey=16-rnd(32),16-rnd(32)
 camera(shakex*shake,shakey*shake)
 shake*=.95
 if (shake<0.05) shake=0
end

function draw_map()
 rectfill(0,110,128,111,11)
 print("<score> "..score,hcenter("<score> "..score),5,6)
 print ("<health> "..inv.health,hcenter("<health> "),115)
 spr(64,16,48,6,4)
 spr(64,94,48,6,4)
 spr(38,94,94,4,2)
end

function _update()
 if gamestate==0 then
  if btnp(4) then
   gamestate=1
  end
 end
 if gamestate==1 then
  t=t+1
  player_update()
  player_animate()
  enemy_update()
  enemy_animate()
  updatemothership()
  if #motherships < 1 and hitcount >30 then
   createmothership()
   hitcount = 0
  end
  for b in all(bullets) do
   b.dy=b.y-inv.y
   b.dx=b.x-inv.x
   diff = atan2(b.dx,b.dy)-b.angle

   if diff > fake_pi then
    diff -= fake_pi *2
   elseif diff < -fake_pi then
    diff += fake_pi *2
   end

   if diff > turnspeed then
    b.angle += turnspeed
   elseif diff < - turnspeed then
    b.angle -= turnspeed
   else
    b.angle=atan2(b.dx,b.dy)
   end
   b.x-=cos(b.angle)
   b.y-=sin(b.angle)
   if collide(b) then 
    sfx(2)
    shake=.02
    del(bullets,b)
    inv.health -=1
    hitcount +=1
   end
   if b.y> 128 or b.y<5 or b.x <0 or b.x >128 then 
    del(bullets,b)
   end
  end
 end
 if gamestate==2 then
  if btnp(5) then
   _init()
  end
 end
 if inv.health <=0 then
  if not musicplayed then
   music(00)
   musicplayed=true
  end
  gamestate=2
 end
end

function _draw()
 
 cls()
 doshake()
 if gamestate==0 then
  draw_intro()
 elseif gamestate==1 then
  draw_map()
  spr(inv.s,inv.x-8,inv.y,inv.w,inv.h)
  for enemy in all(enemies) do
   spr(enemy.s,enemy.x,enemy.y,enemy.w,enemy.h,enemy.flp)
  end
  for b in all(bullets) do
   pset(b.x,b.y,7)
  end
  for mshp in all(motherships) do
   spr(mshp.sp,mshp.x,mshp.y,mshp.w,mshp.h)
  end
 else
  draw_gover()
 end

end

__gfx__
00007700000000007700000000007700000000007700000000000077770000000000007777000000000000000000000000000000000000000006600000000000
00007700000000007700000000007700000000007700000000000077770000000000007777000000077000000000000000770000000000000006600000000000
00000077000000770000000077000077000000770000770000007777777700000000777777770000070000000077000000700000007700000006600000000000
00000077000000770000000077000077000000770000770000007777777700000000777777770000007000000070000000070000007000000000000000000000
00007777777777777700000077007777777777777700770000777777777777000077777777777700070000000707000000000000000700000000000000000000
00007777777777777700000077007777777777777700770000777777777777000077777777777700707700007070700007777000077000000000000000000000
00777700777777007777000077777700777777007777770077770077770077777777007777007777007000000770000070700000707770000000000000000000
00777700777777007777000077777700777777007777770077770077770077777777007777007777007000000707000000700000070700000000000000000000
77777777777777777777770000777777777777777777000077777777777777777777777777777777000000000000000000000000000000000000000000000000
77777777777777777777770000777777777777777777000077777777777777777777777777777770077000000000000000770000000000000000000000000000
77007777777777777700770000007777777777777700000000007700007700000077007777007700070000000077000000700000007700000000000000000000
77007777777777777700770000007777777777777700000000007700007700000077007777007700007000000070000000070000007000000000000000000000
77007700000000007700770000007700000000007700000000770077770077007700000000000070070000000707000000000000000700000000000000000000
77007700000000007700770000007700000000007700000000770077770077007700000000000070707700007070700007777000077000000000000000000000
00000077770077770000000000770000000000000077000077007700007700770077000000007700007000000770000070700000707770000000000000000000
00000077770077770000000000770000000000000077000077007700007700770077000000007700007000000707000000700000070700000000000000000000
000000000000000000000000000000000000000000000000000000000000bb000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000bb000000000000000000000000000088888888888800000000000000000000000000
0000000077777777000000000000000077777777000000000000000000bbbbbb0000000000000000000000888888888888888888880000000000000000000000
0000000077777777000000000000000077777777000000000000000000bbbbbb0000000000000000000000888888888888888888880000000000000000000000
0077777777777777777777000077777777777777777777000000000000bbbbbb0000000000000000000088888888888888888888888800000000000000000000
0077777777777777777777000077777777777777777777000000000000bbbbbb0000000000000000000088888888888888888888888800000000000000000000
77777777777777777777777777777777777777777777777700bbbbbbbbbbbbbbbbbbbbbb00000000008888008888008888008888008888000000000000000000
77777777777777777777777777777777777777777777777700bbbbbbbbbbbbbbbbbbbbbb00000000008888008888008888008888008888000000000000000000
777777000077770000777777777777000077770000777777bbbbbbbbbbbbbbbbbbbbbbbbbb000000888888888888888888888888888888880000000000000000
777777000077770000777777777777000077770000777777bbbbbbbbbbbbbbbbbbbbbbbbbb000000888888888888888888888888888888880000000000000000
777777777777777777777777777777777777777777777777bbbbbbbbbbbbbbbbbbbbbbbbbb000000000088888800008888000088888800000000000000000000
777777777777777777777777777777777777777777777777bbbbbbbbbbbbbbbbbbbbbbbbbb000000000088888800008888000088888800000000000000000000
000000777700007777000000000077777700007777770000bbbbbbbbbbbbbbbbbbbbbbbbbb000000000000880000000000000000880000000000000000000000
000000777700007777000000000077777700007777770000bbbbbbbbbbbbbbbbbbbbbbbbbb000000000000880000000000000000880000000000000000000000
000077770077770077770000007777000077770000777700bbbbbbbbbbbbbbbbbbbbbbbbbb000000000000000000000000000000000000000000000000000000
000077770077770077770000007777000077770000777700bbbbbbbbbbbbbbbbbbbbbbbbbb000000000000000000000000000000000000000000000000000000
00000000bbbbbbbbbbbbbbbbbbbbbbbbbbbb00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000bbbbbbbbbbbbbbbbbbbbbbbbbbbb00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb00000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb00000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bbbbbbbbbbbbbb00000000000000bbbbbbbbbbbbbbbb000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bbbbbbbbbbbbbb00000000000000bbbbbbbbbbbbbbbb000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bbbbbbbbbbbb000000000000000000bbbbbbbbbbbbbb000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bbbbbbbbbbbb000000000000000000bbbbbbbbbbbbbb000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bbbbbbbbbb0000000000000000000000bbbbbbbbbbbb000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bbbbbbbbbb0000000000000000000000bbbbbbbbbbbb000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bbbbbbbbbb0000000000000000000000bbbbbbbbbbbb000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bbbbbbbbbb0000000000000000000000bbbbbbbbbbbb000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
000100001353013540105600e5600b5600a55002550035500354005530095200c5400d51008510015000150002500000000000000000000000000000000000000000000000000000000000000000000000000000
000100000251003510035100451006510095101351015500076000360000600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000100000a50005520075400a5500a550075400751000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0002000003520075400a5500b5600b5600a560055600454003510035500451006510085400b5300d5200f5100f500000000000000000000000000000000000000000000000000000000000000000000000000000
00100000120500f0500d0500c05000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__music__
07 04424344

