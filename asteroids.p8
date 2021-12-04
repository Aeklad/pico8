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
poke(0x5f58,0x81)
--fontsnippet from zep
poke(0x5600,unpack(split"8,8,10,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,63,63,63,63,63,63,63,0,0,0,63,63,63,0,0,0,0,0,63,51,63,0,0,0,0,0,51,12,51,0,0,0,0,0,51,0,51,0,0,0,0,0,51,51,51,0,0,0,0,48,60,63,60,48,0,0,0,3,15,63,15,3,0,0,62,6,6,6,6,0,0,0,0,0,48,48,48,48,62,0,99,54,28,62,8,62,8,0,0,0,0,24,0,0,0,0,0,0,0,0,0,12,24,0,0,0,0,0,0,12,12,0,0,0,10,10,0,0,0,0,0,4,10,4,0,0,0,0,0,0,0,0,0,0,0,0,12,12,12,12,12,0,12,0,0,54,54,0,0,0,0,0,0,54,127,54,54,127,54,0,8,62,11,62,104,62,8,0,0,51,24,12,6,51,0,0,14,27,27,110,59,59,110,0,12,12,0,0,0,0,0,0,24,12,6,6,6,12,24,0,12,24,48,48,48,24,12,0,0,54,28,127,28,54,0,0,0,12,12,63,12,12,0,0,0,0,0,0,0,12,12,6,0,0,0,62,0,0,0,0,0,0,0,0,0,12,12,0,32,48,24,12,6,3,1,0,127,65,65,65,65,65,127,0,8,12,8,8,8,8,60,0,127,64,64,127,1,1,127,0,127,64,64,124,64,64,127,0,65,65,65,127,64,64,64,0,127,1,1,127,64,64,127,0,63,1,1,127,65,65,127,0,127,64,32,16,8,8,8,0,127,65,65,127,65,65,127,0,127,65,65,127,64,64,127,0,0,0,12,0,0,12,0,0,0,0,12,0,0,12,6,0,48,24,12,6,12,24,48,0,0,0,30,0,30,0,0,0,6,12,24,48,24,12,6,0,30,51,48,24,12,0,12,0,0,30,51,59,59,3,30,0,0,0,62,96,126,99,126,0,3,3,63,99,99,99,63,0,0,0,62,99,3,99,62,0,96,96,126,99,99,99,126,0,0,0,62,99,127,3,62,0,124,6,6,63,6,6,6,0,0,0,126,99,99,126,96,62,3,3,63,99,99,99,99,0,0,24,0,28,24,24,60,0,48,0,56,48,48,48,51,30,3,3,51,27,15,27,51,0,12,12,12,12,12,12,56,0,0,0,99,119,127,107,99,0,0,0,63,99,99,99,99,0,0,0,62,99,99,99,62,0,0,0,63,99,99,63,3,3,0,0,126,99,99,126,96,96,0,0,62,99,3,3,3,0,0,0,62,3,62,96,62,0,12,12,62,12,12,12,56,0,0,0,99,99,99,99,126,0,0,0,99,99,34,54,28,0,0,0,99,99,107,127,54,0,0,0,99,54,28,54,99,0,0,0,99,99,99,126,96,62,0,0,127,112,28,7,127,0,62,6,6,6,6,6,62,0,1,3,6,12,24,48,32,0,62,48,48,48,48,48,62,0,12,30,18,0,0,0,0,0,0,0,0,0,0,0,30,0,12,24,0,0,0,0,0,0,28,34,65,65,127,65,65,0,31,33,65,63,65,33,31,0,63,1,1,1,1,1,63,0,31,33,65,65,65,33,31,0,127,1,1,63,1,1,127,0,127,1,1,63,1,1,1,0,63,1,1,113,65,65,127,0,65,65,65,127,65,65,65,0,63,4,4,4,4,4,63,0,127,16,16,16,16,16,31,0,65,33,17,15,17,33,65,0,1,1,1,1,1,1,127,0,65,99,85,73,65,65,65,0,67,69,73,73,81,81,97,0,127,65,65,65,65,65,127,0,127,65,65,127,1,1,1,0,127,65,65,65,81,33,95,0,127,65,65,127,17,33,65,0,62,99,3,62,96,99,62,0,63,4,4,4,4,4,4,0,65,65,65,65,65,65,127,0,65,65,65,65,34,20,8,0,65,65,65,65,73,85,99,0,65,34,20,8,20,34,65,0,65,65,65,127,64,64,127,0,127,32,16,8,4,2,127,0,56,12,12,7,12,12,56,0,8,8,8,0,8,8,8,0,14,24,24,112,24,24,14,0,0,0,110,59,0,0,0,0,0,0,0,0,0,0,0,0,127,127,127,127,127,127,127,0,85,42,85,42,85,42,85,0,65,99,127,93,93,119,62,0,62,99,99,119,62,65,62,0,17,68,17,68,17,68,17,0,4,12,124,62,31,24,16,0,28,38,95,95,127,62,28,0,34,119,127,127,62,28,8,0,42,28,54,119,54,28,42,0,28,28,62,93,28,20,20,0,8,28,62,127,62,42,58,0,62,103,99,103,62,65,62,0,62,127,93,93,127,99,62,0,24,120,8,8,8,15,7,0,62,99,107,99,62,65,62,0,8,20,42,93,42,20,8,0,0,0,0,85,0,0,0,0,62,115,99,115,62,65,62,0,8,28,127,28,54,34,0,0,127,34,20,8,20,34,127,0,62,119,99,99,62,65,62,0,0,10,4,0,80,32,0,0,17,42,68,0,17,42,68,0,62,107,119,107,62,65,62,0,127,0,127,0,127,0,127,0,85,85,85,85,85,85,85,0"))
--states
statestart=0
stateplay=10
stateshipkilled=12
stateshipkilldelay=15
statehyperspacedelay=17
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
hitcounter=0
snipe=false
beats=0
bpm=200
--asteroids
numasteriods = 4
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
offset={}

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
 elseif gamestate == statehyperspacedelay then
  dohyperspacedelay()
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
    spawnalienship(1.5,2,50,100,100)--20,40
    offset={.03,.02,.0,0,.01,.03,.04}
    music(1)
   else
    music(0)
    spawnalienship(1,2,50,100,50)
    offset={.05,.04,.06,.03,.02,.06,.08}
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
 --bpm=bpm-4
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
  music(-1)
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
   if checkseparation(bullet.pos,alienship.pos,alienship.radius+10) then
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
 delaytimer=60
 --ship.pos.x=400
 --ship.pos.y=400
 gamestate=statehyperspacedelay
end

function fireenemybullet()
 local bullet 
 local bulletoffset = flr(rnd(7))+1
 if #enemybullets < maxenemybullets then
   bullet = spawnbullet()
   bullet.time=enemybullettime 
   bullet.pos.x=alienship.pos.x
   bullet.pos.y=alienship.pos.y
   bullet.vel.speed=alienship.bulletspeed
   bullet.vel.direction = (atan2(bullet.pos.x-ship.pos.x,bullet.pos.y-ship.pos.y)+.5)+offset[bulletoffset]
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
 if beats==0 then
  sfx(5,-1,0,1)
 elseif beats==bpm/2 then
  sfx(6,-1,0,1)
 end
 beats+=1
 if beats > bpm then
  beats=0
 end
 if bpm < 30 then bpm = 30 end
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
 if leveltimer%100==0 then
  if leveltimer<500 then
   bpm=bpm-4
  else
   bpm=bpm-8
  end
 end
 soundtrack()
 moveship()
 checkbuttons()
 movenonplayerstuff()
 checkshiphits()
 if alienship.active then
  checkalienshiphits()
 end
 debug[1]=alienship.spawntimer
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
 
function dohyperspacedelay()
 local x = randomrange(0,127)
 local y = randomrange(0,127)
 movenonplayerstuff()
 delaytimer-=1
 if delaytimer<=0 then
  resetplayership(x,y,ship.rot)
  gamestate=stateplay
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
 leveltimer=0
 cleared = false
 levelcount+=1
 newlevelspd+=.1
 numasteriods+=1
 bpm=200
 asteroids = {}
 generateasteroids()
 if playerlives > 0 then
  gamestate=stateplay
 else
  gamestate=stateend 
 end
end

function initgame()
 music(-1)
 bpm=200
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
 spawnalienship(0,0,0,0,0)
 --initalienship(1)
 debug = {}
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
  acc=0.02,
  dec=0.0005,
  rotspeed = .012,
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
   speed =.5,
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
  spawntimer = randomrange(200,300),--500,700
  spawnbullettime = randomrange(20,70),
  directiontimer = randomrange(50,200),
  leftdir={.5,.625,.325},
  rightdir={0,.125,.825}
 }
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
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
77777700000000000000000000000000000000000000000000000000000000000777770000000000770007700000000000000000000000000000000000000000
77777700000000000000000000000000000000000000000000007700770000000770000000000000077077000000000000000000000000000000000000700000
77777700777777007777770077007700770077007700770000777700777700000770000000007700007770000000000000000000000000000707000007070000
77777700777777007700770000770000000000007700770077777700777777000770000000007700077777000007700000000000000000000707000000700000
77777700777777007777770077007700770077007700770000777700777700000770000000007700000700000000000000000000000000000000000000000000
77777700000000000000000000000000000000000000000000007700770000000000000000007700077777000000000000770000007700000000000000000000
77777700000000000000000000000000000000000000000000000000000000000000000007777700000700000000000000077000007700000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000007700000000000000000000000700000000000007770000007700000007700000770000000000000000000000000000000000000000000000000700
00000000007700000770770007707700077777007700770077077000007700000077000000077000077077000077000000000000000000000000000000007700
00000000007700000770770077777770770700000007700077077000000000000770000000007700007770000077000000000000000000000000000000077000
00000000007700000000000007707700077777000077000007770770000000000770000000007700777777707777770000000000077777000000000000770000
00000000007700000000000007707700000707700770000077077700000000000770000000007700007770000077000000000000000000000000000007700000
00000000000000000000000077777770077777007700770077077700000000000077000000077000077077000077000000770000000000000077000077000000
00000000007700000000000007707700000700000000000007770770000000000007700000770000000000000000000000770000000000000077000070000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007700000000000000000000000000000
77777770000700007777777077777770700000707777777077777700777777707777777077777770000000000000000000007700000000000770000007777000
70000070007700000000007000000070700000707000000070000000000000707000007070000070000000000000000000077000000000000077000077007700
70000070000700000000007000000070700000707000000070000000000007007000007070000070007700000077000000770000077770000007700000007700
70000070000700007777777000777770777777707777777077777770000070007777777077777770000000000000000007700000000000000000770000077000
70000070000700007000000000000070000000700000007070000070000700007000007000000070000000000000000000770000077770000007700000770000
70000070000700007000000000000070000000700000007070000070000700007000007000000070007700000077000000077000000000000077000000000000
77777770007777007777777077777770000000707777777077777770000700007777777077777770000000000770000000007700000000000770000000770000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000007700000000000000000007700000000000777770000000007700000000000000000077007700000000770000000000000000000000000000
07777000000000007700000000000000000007700000000007700000000000007700000000077000000000007700000000770000000000000000000000000000
77007700077777007777770007777700077777700777770007700000077777707777770000000000000777007700770000770000770007707777770007777700
77077700000007707700077077000770770007707700077077777700770007707700077000777000000077007707700000770000777077707700077077000770
77077700077777707700077077000000770007707777777007700000770007707700077000077000000077007777000000770000777777707700077077000770
77000000770007707700077077000770770007707700000007700000077777707700077000077000000077007707700000770000770707707700077077000770
07777000077777707777770007777700077777700777770007700000000007707700077000777700770077007700770000077700770007707700077007777700
00000000000000000000000000000000000000000000000000000000077777000000000000000000077770000000000000000000000000000000000000000000
00000000000000000000000000000000007700000000000000000000000000000000000000000000000000000777770070000000077777000077000000000000
00000000000000000000000000000000007700000000000000000000000000000000000000000000000000000770000077000000000077000777700000000000
77777700077777700777770007777700077777007700077077000770770007707700077077000770777777700770000007700000000077000700700000000000
77000770770007707700077077000000007700007700077077000770770007700770770077000770000077700770000000770000000077000000000000000000
77000770770007707700000007777700007700007700077007000700770707700077700077000770007770000770000000077000000077000000000000000000
77777700077777707700000000000770007700007700077007707700777777700770770007777770777000000770000000007700000077000000000000000000
77000000000007707700000007777700000777000777777000777000077077007700077000000770777777700777770000000700077777000000000007777000
77000000000007700000000000000000000000000000000000000000000000000000000007777700000000000000000000000000000000000000000000000000
00770000007770007777700077777700777770007777777077777770777777007000007077777700777777707000007070000000700000707700007077777770
00077000070007007000070070000000700007007000000070000000700000007000007000700000000070007000070070000000770007707070007070000070
00000000700000707000007070000000700000707000000070000000700000007000007000700000000070007000700070000000707070707007007070000070
00000000700000707777770070000000700000707777770077777700700077707777777000700000000070007777000070000000700700707007007070000070
00000000777777707000007070000000700000707000000070000000700000707000007000700000000070007000700070000000700000707000707070000070
00000000700000707000070070000000700007007000000070000000700000707000007000700000000070007000070070000000700000707000707070000070
00000000700000707777700077777700777770007777777070000000777777707000007077777700777770007000007077777770700000707000077077777770
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
77777770777777707777777007777700777777007000007070000070700000707000007070000070777777700007770000070000077700000000000000000000
70000070700000707000007077000770007000007000007070000070700000700700070070000070000007000077000000070000000770000000000000000000
70000070700000707000007077000000007000007000007070000070700000700070700070000070000070000077000000070000000770000777077000000000
77777770700000707777777007777700007000007000007070000070700000700007000077777770000700007770000000000000000077707707770000000000
70000000700070707000700000000770007000007000007007000700700700700070700000000070007000000077000000070000000770000000000000000000
70000000700007007000070077000770007000007000007000707000707070700700070000000070070000000077000000070000000770000000000000000000
70000000777770707000007007777700007000007777777000070000770007707000007077777770777777700007770000070000077700000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
77777770707070707000007007777700700070000070000000777000070007000707070000777000000700000777770007777700000770000777770000070000
77777770070707007700077077000770007000700077000007700700777077700077700000777000007770007770077077777770000777707700077000707000
77777770707070707777777077000770700070000077777077777070777777700770770007777700077777007700077070777070000700007707077007070700
77777770070707007077707077707770007000700777770077777070777777707770777070777070777777707770077070777070000700007700077070777070
77777770707070707077707007777700700070007777700077777770077777000770770000777000077777000777770077777770000700000777770007070700
77777770070707007770777070000070007000700007700007777700007770000077700000707000070707007000007077000770777700007000007000707000
77777770707070700777770007777700700070000000700000777000000700000707070000707000070777000777770007777700777000000777770000070000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000077777000007000077777770077777000000000070007000077777007777777070707070000000000000000000000000000000000000000000000000
00000000770077700077700007000700777077700707000007070700770707700000000070707070000000000000000000000000000000000000000000000000
00000000770007707777777000707000770007700070000000700070777077707777777070707070000000000000000000000000000000000000000000000000
70707070770077700077700000070000770007700000000000000000770707700000000070707070000000000000000000000000000000000000000000000000
00000000077777000770770000707000077777000000707070007000077777007777777070707070000000000000000000000000000000000000000000000000
00000000700000700700070007000700700000700000070007070700700000700000000070707070000000000000000000000000000000000000000000000000
00000000077777000000000077777770077777000000000000700070077777007777777070707070000000000000000000000000000000000000000000000000
__sfx__
580100002d5702b5702a57029560285602755026540245402254021540205401e5301c5301b520195201752015510155001450011500105000e5000d5000b5000a50005500005000250001500005000050002500
9e040000136701b6701b6701a6701b6701b6701a660176601566013650126400b6401263011630116200a6100a650016000060000600006000060000600006000060000600006000060000600006000060000600
a60300000065000650006500065000650006400064000630006300062000620006100061000610006100060000600006000160001600016000060000600006000060000600006000060000600006000060000600
960300000072000720007200072000720007200071000710007100071000710007100070000700007000070001700017000170000700007000070000700007000070000700007000070000700007000000000000
c20100003a5703a5703956038550355503355032550315502e5402d53029530275302554022540215301f5201d52019520175101651014510125100f5200d5200d5100c5200a5200852006510055200451004510
2f0a00000305000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2e0a00000005000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
90011f001151012520145301553017520195201b5201c5201e5201f5202052021510235102351024510245102451024510235102251021510205101f5201e5201c5201b5201a5201952018520165201552014530
90011600285102a5102c5202e52030520335203352033520335203252032520305202e5202c5202a5202952027520245101f5101a510155000d50000500005000000000000000000000000000000000000000000
__music__
03 07424344
03 08424344

