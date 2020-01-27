pico-8 cartridge // http://www.pico-8.com
version 18
__lua__




function _init()
 
 inv= {
  s=0,
  x=16,
  y=64,
  w=3,
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
 enemy= {
  s=10,
  x=90,
  y=80,
  w=1,
  h=1,
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
  l=true,
  r=false
 }
 gravity = 0.3
 friction=0.85
 t=0

end

function collide_map(obj,aim,flag)

 local x=obj.x local y=obj.y
 local w=obj.w local h=obj.h
 local x1=0 local y1 =0
 local x2=0 local y2=0

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
  
  if inv.y >= 64 then
   inv.landed=true
   inv.falling=false
   inv.dy=0
   inv.y=64
  end
 
 elseif inv.dy < 0 then
  inv.falling=false
  inv.jumping=true
 end

 inv.x+=inv.dx
 inv.y+=inv.dy

end

function player_animate()

 if inv.running or inv.jumping then

  if time()-inv.anim > .5 then
   inv.anim=time()
   inv.s+=3
   if inv.s>3 then
    inv.s=0
   end
  end

 end

end

function enemy_update()

 if enemy.x>120 then
  enemy.r=false
  enemy.l=true
 elseif enemy.x<5  then
  enemy.l=false
  enemy.r=true
 end
 
 
 if btn(0) then
  enemy.dx-=enemy.acc
  enemy.running=true
  enemy.flp=true
 end

 if btn(1) then
  enemy.dx+=enemy.acc
  enemy.running=true
  enemy.flp=false
 end

 if not enemy.r and not enemy.l then
  enemy.dx=0
 end
 enemy.x += enemy.dx

end

function enemy_animate()

 if enemy.running then

  if time()-inv.anim > .1 then
   enemy.anim=time()
   enemy.s+=1

   if enemy.s>13 then
    enemy.s=10
   end
  end
 end
end


function draw_map()
 rectfill(0,80,128,82,11)
end

function _update()
 t=t+1
 player_update()
 player_animate()
 enemy_update()
 enemy_animate()
end

function _draw()
 
 cls()
 print(inv.boost)
 draw_map()
 spr(inv.s,inv.x,inv.y,inv.w,inv.h)
 spr(enemy.s,enemy.x,enemy.y,enemy.w,enemy.h,enemy.flp)

end

__gfx__
00007700000000007700000000007700000000007700000000000077770000000000007777000000000000000000000000000000000000000000000000000000
00007700000000007700000000007700000000007700000000000077770000000000007777000000077000000000000000770000000000000000000000000000
00000077000000770000000077000077000000770000770000007777777700000000777777770000070000000077000000700000007700000000000000000000
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