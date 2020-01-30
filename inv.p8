pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

function _init()
 
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
  landing=false
 }
 gravity = 0.3
 friction=0.85
 t=0
 score = 0
 enemycount = 0
 maxenemycount = 0
 bullets={}
 enemies={}
 createEnemy(1)

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
  x=16+flr(rnd(80)),
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
  state=0 
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
   dy=-3,
  }
  add(bullets,b)
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
 maxenemycount=enemycount/5
 for enemy in all(enemies) do

  enemy.dx*=friction

  if t%39==0 then
   enemy.state=flr(rnd(3))
   --fire() 
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
   del(enemies,enemy)
   enemycount-=1
   if enemycount <score*10 then
    createEnemy(2)
   else
    createEnemy(1)
   end
   score+=1
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

function draw_map()
 rectfill(0,110,128,111,11)
 print("<score> "..score,hcenter("<score> "..score),5,6)
 spr(64,16,48,6,4)
 spr(64,94,48,6,4)
 spr(38,16,112,4,2)
end

function _update()
 t=t+1
 player_update()
 player_animate()
 enemy_update()
 enemy_animate()
 for b in all(bullets) do
  b.x+=b.dx
  b.y+=b.dy
  if collide(b) then 
   del(bullets,b)
  end
  if b.y <5 then
   del(bullets.b)
  end
 end
end

function _draw()
 
 cls(1)
 print(score*.10)
 print(enemycount,0,20)
 draw_map()
 spr(inv.s,inv.x-8,inv.y,inv.w,inv.h)
 for enemy in all(enemies) do
  spr(enemy.s,enemy.x,enemy.y,enemy.w,enemy.h,enemy.flp)
 end
 for b in all(bullets) do
  pset(b.x,b.y,7)
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
