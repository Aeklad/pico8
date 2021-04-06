pico-8 cartridge // http://www.pico-8.com
version 32
__lua__
statestart=0
stateplay=10
stateend=20
gamestate=statestart
screen_max_x=128
screen_max_y=128
numasteriods = 10
asteroidnumpoints =12 
asteroidrad=8
asteroidradplus =6 
asteroidradminus=3
asteroidmaxvel=.5
asteroidminvel=.1
asteroidmaxrot=.005
asteroids = {}

ship = {
 pos = {
  x=40,
  y=60
 },
 vel= {
  speed =0,
  direction =0
 },
 acc=0.05,
 dec=0.001,
 rotspeed = .03,
 rot = 0,
 col = 6,
  points = {
   {x=2,y=0},
   {x=-2,y=1},
   {x=-1,y=0},
   {x=-2,y=-1},
   {x=2,y=0}
 },
}
playerbullets = {}
maxplayerbullets=4
playerbulletspeed=2
playerbullettime=60
playerbulletoffset = {
 x=2,
 y=0
}
function initgame()
 generateasteroids()
end

function spawnbullet()
 local bullet = {
        time = 0,
        pos = {
         x=0,
         y=0
        },
        vel= {
         speed =0,
         direction =0
        },
        col = 6,
}
return bullet
end

function fireplayerbullet()
 local bullet 
 if #playerbullets < maxplayerbullets then
   bullet = spawnbullet()
   bullet.time=playerbullettime 
   bullet.pos.x=ship.pos.x
   bullet.pos.y=ship.pos.y
   bullet.vel.speed=playerbulletspeed
   bullet.vel.direction=ship.rot
   add(playerbullets,bullet)
   sfx(0)
  end
end

function spawnasteroid()
 local asteroid = {
        pos = {
         x=0,
         y=0
        },
        vel= {
         speed =0,
         direction =0
        },
        acc=0.05,
        dec=0.001,
        rotspeed = .01,
        rot =0 ,
        col = 6,
         points = {}
 }
 add(asteroid.points,
 {
  x= asteroidrad,
  y= 0
 }
 )
 local angle = 0
 local radius= 0
 local vector = {}

 for point=1, (asteroidnumpoints -1) do

  radius = (asteroidrad-asteroidradminus)+rnd(asteroidradplus)
  
  angle =(1/asteroidnumpoints)*point
  vector = {
   speed= radius,
   direction=angle
  }

  components=getvectorcomp(vector)
  add(asteroid.points,
  {
   x=components.xcomp,
   y=components.ycomp
  }
 )
end
 
add(asteroid.points,
{
 x= asteroidrad,
 y= 0
}
)
 return asteroid
end

function generateasteroids()
 local asteroid 
 for count = 1, numasteriods do
  asteroid = spawnasteroid()
  asteroid.vel = {
   speed= (rnd()*(asteroidmaxvel-asteroidminvel))+asteroidminvel,
   direction = rnd()*1
  }
  asteroid.rotspeed=(rnd()*(2*asteroidmaxrot))-asteroidmaxrot
  if count <(numasteriods/2) then
   asteroid.pos.x=rnd(screen_max_x-1)
   asteroid.pos.y=0
  else
   asteroid.pos.y=rnd(screen_max_y-1)
   asteroid.pos.x=0
  end

  add(asteroids,asteroid)
 end
end

function drawasteroids()
 for index, asteroid in ipairs(asteroids) do
  drawshape(asteroid)
 end
end

function drawbullets()
 for index, bullet in ipairs(playerbullets) do
  pset(bullet.pos.x,bullet.pos.y,bullet.col)
 end
end

function drawshape(shape)
 local firstpoint = true
 local rotatedpoint = 0
 local lastpoint =0
 for k, point in ipairs(shape.points) do 
  rotatedpoint=rotatepoint(point,shape.rot)
  if firstpoint then
   lastpoint = rotatedpoint
   firstpoint= false
  else
   line(lastpoint.x + shape.pos.x,
   lastpoint.y + shape.pos.y,
   rotatedpoint.x+shape.pos.x,
   rotatedpoint.y+shape.pos.y,
   shape.col)
   lastpoint=rotatedpoint
  end
 end
end

function rotatepoint(point,rotation)
 rotatedpoint ={
 x=
 (point.x*cos(rotation))-(point.y*sin(rotation)),
 y =
 (point.y*cos(rotation))+(point.x*sin(rotation))
 }
 return rotatedpoint
end
 
function range(range)
 if range > 1 then
  range-=1
 end
 if range < 0 then 
  range+=1
 end
 return range
end

function thrust()
 local acc = {
  speed = ship.acc,
  direction = ship.rot
 }
 ship.vel=addvectors(ship.vel,acc)
 sfx(2)
 sfx(3)
end

function checkbuttons()
 if btn(0) then ship.rot+=ship.rotspeed end
 if btn(1) then ship.rot-=ship.rotspeed end
 if btn(2) then thrust() end
 ship.rot=range(ship.rot)
 if btnp(4) then 
  fireplayerbullet()
 end
end

function addvectors(vector1,vector2)
 v1comp = getvectorcomp(vector1)
 v2comp = getvectorcomp(vector2)
 resultantx = v1comp.xcomp +v2comp.xcomp
 resultanty = v1comp.ycomp +v2comp.ycomp
 local resvector = comptovector(resultantx,resultanty)
 return resvector
end

function getvectorcomp(vector)
 local xcomp = vector.speed*cos(vector.direction)
 local ycomp= vector.speed*sin(vector.direction)
 local components = {
  xcomp = xcomp,
  ycomp = ycomp
 }
 return components
end

function comptovector(x,y)
 local magnitude = sqrt((x*x)+(y*y))
 local direction = atan2(x,y)
 direction = range(direction)
 local vector = {
  speed = magnitude,
  direction = direction
 }
 return vector
end

function movepointbyvelocity(object)
 comp = getvectorcomp(object.vel)
 local newpos= {
  x=object.pos.x + comp.xcomp,
  y=object.pos.y + comp.ycomp
 }
 return newpos
end
 
function moveship()
 ship.vel.speed -= ship.dec
 if ship.vel.speed < 0 then ship.vel.speed =0 end
 
 ship.pos = movepointbyvelocity(ship)
 wrapposition(ship)
end

function moveasteroid()
 for index, asteroid in ipairs(asteroids) do
  asteroid.pos=movepointbyvelocity(asteroid)
  asteroid.rot+=asteroid.rotspeed
  wrapposition(asteroid)
 end
end

function movebullet()
 for index, bullet in ipairs(playerbullets) do
  bullet.time -=1
  if bullet.time < 0 then
   del(playerbullets,bullet)
  end
  bullet.pos=movepointbyvelocity(bullet)
  wrapposition(bullet)
 end
end

function wrapposition(object)
 object.pos.x%=(screen_max_x)
 object.pos.y%=(screen_max_y)
end

function checkseparation (p1,p2,sep)
 local sepsq = sep*sep
 local dsq = 
       ((p1.y-p2.y)*(p1.y-p2.y))+
       ((p1.x-p2.x)*(p1.x-p2.x))
 return (dsq<=sepsq)
end

function explodeasteroid(index,asteroid)
 deli(asteroids,index)
 sfx(1)
end


function checkbullethits()
 local x,y,x1,y1
 for bindex, bullet in ipairs(playerbullets) do
  x=bullet.pos.x
  y=bullet.pos.y
  for aindex, asteroid in ipairs(asteroids) do
   x1=asteroid.pos.x
   y1=asteroid.pos.y
   if checkseparation(bullet.pos,asteroid.pos,asteroidrad+asteroidradplus) then
   --d = sqrt((x1-x)*(x1-x)+(y1-y)*(y1-y))
   --if d < components.xcomp then
     explodeasteroid(aindex,asteroid)
     del(playerbullets,bullet)
   end
  end
 end
end

function randommoveship()
 local t=0
 t+=1
 if t%(flr(rnd(10)+20))==0 then
  speed = rnd(7)
  if t%2==0 then 
   ship.rot=rnd(1)
  end
 end
 checkbuttons()
 moveship()
end

initgame()

function _update()
 moveship()
 checkbuttons()
 moveasteroid()
 movebullet()
 checkbullethits()
 if #asteroids <1 then
  initgame()
 end
end
 
function _draw()
 cls()
 drawshape(ship)
 drawbullets()
 drawasteroids()
end


__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
580100002d5702b5702a57029560285602755026540245402254021540205401e5301c5301b520195201752015510155001450011500105000e5000d5000b5000a50005500005000250001500005000050002500
9e040000136701b6701b6701a6701b6701b6701a660176601566013650126400b6401263011630116200a6100a650016000060000600006000060000600006000060000600006000060000600006000060000600
a60300000065000650006500065000650006400064000630006300062000620006100061000610006100060000600006000160001600016000060000600006000060000600006000060000600006000060000600
960300000072000720007200072000720007200071000710007100071000710007100070000700007000070001700017000170000700007000070000700007000070000700007000070000700007000000000000
