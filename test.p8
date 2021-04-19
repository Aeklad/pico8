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
debug = {}
score = 0

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
        alive = true,
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

function spawnasteroid(scale)
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
        scale = scale,
        radius = (asteroidrad + asteroidradplus)/scale,
         points = {}
 }
 add(asteroid.points,
 {
  x= asteroidrad/scale,
  y= 0
 }
 )
 local angle = 0
 local radius= 0
 local vector = {}

 for point=1, (asteroidnumpoints -1) do

  radius = ((asteroidrad-asteroidradminus)+rnd(asteroidradplus))/scale
  
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
 x= asteroidrad/scale,
 y= 0
}
)
 return asteroid
end

function generateasteroids()
 local asteroid 
 for count = 1, numasteriods do
  asteroid = spawnasteroid(1)
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

function drawgameinfo()
 print("score : "..score)
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

function pointinpolygon(point, shape)
 local firstpoint = true
 local lastpoint =0
 local rotatedpoint = 0
 local onright = 0
 local onleft = 0 
 local xcrossing = 0
 for k, shapepoint in ipairs(shape.points) do 
  rotatedpoint=rotatepoint(shapepoint,shape.rot)
  if firstpoint then
   lastpoint = rotatedpoint
   firstpoint= false
  else
   startpoint = {
    x=lastpoint.x + shape.pos.x,
    y=lastpoint.y + shape.pos.y,
   }
  endpoint = {
    x=rotatedpoint.x+shape.pos.x,
    y=rotatedpoint.y+shape.pos.y,
   }
   if ((startpoint.y >= point.y)and (endpoint.y < point.y))
    or ((startpoint.y < point.y) and (endpoint.y >=point.y)) then
    -- line crosses ray
    if (startpoint.x <= point.x) and (endpoint.x <= point.x) then
     -- line is to left
     onleft +=1 
    elseif (startpoint.x >= point.x) and (endpoint.x >= point.x) then
     -- line is to right
     onright+=1
    else
     -- need to calculate crossing x coordinate
     if (startpoint.y != endpoint.y) then
      -- filter out horizontal line
      xcrossing = startpoint.x +
      ((point.y - startpoint.y)
      *(endpoint.x - startpoint.x)
      /(endpoint.y - startpoint.y))
      if (xcrossing >- point.x) then
       onright +=1
      else
       onleft +=1
      end
     end
    end
   end
   lastpoint = rotatedpoint
  end
 end
 -- check if inside
 if (onright % 2)==1 then
  -- odd = inside
  return true
 else
  return false
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
 
function polygoninpolygon(shape1,shape2)
 local testpoint = {}
 local rotatedpoint = {}
 for index,point in ipairs(shape1.points) do
  rotatedpoint= rotatepoint(point,shape1.rotation)
  testpoint= {
   x = rotatedpoint.x + shape1.pos.x,
   y= rotatedpoint.y + shape1.pos.y
  }
  if pointinpolygon(testpoint,shape2) then
   return true
  end
 end
 for index,point in ipairs(shape2.points) do
  rotatedpoint= rotatepoint(point,shape2.rotation)
  testpoint= {
   x = rotatedpoint.x + shape1.pos.x,
   y= rotatedpoint.y + shape1.pos.y
  }
  if pointinpolygon(testpoint,shape1) then
   return true
  end
 end
 return false
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
  s=true
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
 local pos=asteroid.pos
 local orgscale = asteroid.scale
 deli(asteroids,index)
 local newscale = orgscale*2 
 sfx(1)
 if orgscale < 4 then
  local asteroid 
  for count = 1, 2 do
   asteroid = spawnasteroid(newscale)
   asteroid.vel = {
    speed= (rnd()*(asteroidmaxvel-asteroidminvel))+asteroidminvel,
    direction = rnd()*1
   }
   asteroid.rotspeed=(rnd()*(2*asteroidmaxrot))-asteroidmaxrot
   asteroid.pos=pos
   add(asteroids,asteroid)
  end
 end
end

function updatescore()
end

function checkshiphits()
 for aindex, asteroid in ipairs(asteroids) do
  if checkseparation(ship.pos,asteroid.pos,asteroidrad+asteroidradplus) then
   if polygoninpolygon(ship,asteroid) then
    explodeasteroid(aindex,asteroid)
    score=score+(50*asteroid.scale)
    break
   end
  end
 end
end

function checkbullethits()
 for bindex, bullet in ipairs(playerbullets) do
  for aindex, asteroid in ipairs(asteroids) do
   if checkseparation(bullet.pos,asteroid.pos,asteroidrad+asteroidradplus) then
    if pointinpolygon(bullet.pos,asteroid) then
      deli(playerbullets,bindex)
      explodeasteroid(aindex,asteroid)
      score=score+(50*asteroid.scale)
      break
     end
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
 checkshiphits()
 if #asteroids <1 then
  initgame()
 end
end
 
function _draw()
 cls()
 drawshape(ship)
 drawbullets()
 drawasteroids()
 drawgameinfo()
 for txt in all(debug) do
  print(txt)
 end
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
