pico-8 cartridge // http://www.pico-8.com
version 33
__lua__
--init
--***********changes to alternate pallete
--poke4(0x5f10,0x8382.8180)
--poke4(0x5f14,0x8786.8584)
--poke4(0x5f18,0x8b8a.8988)
--poke4(0x5f1c,0x8f8e.8d8c)
--***********sets button press delay to 100
poke(0x5f5c,100)
poke(0x5f5d,100)
--states
statestart=0
stateplay=10
stateshipkilled=12
stateshipkilldelay=15
stateleveldelay=18
stateend=20
statewaitforrespawn=16
gamestate=state_init
--game stuff
screen_max_x=128
screen_max_y=128
cleared=false
levelcount =1
alienspawninterval = 4000
newlevelspd=1
leveltimer = 0
score = 0
endscreentimer=0
beat_1=200
beat_2=100
--asteroids
numasteriods = 1
asteroidnumpoints =12 
asteroidrad=12
asteroidradplus =8 
asteroidradminus=7
asteroidmaxvel=.25
asteroidminvel=.05
asteroidmaxrot=.005
--player
playerlives=3
delaytimer=0
respawnpos= {x=60,y=60}
maxplayerbullets=4
playerbulletspeed=2
playerbullettime=55
playerbulletoffset = {
 x=2,
 y=0
}
--enemy
maxenemybullets=2
enemybullettime=55

function _update60()
 cls(0)
 if gamestate == state_init then
  initgame()
  gamestate = statestart 
 elseif gamestate == statestart then
  dostartscreen()
  movenonplayerstuff()
 elseif gamestate == stateplay then
  doplaygame()
 elseif gamestate == stateshipkilled then
  doshipkilled()
 elseif gamestate == stateshipkilldelay then
  doshipkilldelay()
 elseif gamestate== statewaitforrespawn then
  movenonplayerstuff()
  if not checkrespawn() then
    doshiprespawn()
  end
 elseif gamestate == stateleveldelay then
  donewleveldelay()
 elseif gamestate == stateend then
  drawgameinfo()
  doendscreen()
  if cleared then
   delaytimer-=1
   if delaytimer <=0 then
    endgameasteroids()
   end
  end
 end
end
 
function _draw()
 drawparticles()
 drawshipparts()
 drawtheship()
 drawalienship()
 drawbullets(playerbullets)
 drawbullets(enemybullets)
 drawasteroids()
 drawgameinfo()
 for txt in all(debug) do
  print(txt)
 end
end

-->8
--update
function checkbuttons()
 if btn(0) then ship.rot+=ship.rotspeed end
 if btn(1) then ship.rot-=ship.rotspeed end
 if btn(2) then 
  thrust() 
 end
 ship.rot=range(ship.rot)
 thrustjet.rot = ship.rot
 if btnp(4) then 
  fireplayerbullet()
 end
 if btnp(5) then
  hyperspace()
 end
end

function movepointbyvelocity(object,spd)
 local comp = getvectorcomp(object.vel)
 local newpos= {
  x=object.pos.x + (comp.xcomp)/spd,
  y=object.pos.y + (comp.ycomp)/spd
 }
 return newpos
end
 
function moveship()
 ship.vel.speed -= ship.dec
 if ship.vel.speed < 0 then ship.vel.speed =0 end
 
 ship.pos = movepointbyvelocity(ship,1)
 wrapposition(ship)
 thrustjet.pos = ship.pos
end

function movealienship()
 if not alienship.active then
  alienship.spawntimer -=1
  if alienship.spawntimer <= 0 then
   if leveltimer > alienspawninterval/levelcount then
    spawnalienship(1.5,2,20,40,100)
   else
    spawnalienship(1,2,50,100,50)
   end
  end
 else
  alienship.spawnbullettime-=1
  alienship.directiontimer -=1
  alienship.pos = movepointbyvelocity(alienship,1)
  wrapposition(alienship)
  if alienship.spawnbullettime <= 0 then
   fireenemybullet()
   alienship.spawnbullettime= randomrange(alienship.minrange,alienship.maxrange)
  end
  if alienship.directiontimer <= 0 then
   alienship.directiontimer = randomrange(50,100)
   if alienship.vel.direction > .25 and alienship.vel.direction < .75 then
    alienship.vel.direction = alienship.leftdir[1+flr(rnd(3))]
   else
    alienship.vel.direction = alienship.rightdir[1+flr(rnd(3))]
   end
  end
 end
end

function moveasteroid()
 for index, asteroid in ipairs(asteroids) do
  asteroid.pos=movepointbyvelocity(asteroid,1)
  asteroid.rot+=asteroid.rotspeed
  wrapposition(asteroid)
 end
end

function moveshipparts()
 for index, shippart in ipairs(shipparts) do
  shippart.time -=1
  if shippart.time<0 then
   del(shipparts,shippart)
  end
  shippart.pos=movepointbyvelocity(shippart,2)
  shippart.rot+=shippart.rotspeed
  wrapposition(shippart)
 end
end

function moveparticle()
 for index, particle in ipairs(particles) do
  particle.time -=1
  if particle.time <0 then 
   del(particles,particle)
  end
  particle.pos=movepointbyvelocity(particle,1)
  wrapposition(particle)
 end
end

function movebullet(bullettype)
 for index, bullet in ipairs(bullettype) do
  bullet.time -=1
  if bullet.time < 0 then
   del(bullettype,bullet)
  end
  bullet.pos=movepointbyvelocity(bullet,1)
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

function explodeasteroid(index,asteroid,playerkill)
 local pos=asteroid.pos
 local orgscale = asteroid.scale
 deli(asteroids,index)
 local newscale = orgscale*2 
 local newspeed =orgscale*1.1
 if playerkill then
  updatescore(asteroid.scale,50)
 end
 sfx(1)
 spawnparticles(asteroid.pos,asteroid.vel,50,10/asteroid.scale)
 if orgscale < 3 then
  local asteroid 
  for count = 1, 2 do
   asteroid = spawnasteroid(newscale)
   asteroid.vel = {
    speed= (((rnd()*(asteroidmaxvel-asteroidminvel))+asteroidminvel)*newspeed)*newlevelspd,
    direction = rnd()*1
   }
   asteroid.rotspeed=(rnd()*(2*asteroidmaxrot))-asteroidmaxrot
   asteroid.pos=pos
   add(asteroids,asteroid)
  end
 elseif #asteroids <=0 then
  if gamestate != stateend then
   endlevel()
  else
   cleared=true
   delaytimer=120
  end
 end
end

function explodealien(playerkill)
 if alienship.active then
  alienship.active = false
  deli(playerbullets,bindex)
  sfx(1)
  spawnshipparts(alienship.pos,alienship.vel,120)
  if playerkill then
   updatescore(alienship.value,1)
  end
 end
end

function updatescore(object,multiplier)
 score=score+(multiplier*object)
end

function checkshiphits()
 for aindex, asteroid in ipairs(asteroids) do
  if checkseparation(ship.pos,asteroid.pos,asteroid.radius) then --asteroidrad+asteroidradplus) then
   if polygoninpolygon(ship,asteroid) then
    spawnshipparts(ship.pos,ship.vel,120)
    explodeasteroid(aindex,asteroid,true)
    gamestate=stateshipkilled
    break
   end
  end
 end
 if checkseparation(ship.pos,alienship.pos,alienship.radius) then
  if polygoninpolygon(ship,alienship) then
   if alienship.active then
    explodealien(true)
    gamestate=stateshipkilled
   end
  end
 end
 for index, bullet in ipairs(enemybullets) do
  if checkseparation(bullet.pos,ship.pos,ship.radius) then --asteroidrad+asteroidradplus) then
   if pointinpolygon(bullet.pos,ship) then
    del(enemybullets,bullet)
    spawnshipparts(ship.pos,ship.vel,120)
    gamestate=stateshipkilled
    break
   end
  end
 end
end

function checkalienshiphits()
 for aindex, asteroid in ipairs(asteroids) do
  if checkseparation(alienship.pos,asteroid.pos,asteroid.radius) then --asteroidrad+asteroidradplus) then
   if polygoninpolygon(alienship,asteroid) then
    explodeasteroid(aindex,asteroid)
    explodealien(false)
    break
   end
  end
 end
end

function checkbullethits(bullettype)
 for bindex, bullet in ipairs(bullettype) do
  for aindex, asteroid in ipairs(asteroids) do
   if checkseparation(bullet.pos,alienship.pos,alienship.radius) then
    if pointinpolygon(bullet.pos,alienship) then
     if bullettype == playerbullets then
      explodealien(true)
      --score+=50
     end
     break
   end
  end
   if checkseparation(bullet.pos,asteroid.pos,asteroid.radius) then
    if pointinpolygon(bullet.pos,asteroid) then
      deli(bullettype,bindex)
      if bullettype == playerbullets then
       explodeasteroid(aindex,asteroid,true)
      else
       explodeasteroid(aindex,asteroid,false)
      end
      break
     end
   end
  end
 end
end

function checkbullethitsalien()
 for bindex, bullet in ipairs(playerbullets) do
   if checkseparation(bullet.pos,alienship.pos,alienship.radius) then
    if pointinpolygon(bullet.pos,alienship) then
     explodealien()
     --score+=50
     break
   end
  end
 end
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

function hyperspace()
 local x = randomrange(0,127)
 local y = randomrange(0,127)
 resetplayership(x,y,ship.rot)

end

function fireenemybullet()
 local bullet 
 if #enemybullets < maxenemybullets then
   bullet = spawnbullet()
   bullet.time=enemybullettime 
   bullet.pos.x=alienship.pos.x
   bullet.pos.y=alienship.pos.y
   bullet.vel.speed=alienship.bulletspeed
   bullet.vel.direction = rnd(1)
   add(enemybullets,bullet)
   sfx(4)
  end
end

function checkrespawn()
 for aindex, asteroid in ipairs(asteroids) do
  if checkseparation(respawnpos,asteroid.pos,asteroid.radius+2) then --asteroidrad+asteroidradplus) then
   return true
  end
 end
 if checkseparation(respawnpos,alienship.pos,alienship.radius) then
  return true
 end
end

function soundtrack()
 if leveltimer%beat_1==0 then
  sfx(5)
 elseif leveltimer%beat_2==0 then
  sfx(6)
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

-->8
--draw
function hcenter(s)
 --screen center minus the string length
 --times half a characters width in pixels
 return 64-#s*2
end

function drawlives(x,y,width,length)
 for i=1, playerlives do
  line(x+i*6,y,(x+width)+i*6,y+length)
  line(x+i*6,y,(x-width)+i*6,y+length)
 end
end

function drawasteroids()
 for index, asteroid in ipairs(asteroids) do
  drawshape(asteroid)
 end
end

function drawshipparts()
 for index, shippart in ipairs(shipparts) do
  drawshape(shippart)
 end
end

function drawgameinfo()
 drawlives(100,0,1,3)
 print("score : "..score,0,0)
end

function drawbullets(bullettype)
 for index, bullet in ipairs(bullettype) do
  pset(bullet.pos.x,bullet.pos.y,bullet.col)
 end
end

function drawparticles()
 for index, particle in ipairs(particles) do
  pset(particle.pos.x,particle.pos.y,particle.col)
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

function drawtheship()
 if gamestate==stateplay or gamestate==stateleveldelay then
  drawshape(ship)
  if btn(2) and sin(time()*5)>0 then
   drawshape(thrustjet)
  end
 end
end

function drawalienship()
 if alienship.active then
  drawshape(alienship)
 end
end

-->8
--game states

function dostartscreen()
 alienship.spawntimer = 120
 alienship.active=false
 print("asteroids", hcenter("asteroids"),60)
 print("press z to start", hcenter("press z to start"),80)
 if btnp(4) then
  initgame()
  alienship.active=false
  gamestate=stateplay
 end
end

function movenonplayerstuff()
 moveparticle()
 moveshipparts()
 moveasteroid()
 movealienship()
 movebullet(playerbullets)
 movebullet(enemybullets)
 checkbullethits(playerbullets)
 checkbullethits(enemybullets)
 --checkbullethitsalien()
end

function movenonasteroidstuff()
 moveparticle()
 moveshipparts()
 movebullet(playerbullets)
 movebullet(enemybullets)
 movealienship()
 checkbullethits(playerbullets)
 checkbullethits(enemybullets)
 --checkbullethitsalien()
 checkbuttons()
 moveship()
end

function doplaygame()
 leveltimer +=1
 soundtrack()
 moveship()
 checkbuttons()
 movenonplayerstuff()
 checkshiphits()
 if alienship.active then
  checkalienshiphits()
 end
end

function doendscreen()
 movenonplayerstuff()
 if alienship.active then
  checkalienshiphits()
 end
 print("game over",hcenter("game over"),40)
 print("press z to start",hcenter("press z to start"),80)
 endscreentimer -= 1
 if endscreentimer < 0 then
  initgame()
  gamestate=statestart 
 end
 if btnp(4) then
  initgame()
  alienship.active =false 
  gamestate=stateplay
 end
end

function endlevel()
  cleared=true
  delaytimer=120
  gamestate=stateleveldelay
end

function doshipkilldelay()
 movenonplayerstuff()
 delaytimer-=1
 if delaytimer==0 then
  if playerlives <= 0 then
   gamestate= stateend 
  else
   gamestate=statewaitforrespawn  
  end
 end   
end


function doshipkilled()
 doplaygame()
 playerlives-=1
 sfx(1)
 delaytimer=120
 gamestate= stateshipkilldelay
end

function doshiprespawn()
 resetplayership(60,60,0)
 gamestate=stateplay
end
 
function donewleveldelay()
 movenonasteroidstuff()
 delaytimer-=1
 if delaytimer<=0 then
  newlevel()
 end   
 

end

-->8
--maths

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
      if (xcrossing >= point.x) then
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
 if checkseparation(shape1.pos,shape2.pos,shape1.radius+shape2.radius) then
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

function even()
 x=flr(rnd(10))+1
 if x%2==0 then
  return true
 else
  return false
 end
end

function randomrange(a,b)
 return (a+flr(rnd(b)))
end

-->8
--initialize stuff
function newlevel()
 sfx(5)
 leveltimer=0
 cleared = false
 levelcount+=1
 newlevelspd+=.1
 numasteriods+=1
 beat_1=100
 beat_2=50
 asteroids = {}
 generateasteroids()
 if playerlives > 0 then
  gamestate=stateplay
 else
  gamestate=stateend 
 end
end

function initgame()
 endscreentimer=950
 numasteriods=1
 score=0
 newlevelspd=1
 leveltimer = 0
 levelcount=1
 asteroids = {}
 playerbullets = {}
 enemybullets = {}
 particles = {}
 shipparts = {}
 playerlives=3
 resetplayership(60,60,0)
 spawnthrust()
 generateasteroids()
 initalienship(1)
 debug = {}
 sfx(5)
end

function spawnparticles(position, velocity, maxlifetime, numparticles)
 for count= 0,3*rnd(1)+numparticles do
  local particle = {
         alive = true,
         time = maxlifetime*rnd(1),
         pos = {
          x=position.x,
          y=position.y
         },
         vel= {
          speed =velocity.speed*rnd(1)+.5,
          direction =(velocity.direction+rnd(1))*rnd(1)
         },
         col = 6,
         }
  add (particles,particle)
 end
end

function spawnshipparts(position, velocity, maxlifetime)
 for count= 0,3+flr(rnd(3)*1) do
  local invert = -1
  local partvel= {
          speed =velocity.speed*rnd(1)+.1,
          direction =velocity.direction+rnd(1)*rnd(1)
         }
  if count%2==0 then invert=invert*invert end
  
  local shippart = {
         alive = true,
         time = maxlifetime*rnd(1),
         pos = {
          x=position.x,
          y=position.y
         },
         shipvel = {ship.speed,ship.vel},
         vel =addvectors(ship.vel,partvel),
         rotspeed = (rnd(1)*.01)*invert,
         rot = 0,
         points = {{x=0,y=0},{x=1+flr(rnd(3)*1),y=1+flr(rnd(3)*1)}},
         col = 6,
         }
  add (shipparts,shippart)
 end
end

function resetplayership(xpos,ypos,rotation)
 if cleared then newlevel() end
 ship = {
  pos = {
   x=xpos,
   y=ypos
  },
  vel= {
   speed =0,
   direction = 0
  },
  acc=0.009,
  dec=0.0005,
  rotspeed = .01,
  radius = 5,
  rot = rotation,
  col = 6,
   points = {
    {x=3,y=0},
    {x=-3,y=2},
    {x=-2,y=0},
    {x=-3,y=-2},
    {x=3,y=0}
  },
 }
end

function initalienship(scale)
 alienship = {
  pos = {
   x=0,
   y=0
  },
  vel= {
   speed =0,
   direction =0
  },
  radius = 5,
  scale = 1,
  col = 6,
   points = {
    {x=0/scale,y=0/scale},
    {x=7/scale,y=0/scale},
    {x=6/scale,y=-1/scale},
    {x=5/scale,y=-1/scale},
    {x=4/scale,y=-2/scale},
    {x=3/scale,y=-2/scale},
    {x=2/scale,y=-1/scale},
    {x=1/scale,y=-1/scale},
    {x=0/scale,y=0/scale},
    {x=1/scale,y=1/scale},
    {x=6/scale,y=1/scale},
    {x=7/scale,y=0/scale}
  },
  active = true,
  spawntimer = randomrange(500,700),
  spawnbullettime = randomrange(20,70),
  directiontimer = randomrange(50,200),
  leftdir={.5,.625,.325},
  rightdir={0,.125,.825}
 }
end

function spawnthrust()
 thrustjet = {
  pos = {
   x=60,
   y=60
  },
  vel= {
   speed =0,
   direction =0
  },
  acc=0.009,
  dec=0.0005,
  rotspeed = .01,
  radius = 5,
  rot = 0,
  col = 7,
   points = {
    {x=-3,y=-1},
    {x=-5,y=0},
    {x=-3,y=1}
  },
 }
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
        col = 7,
}
return bullet
end

function spawnasteroid(scale)
 local asteroid = {
        pos = {
         x=60,
         y=20
        },
        vel= {
         speed =0,
         direction =0
        },
        acc=.05,
        dec=.001,
        rotspeed = .01,
        rot =0 ,
        col = 5,
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
   speed=  ((rnd()*(asteroidmaxvel-asteroidminvel))+asteroidminvel)*newlevelspd,
   direction = rnd()*1
  }
  asteroid.rotspeed= (rnd()*(2*asteroidmaxrot))-asteroidmaxrot
  if count <(numasteriods/2) then
   asteroid.pos.x= rnd(screen_max_x-1)
   asteroid.pos.y=0
  else
   asteroid.pos.y=rnd(screen_max_y-1)
   asteroid.pos.x=0
  end
  add(asteroids,asteroid)
 end
end

function spawnalienship(scale,bulletspeed,minrange,maxrange,value)
 alienship = {
  pos = {
   x=0,
   y=0
  },
  vel= {
   speed =0,
   direction =0
  },
  radius = 5,
  scale = scale,
  value = value,
  bulletspeed=bulletspeed,
  maxrange = maxrange,
  minrange = minrange,
  col = 6,
   points = {
    {x=0/scale,y=0/scale},
    {x=7/scale,y=0/scale},
    {x=6/scale,y=-1/scale},
    {x=5/scale,y=-1/scale},
    {x=4/scale,y=-2/scale},
    {x=3/scale,y=-2/scale},
    {x=2/scale,y=-1/scale},
    {x=1/scale,y=-1/scale},
    {x=0/scale,y=0/scale},
    {x=1/scale,y=1/scale},
    {x=6/scale,y=1/scale},
    {x=7/scale,y=0/scale}
  },
  active = true,
  spawntimer = randomrange(500,700),
  spawnbullettime = randomrange(20,70),
  directiontimer = randomrange(50,200),
  leftdir={.5,.625,.325},
  rightdir={0,.125,.825}
 }
 alienship.spawntimer=randomrange(100,400)
 alienship.vel.speed = .5
 if even() then
  xpos=0
  alienship.vel.direction =0
 else
  xpos=120
  alienship.vel.direction =.5
 end
 alienship.active=true
 alienship.pos = {x=xpos,y=rnd(128)}
end

function endgameasteroids()
 cleared = false
 numasteriods += .5
 generateasteroids()
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
c20100003a5703a5703956038550355503355032550315502e5402d53029530275302554022540215301f5201d52019520175101651014510125100f5200d5200d5100c5200a5200852006510055200451004510
2f0a00000305000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2f0a00000005000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
