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

--states
statestart=0
stateplay=10
stateshipkilled=12
stateshipkilldelay=15
statewaitforrespawn=16
statehyperspacedelay=17
stateleveldelay=18
stateend=20
stateentername=25
gamestate=state_init
--game stuff
cartdata("aeklad_asteroids_1")
screen_max_x=128
screen_max_y=128
credits=0
cleared=false
levelcount =1
alienspawninterval = 4000
newlevelspd=1
leveltimer = 0
score = 0
score2 = 0
names={}
scores={}
--hiscore_list={names,scores}
hiscore=dget(0)
hiscore_list={}
name_list={}
score_list={}
endscreentimer=0
hitcounter=0
snipe=false
beats=0
bpm=200
gamestarted=false
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
  --movenonplayerstuff()
  dostartscreen()
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
  doendscreen()
  if cleared and gamestarted then
   delaytimer-=1
   if delaytimer <=0 then
    endgameasteroids()
   end
  end
 end
end
 
function _draw()
 spr(1,40,120,6,1)
 drawparticles()
 drawshipparts()
 drawtheship()
 drawalienship()
 drawbullets(playerbullets)
 drawbullets(enemybullets)
 drawasteroids()
 drawgameinfo()
 for txt in all(debug) do
  print(txt,0,50,8)
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
   if gamestate !=statestart then
    endlevel()
   else
    newlevel()
   end
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
 if score > hiscore then
  hiscore=score
 end
 dset(0,hiscore)
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
function hcenter(s,y)
 --screen center minus the string length
 --times half a characters width in pixels
 print(s,64-#s*4,y)
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
 if gamestate!=statestart then
  drawlives(-5,10,1,3)
 end
 --spr(48,64,0)
 --spr(48,60,0)
 print(hiscore,54,0)
 if score <=0 then 
  print(score..0,8,0)
 else
  print(score,8,0)
 end
 if score2 <=0 then 
  print(score2..0,104,0)
 else
  print(score2,104,0)
 end
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
 leveltimer+=1
 playerlives=0
 movenonplayerstuff()
 if alienship.active then
  checkalienshiphits()
 end
 --alienship.active=false
 if gamestate==statestart then
  if btnp(5) then credits +=1 end
 end
 if credits <=0 then
  hcenter("1 coin 1 play",100)
 else
 --print("asteroids", hcenter("asteroids"),60)
  if sin(time()*.5)>0 then hcenter("push start",20) end
  if btnp(4) then
   credits -=1
   initgame()
   alienship.active=false
   gamestarted=true
   gamestate=stateplay
  end
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
end

function doendscreen()
 movenonplayerstuff()
 if alienship.active then
  checkalienshiphits()
 end
 --hcenter("game over",40)
 --endscreentimer -= 1
 if endscreentimer < 0 then
  initgame()
  gamestate=statestart 
 end
 if btnp(5) then 
  place+=1
 end
 if place>3 then 
  place=4
  if not toggle then
   toggle=true
   fill_hi_score()
  end
  print_hi_score()
  if btnp(4) then
   initgame()
   gamestate=statestart 
  end
 end
 entername(place)
 drawname()
end

function fill_hi_score()
  newname= chr(initial[1])..chr(initial[2])..chr(initial[3])
  add(hiscore_list,newname)
  add(hiscore_list,score)
  --hiscore_list=sort(hiscore_list)
  --add(names,newname)
  --add(scores,score)
  --scores=sort(scores)
  --hiscore_list={names,scores}
end

function print_hi_score()
 --for i=1,n do
  hcenter(hiscore_list[1].." "..hiscore_list[2],30+1*10)
 --end
end

function drawname()
 hcenter(chr(initial[1])..chr(initial[2])..chr(initial[3]),20)
end

function build_list(i)
 hiscore_list = {name_list,score_list}
end

function storename()
 return {initial[1],initial[2],initial[3]}
end

function entername(i)
 if btn(1) then initial[i]+=.1 end
 if btn(0) then initial[i]-=.1 end
 if initial[i] <=97 then 
  initial[i]=97
 end
 if initial[i] >=122 then
  initial[i] = 122
 end
end

function endlevel()
  cleared=true delaytimer=120 gamestate=stateleveldelay end

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
 local dice = randomrange(0,3)
 local x = randomrange(0,127)
 local y = randomrange(0,127)
 movenonplayerstuff()
 delaytimer-=1
 if delaytimer<=0 then
  resetplayership(x,y,ship.rot)
  if dice==2 then
   spawnshipparts(ship.pos,ship.vel,120)
   gamestate=stateshipkilled 
  else
   gamestate=stateplay
  end
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

function sort(s)
 local na={}
 while #s>0 do
  for i=2,#s,2 do
   local b = true
   for j=2,#s,2 do
    b=b and s[i]>=s[j]
   end
   if b then
    add(na,s[i-1])
    add(na,s[i])
    del(s,s[i])
    del(s,s[i-1])
    break
   end
  end
 end
 return(na)
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
 if gamestate != statestart then
  if playerlives > 0 then
   gamestate=stateplay
  else
   gamestate=stateend 
  end
 end
end

function initgame()
 ta={3,-1,100,2,4,7,99,4,-10}
 music(-1)
 bpm=200
 endscreentimer=950
 numasteriods=1
 score=0
 toggle=false
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
 alienship.active=false
 initial={97,97,97,0}
 place=1
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
  active = false,
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

-->8
--zeps font snippet
poke(0x5600,unpack(split"8,8,10,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,63,63,63,63,63,63,63,0,0,0,63,63,63,0,0,0,0,0,63,51,63,0,0,0,0,0,51,12,51,0,0,0,0,0,51,0,51,0,0,0,0,0,51,51,51,0,0,0,0,48,60,63,60,48,0,0,0,3,15,63,15,3,0,0,62,6,6,6,6,0,0,0,0,0,48,48,48,48,62,0,99,54,28,62,8,62,8,0,0,0,0,24,0,0,0,0,0,0,0,0,0,12,24,0,0,0,0,0,0,12,12,0,0,0,10,10,0,0,0,0,0,4,10,4,0,0,0,0,0,0,0,0,0,0,0,0,12,12,12,12,12,0,12,0,0,54,54,0,0,0,0,0,0,54,127,54,54,127,54,0,8,62,11,62,104,62,8,0,0,51,24,12,6,51,0,0,14,27,27,110,59,59,110,0,12,12,0,0,0,0,0,0,24,12,6,6,6,12,24,0,12,24,48,48,48,24,12,0,0,54,28,127,28,54,0,0,0,12,12,63,12,12,0,0,0,0,0,0,0,12,12,6,0,0,0,62,0,0,0,0,0,0,0,0,0,12,12,0,32,48,24,12,6,3,1,0,127,65,65,65,65,65,127,0,8,12,8,8,8,8,60,0,127,64,64,127,1,1,127,0,127,64,64,124,64,64,127,0,65,65,65,127,64,64,64,0,127,1,1,127,64,64,127,0,63,1,1,127,65,65,127,0,127,64,32,16,8,8,8,0,127,65,65,127,65,65,127,0,127,65,65,127,64,64,127,0,0,0,12,0,0,12,0,0,0,0,12,0,0,12,6,0,48,24,12,6,12,24,48,0,0,0,30,0,30,0,0,0,6,12,24,48,24,12,6,0,30,51,48,24,12,0,12,0,0,30,51,59,59,3,30,0,0,0,62,96,126,99,126,0,3,3,63,99,99,99,63,0,0,0,62,99,3,99,62,0,96,96,126,99,99,99,126,0,0,0,62,99,127,3,62,0,124,6,6,63,6,6,6,0,0,0,126,99,99,126,96,62,3,3,63,99,99,99,99,0,0,24,0,28,24,24,60,0,48,0,56,48,48,48,51,30,3,3,51,27,15,27,51,0,12,12,12,12,12,12,56,0,0,0,99,119,127,107,99,0,0,0,63,99,99,99,99,0,0,0,62,99,99,99,62,0,0,0,63,99,99,63,3,3,0,0,126,99,99,126,96,96,0,0,62,99,3,3,3,0,0,0,62,3,62,96,62,0,12,12,62,12,12,12,56,0,0,0,99,99,99,99,126,0,0,0,99,99,34,54,28,0,0,0,99,99,107,127,54,0,0,0,99,54,28,54,99,0,0,0,99,99,99,126,96,62,0,0,127,112,28,7,127,0,62,6,6,6,6,6,62,0,1,3,6,12,24,48,32,0,62,48,48,48,48,48,62,0,12,30,18,0,0,0,0,0,0,0,0,0,0,0,30,0,12,24,0,0,0,0,0,0,28,34,65,65,127,65,65,0,31,33,65,63,65,33,31,0,63,1,1,1,1,1,63,0,31,33,65,65,65,33,31,0,127,1,1,63,1,1,127,0,127,1,1,63,1,1,1,0,63,1,1,113,65,65,127,0,65,65,65,127,65,65,65,0,63,4,4,4,4,4,63,0,127,16,16,16,16,16,31,0,65,33,17,15,17,33,65,0,1,1,1,1,1,1,127,0,65,99,85,73,65,65,65,0,67,69,73,73,81,81,97,0,127,65,65,65,65,65,127,0,127,65,65,127,1,1,1,0,127,65,65,65,81,33,95,0,127,65,65,127,17,33,65,0,127,1,1,127,64,64,127,0,63,4,4,4,4,4,4,0,65,65,65,65,65,65,127,0,65,65,65,65,34,20,8,0,65,65,65,65,73,85,99,0,65,34,20,8,20,34,65,0,65,65,65,127,64,64,127,0,127,32,16,8,4,2,127,0,56,12,12,7,12,12,56,0,8,8,8,0,8,8,8,0,14,24,24,112,24,24,14,0,0,0,110,59,0,0,0,0,0,0,0,0,0,0,0,0,127,127,127,127,127,127,127,0,85,42,85,42,85,42,85,0,65,99,127,93,93,119,62,0,62,99,99,119,62,65,62,0,17,68,17,68,17,68,17,0,4,12,124,62,31,24,16,0,28,38,95,95,127,62,28,0,34,119,127,127,62,28,8,0,42,28,54,119,54,28,42,0,28,28,62,93,28,20,20,0,8,28,62,127,62,42,58,0,62,103,99,103,62,65,62,0,62,127,93,93,127,99,62,0,24,120,8,8,8,15,7,0,62,99,107,99,62,65,62,0,8,20,42,93,42,20,8,0,0,0,0,85,0,0,0,0,62,115,99,115,62,65,62,0,8,28,127,28,54,34,0,0,127,34,20,8,20,34,127,0,62,119,99,99,62,65,62,0,0,10,4,0,80,32,0,0,17,42,68,0,17,42,68,0,62,107,119,107,62,65,62,0,127,0,127,0,127,0,127,0,85,85,85,85,85,85,85,0"))
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000055550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000500005005550555055505005550505550555000055500000000000000000000000000000000000000000000000000000000000000000000000000000
00000000505505000050505000505005050505000505000050500000000000000000000000000000000000000000000000000000000000000000000000000000
00000000505005005550505055505005550505000505055055500000000000000000000000000000000000000000000000000000000000000000000000000000
00000000505505005000505050005005000505000505000050500000000000000000000000000000000000000000000000000000000000000000000000000000
00000000500005005550555055505005000505550555000055500000000000000000000000000000000000000000000000000000000000000000000000000000
00000000055550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
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
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007700000000000770000007777000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000077000000000000077000077007700
00000000000000000000000000000000000000000000000000000000000000000000000000000000007700000077000000770000077770000007700000007700
55500000050000005550000055500000505000005550000055500000555500005550000055500000000000000000000007700000000000000000770000077000
50500000550000000050000000500000505000005000000050000000000500005050000050500000000000000000000000770000077770000007700000770000
50500000050000005550000055500000555000005550000055500000005000005550000055500000007700000077000000077000000000000077000000000000
50500000050000005000000000500000005000000050000050500000050000005050000000500000000000000770000000007700000000000770000000770000
55500000555000005550000055500000005000005550000055500000050000005550000000500000000000000000000000000000000000000000000000000000
07000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
07777000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
77007700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
77077700000070000007700000077700000770000007770000077700000777000007070000077700000777000007070000070000000707000007070000077700
77077700000707000007070000070000000707000007000000070000000700000007070000007000000007000007070000070000000777000007770000070700
77000000000777000007770000070000000707000007770000077700000700000007770000007000000007000007700000070000000707000007770000070700
07777000000707000007070000070000000707000007000000070000000707000007070000007000000707000007070000070000000707000007770000070700
00000000000707000007700000077700000770000007770000070000000777000007070000077700000777000007070000077700000707000007070000077700
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000777770070000000077777000777000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000770000077000000000077000777700000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000770000007700000000077000700700000000000
00077700000777000007770000077700000777000007070000070700000707000007070000070700000777000770000000770000000077000000000000000000
00070700000707000007070000070000000070000007070000070700000707000000700000070700000007000770000000077000000077000000000000000000
00077700000707000007070000077700000070000007070000070700000707000000700000077700000070000770000000007700000077000000000000000000
00070000000777000007700000000700000070000007070000070700000777000000700000007000000700000777770000000700077777000000000007777000
00070000000007000007070000077700000070000007770000007000000707000007070000007000000777000000000000000000000000000000000000000000
00770000007770007777700077777700777770007777777077777770777777007000007077777700777777707000007070000000700000707700007077777770
00077000070007007000070070000000700007007000000070000000700000007000007000700000000070007000070070000000770007707070007070000070
00000000700000707000007070000000700000707000000070000000700000007000007000700000000070007000700070000000707070707007007070000070
00000000700000707777770070000000700000707777770077777700700077707777777000700000000070007777000070000000700700707007007070000070
00000000777777707000007070000000700000707000000070000000700000707000007000700000000070007000700070000000700000707000707070000070
00000000700000707000070070000000700007007000000070000000700000707000007000700000000070007000070070000000700000707000707070000070
00000000700000707777700077777700777770007777777070000000777777707000007077777700777770007000007077777770700000707000077077777770
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
77777770777777707777777077777770777777707000007070000070700000707000007070000070777777700007770000070000077700000000000000000000
70000070700000707000007070000000000700007000007070000070700000700700070070000070000007000077000000070000000770000000000000000000
70000070700000707000007070000000000700007000007070000070700000700070700070000070000070000077000000070000000770000777077000000000
77777770700000707777777077777770000700007000007070000070700000700007000077777770000700007770000000000000000077707707770000000000
70000000700070707000700000000070000700007000007007000700700700700070700000000070007000000077000000070000000770000000000000000000
70000000700007007000070000000070000700007000007000707000707070700700070000000070070000000077000000070000000770000000000000000000
70000000777770707000007077777770000700007777777000070000770007707000007077777770777777700007770000070000077700000000000000000000
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
__label__
0000000000000000000000000000010a577777d6777777000000000000d5677070000d17500188aaaaaa11800000050000000000000000010000000000000000
0000000000000000d7dd0000000000a0677777d777777000000000000d177d0d0001d51011888aaaaaa001800000000000000000000000000000000000000000
000000000060000777dcd15051700a177777717777770000000000005d775550000000018888aaaaaa0001a00000000000000000000000000000000000000000
00000000000000777d5dc0577751a067777756777710000000000016570660000000011888aaaaaa00000da00000000000000000000000000000000000000000
00000000000010778881c777710a177777761777750000000000056d7dd700000001c5888aaaaaa0000006500000000000000000000000000000000000000000
000000000000007785ccc76000a0777777575777000000000000dd7761d0000011c58888aaaaa10000001a100000000000000000000000000000000000000000
000000000000d156dccc00000aa7777775776771000000000006d67511000001cc58885aaaaa000000001a000001000000000000000000000000000000000000
0000000000007777cc1100000a0777775770770000000000005d67150000001cc8888aaaaa60000101001a088888888000000000000000010000000000000000
000000000d777767100000000a67777d777d6000000000001d177d7000000ccc8888aaaaa0000000000061880000008800000001000000000000000001011110
0000000d7675607000000000a177771777170000000000016577d7000001ccc8888aaaaa1000000000071880aaaaaa0800000110100000000000010111100100
00005756716d711000000000a5777777770000000000006577d05000011cc8888aaaaaa0000000000076880aaaaaaa0880000010100000000100111010011100
00675dd70756500000000005a777d77771000000000006d77d1500000cc18888aaaaa10000000000108880aaaaaaaa0881000000011101010101111001101110
77d07070650700000000000a577d7777100000000000517750000001ccc8888aaaaa000000000088888800aaa000000888010011101100011111110101011111
50716d01607000000000000a17677770000000000015d77d6000001cc5888aaaaaa00100000d788888880aaa0888888888811001100111010111101101001111
170d5007007000000000000a777777100000000000dd77d6000001cc1888aaaaa10000000078888800880aaa0000000088811101101001011011001001010011
605600d600710570000000a057777000000000001d177d700010ccc5888aaaaa1000000018888000aa000aaaaaaaaaa088811111111000011000111101110001
0060007100700170000000ad770600000000000d567d0100001cc58885aaaaa00000001788880aaaaaaa0aaaaaaaaaaa08811100110000111010010001011101
160000700057000000000aa7756000000000006d6650000011cc5888aaaaa100000007888800aaaaaaaaa0aaaaaaaaaa08811111111111110101000001101101
650001700007710000001a06770000000000056776d100001cc5888aaaaa00000007788800aaaaaaaaaaaa00000000aa088011111111106ddd11101101011111
700001600000671000000a5770000000000056776d000001cc5888aaaaa00000017888880aaaaaa00aaaaa08888880aa0880111111111daadd51111100010011
60060070000005771001a0770000000000056676600000ccc5888aaaa5000000088880000aaaaa0880aaaa00000000aa08811101111115a1ccd1111100100101
0010007000000001771a1170000000000065760500001cc18885aaaa00000d7788880aaaa0aaaa0880aaaa0aaaaaaaaa081111111111ccccc161111111111111
000000770000000011a57600000000001707d0100001cc5888aaaaa10001768888880aaaa0aaaa08880aaa0aaaaaaaa088111c111111c11cc11c111111111111
00500017000000000aa77d000000000511715000001cc5888aaaa500006d888800080aaaa0aaaa08880aaa00aaaaa0088111116661cc1111011ccc1c11111111
00000007700000000a76000000000011d7d1000001cc5888aaaa100007788000aaa00aaaaa0aaa00880aaa080000088817111aaa811c1cccccc11cccc1111111
0100000077000000a616500000000d5575d000001cc5888aaaa10000168800aaaaaaa0aaaa0aaaa080aaaa08888888166c166aaaa511ccccccc1cccc11111111
500000000771100add61000000006d665601000cc1888aaaaa10007678800aaaaaaaa0aaaa0aaaa00aaaaa08888017711c05aaa885cdcc1cccccc1cc11111111
70000000006770ad56650000000d567dd00000cc1888aaaad0000767880aaaaaaaaaaa0aaa0aaaaaaaaaa088877711111156aa8881c7111c1cc1111111111111
7100000000050a1516610000006dd77600601cc1888aaaad00088888880aaaa00aaaaa0aaaa0aaaaaaaa08817d77777777dd58888ccd77667777777777777767
770100d0000051dd677d0000016760501700cc5888aaaa000088888880aaaa0880aaaaa0aaa0aaaaaaa088877777777777157cc51c6655775777dd7777777777
d771000000001d1d777d0000567d1000760cc5888aaaa0000888000000aaaa08880aaaa0aaa0aaaaa0088871d777777777d756ccc6d1ad177777777767777777
077700000000dd677775001dd71d0007701c8888aaaa00088800aaaaa0aaaa08880aaaa0aaaa0aa00888ccccc11c11ccccc17077757aacc67cccccddcd66dcdc
0077000000a61677776000557550007710c888aaaaa0018880aaaaaaa0aaaa08880aaaa0aaaa0008881cc1111c1ccccccccc177775aad1cd71cccccc11cccccc
007777050a755776771001571d000577018885aaaa0018800aaaaaaaa0aaaa08880aaaa00aaa08888ccc1c111cccccccc1c1c111d5a51cc77ccccccccc1ccccc
00077770a616770677d1d5767000077d1888aaaaaa88880aaaaaaaaaa0aaaa00880aaaa00a00888cc6c1cccccccccccccccccccc17155c176ccccccccccc1ccc
0000771165077d17766d17d600005770888aaaaaa880000aaaa000aaa00aaaa000aaaaa0808888cc6d11c1ccccccccccc1ccc1cc177115771ccccccccccccccc
0000d15dd0777777661775d00000d77888aaaaa8880aaa0aaa0880aaaa0aaaaaaaaaaa088888cc1161ccc1ccccccccccccccccccc117776cccccccccc1cccccc
000000561777777d755761000000d7188aaaa88800aaaa0aaa0880aaaa0aaaaaaaaaaa0888cc1111ac1c1ccccccc1ccccccccccccccc1ccccccccccccccccccc
000001d6d77777777075d00000007718aaaa8880aaaaaa0aaaa000aaaa00aaaaaaaa00888cc11cc16c1cccccccc1cccccccccccccccccc1ccccccccccccccccc
0000155d77777577750000000070768aaa88800aaaaa000aaaaaaaaaaaa000aaaa00888ccc1ccccc6ccccccccccccccccccccccccccccc1ccccccccccccccccc
000d16d7777767777100000dd6d170aa88880aaaaaa00800aaaaaaaaaaaa0800008888ccccccccc16c1cccccccccccccccccccccccccccccccccc1c6cccccccc
005d60677776777650000d7675dd778888000aaaa00880a0aaaaa000aaaa08888888ccccccc1cccd1c1d1ccccccccccccccccccccccccccccccccccccccccccc
0015577777d77761000d6765dd17888800aa0aaa08800aa0aaaa00880aaaa08888ccccccccccccc6cc6cdccccdcccccccccccccccccccccccccdccdccccccccc
0d50777776777600001757777d788800aaaa0aaa080aaaa0aaaaa0880aaa0081d711ccccccccccc7cccccccccccccccccccccccccccccccccccccccccccccccc
d5177777d7775d00015d777d788880aaaaaa0aaa00aaa0000aaaa088000008d7677d1cccccccccc7ccccccccccccccccc1ccccccccccccc1c1c1c1cccccccccc
5077777777711100d577077788800aaaaaaa0aaaaaaa08880aaaa0888888877767777776dcccccc7cccccccccccccdcccccccccccccccccccc16cdcccccccccc
0777777677d5000656707788800aaaaaa0000aaaaa0088800aaaaa08888c7677677777777677dd66ccccccccccccccccccccccccccccccccccccd1cccccccccc
7777777771d000d6500088880aaaaaaaa08880aaaa08880aa0aa00888ccc1cc67cc77777771007777777dd1cccccccccccccccccccccccc6cccccccccccccccc
777776771d0005000088800000aaaaaaaa0880aaaa000aaaa0008888ccc1cccc7cccc7777777d77077777777d7d111d11ccccccccccccccdcccccccccccccccc
777757760000000008800aaaaa0aa00aaa0880aaaa0aaaaaa08888ccccc1cccc61ccccccccc77770d77777770670707777661ccccccccccccccccccccccccccc
7776770100000000880aaaaaaaa0080aaa08880aaaaaaaa008888cccccccccccccccccccccc11c77777777777775067777777767771ccccccc771ccccccccccc
776d7d5000000088880aaaaaaaa0880aaaa0880aaaaaaa08888cccc1cccccccccccccccccccccc7ccc10667777777777777777777777777d77777711cccccccc
76710d000000888880aaaa000000880aaaa0880aaaaa008888cccccccccccccccccccccccccccc7cc11711ccccc6777777777777776d7777777777076777776c
677dd000008888880aaaa08888888800aaaa080aaaa08888ccccccccccccccccccccccccccccccdcc101d1cccccccd67777777777707077777777775d7777767
77510000008088880aaaa00000000880aaaa0880a00888cccccccccccccccccccccccccccccccd1ccc0001ccccccccccccd67777770016765776777777777777
75600000880a08880aaaaaaaaaaaa080aaaa0880088877cccccccccccccccc1cccccccccccccc6cccc11cdc6ccccccccccccccc177677d777777777777777777
1100007800aaa08880aaaaaaaaaaa080aaaa08888887711cccccccccccccccccccccccccccccc7ccccccccccccccccccccccccccc1c110007777777777777767
606511780aaaaa0880aaaaaaaaaaaa080aa0088877777777dcccccccccccccccccccccccccccc6cccccccccccccccccccccccccccccc1771c1dddd6777777767
077700780aaaaaa08800000000aaaa080a08888777777777776ccccccccccccccccccccccccccdccccccccccccccccccdcccccccccccc601ccccc6c1c1d77767
7777d0680aaaaaaa0888888880aaaa0800888877777777777777cccccccccccccccccccccccc1cccccccccccccccccccdccccccc1cccccccdccccccccc115167
167771780aaaaaaaa08000000aaaa008888cc66777777777777776cc1cccccccccccccccccccdccccdccccccccccccccccccccccccccccccccccdcccccc17757
167777680aaa0aaaaa0aaaaaaaaaa08888ccc1d67777777777777777d6dccccccccccccccccc6cccccccccccccccccccccccccccccccccc7ccccccdc61ccc517
cd7777780aaa00aaaaa0aaaaaaaa0088ccccccccc1777777715177777776cccccccccccccccc7ccccccccccccccccccccccccccccccccccccccccccccccccccc
c17777680aaa080aaaaa0aaaaaa088ccccccccccccc777770d770077777771cccccccccccccc6ccccccccccccccccccccccccccccccccccccccccccccccccccc
c1d777780aaa080aaaaaa0aaa0088ccccccccccccccd777770560077777776c1ccccccccccccdccccccccccccccccccccccccccccccccccccccccccccccccccc
cc0777780aaa00aaaaaaa0000888ccccccccccccccccccd77700d7077777776776cccccccccccccccccccccccccccccccccccccccccccccdaaaaaa61cccccccc
cc1d77680aaaaaaaaaaaa088888ccccccccccccccccccc1777d6775777777777777cccccccccccccccccccccccccccccccccccccccccc6aaaaaaaaaaadcccccc
cc1077780aaaaaa00aa00887777cccccccccccccccccccc1677777707777777777777dcccccccccccccccccccccccccccccccccccccdaaaaaaaaaaaaaa6ccccc
cc1177680aaaa008800888775771ccccccccccccccccccccc6777776777777777777d776dcc6ccccccccccccccccccccccccccccc1aaaaaaaaaaaaaaaa885ccc
cc1cd6780aaaa088888887a71771cccccccccccccccccccccccc7770777777777775d7777dc7cccccccccccccccccccccccccccccaaaaaaaaaaaaaaaaaaa85cc
cc1116680aaaa08888877aa7677ccccccccccccccccccccccccc177777777777777571011777dcccccccccccccccccccccccccccaaaaaaaaaaaaaaaaaaaa8810
ccc1c1780aaa0888887aaa1767dccccccccccccccccccccccccccd777707d7777777707717777dccccccccccccccccccccc6dccdaaaaaaaaaaaaaa8aaa888888
ccccc1780a0088887daaa187771ccccccccccccccccccccccccccc1d77677777777775dd0777777761cccccccccccccccccccccaaaaaaaaaa885aa88aa888888
cccccc78008888778888816771cccccccccccccccccccccccccccccccc1777777777771057777777771ccccc1cccccccccccccaaaaaaaaaaa888aa888a888888
ccccc17888887767610d7777d1cccccccccccccccccccccccccccccccccc677777777517777777777777ccccccccccccccccc1aaaaaaaaaa8888a88888888888
cccccc688877677777777776cccccccccccccccccccccccccccccccccccccdd77777700777777777777771d7ccccccccccccc5aaaaaaaaaa8888888888888888
cccccc67777777dd77776161ccccccccccccccccccccccccccccccccccccccc77777777777777777777777777ccccccccccccaaaaaaaaa888888888888888888
cccccc66777777177771cc6ccccccccccccccccccccccccccccccccccccccccd677770777777777777777777776dccccc16ccaaaaaaaaaa88888888888888888
ccccccccc67777707777cc6cccccccccccccccccccccccccccccccccccccccccc777777777777777777777777777d111cccc1aaaaaaaaa888888888888888858
ccccccccc77777777777dc6ccccccccccccccccccccccccccccccccccccccccccc11770007777777777777777777777ccdcccaaaaaaaa8888888888888888888
ccccccccc777776177777c7cccccccccccccccccccccccccccccccccccccccccccccc7010777777777777777777777177711caaaaaaaa8aa8888888888888858
cccccccccc177677777107751cccccccccccccccccccccccccccccccccccccccccccc1dd67777777777777777777777556166aaaaaaa88888888888888888888
ccccccccccc77d77777717700ccccccccccccccccccccccccccccccccccccccccccccccd777777777777777777757770777d776a7aaad8888888888888888888
ccccccccccc667777777777dccccccccccccccccccccccccccccccccccccccccccccc07ccdd7777777776177777777500770d77776d888888888888888888888
cccccccccccc1777777777771cccccccccccccccccccccccccccccccccccccccccccc00cccd7c6777777707077777776005077777776d8888888888888888888
ccccccccccccc7777777777701ccccccccccccccccccccccccccccccccccccccccccc11ccccccc77777777766777777770577777777777688888888888888888
ccccccccccccc7777777777606ccccccccccccccccccccccccccccccccccccccccccccccc1cccc1777777d77775777777777d77777777776d786888888888888
ccccccccccccc6777777777776cccccccccccccccccccccccccccccccccccccccccccc1cdcc1cccc77777d1670077777777167777777777777778d8888888888
cccccccccccccc677777777777dccccccccccccccccccccccccccccccccccccccccccccc6cccccccccd677100057777777777777777777777777766686888888
cccccccccccccc17777777777761dccccc1cccccccccccccccccccccccccccccccccccccdccccccccccc7777777777777775777777777777777777677d778588
ccccccccccccccc77777777777771ccc1151ccccccccccccccccccccccccccccccccccccccccccccccccccd77057777777777777777777777777777777777756
ccccccccccccccc77777777777077cdc01761ccccccccccccccccccccccccccccccccccccccccccccccc6ccc77d7777777777777777777777777777777777786
cccccccccccccccd7777777777777ccc00110cccccccccccccccccccccccccccccccccccccccccccccccccc6d777777777777777777777777777777777777776
cccccccccccccccc677777777777777c61001cccccccccccccccccccccccccccdcccccccccccccccccccccccc177777777777777777777770717777777777777
cccccccccccccccccd77777777777776ccc1ccccccccccccccccccccccccccccccccccccccccccccccccccccccc66d77777777777777777d0767777777777777
ccccccccccccccccc6777777777777776cccccccccccccccccccccccccccccccccccccccccccccc1cccccccccccc617d77777777700577760707777777777777
ccccccccccccccccccd77777777777776ccccccccccccccccccccccccccccccdccccccccccccccccc1ccccccccccc1c6d7777777767717777777777777777777
ccccccccccccccccccc777777777777776ccccccccccccccccccccccccccccccccccccccccccccccc0ccccccccccccccc6d77777700007711777777777777777
ccccccccccccccccccc677777777777776cccccccccccc101ccccccccccccccccccccccccccccccc11ccccccccccc1cc1ccd7777760017d5717d777777707767
cccccccccccccccccccc777777777777776ccccccccccc11c1ccccccccccccccccccccccccc1ccccc01ccccccccccccccccccc77777777700077777777077067
cccccccccccccccccccc7777777777777777ccccccccc11111cccccccccccccccccccccccccdcccccc1cccccccccccccccccccd6777777777777d17777001067
ccccccccccccccccccccc77771c7610711777ccccccc1c111ccccccccccccccccccccccccccccccccc6ccccccccccccccccccccc6d7777777777707777761777
cccccccccccccccccccdcd7770110d7076d77ccccccccccccccccccccccccccccccccccccccccccccc7cccccccccccccccccccccc66777777777777777777777
cccccccccccccccccccdc77777d70cc1777777cccccccccccccccccccccccccccccccccccccccccccc71ccccccccccccc6ccccccccc776777777777777777777
cccccccccccccccdccc6ccd777776106777776cccccccccccccccccccccccccccccccccccccccccccc71ccccccccccccccccccccccccdd577777777777777777
ccccccccccccccccccc7ccc67777677777777d6cccccccccccccccccccccccccccccccccdccccccccc61ccccccccccccccccccccccccc1777777777777777767
ccccccccccccccccccc6cccc7777775777777777cccccccc1100111cccccccccccccccdccccccccccc07ccccccccccccccccccccccccc11dcd77777777777767
cccccccccccccccccccccccc6777775777777777dccccccc1177cc1ccccccccccccccccccccccccccc17ccccccccccccc1cccccccccccccc61777777d7777777
cccccccccccccc1cccccccccd77765777777777771cccccc0cccccc1cccccccccccccccdccccccccccc7ccccccccccccccccccc1cccccccccccd167601067776
ccccccccccccccccccccccccc77777777777777776cccc1c00cccc11ccccccccccccccccccccccccccc1cccccccccccccccccc1cccccccccccccc66077107776
ccccccccccccccccccccccccc677777777777777766cccccc1000001ccccccccccccccccccccccccccc01ccccccccccccccccc7ccccd11cd6cccccc077707776
cccccccccccccccccccccccccc777777777777777d66cc11cc01100cccccccccccccccccccccccccccc01cccccccccccccccc11ccccc1ccccccc1cc106106766
ccccccccccccccccccccccccccc7777777777777776710ddcc1111cccccccccccccccc1cccccccccccc07cccccccccccccccc11ccccccccccccccccc101cc6d6
cccccccccccccccccccccccccc166677777777777777111d1cccccccccccccccccccccdcccccccccccc171ccccccccccccccc7cccccccccccccccccccccccc66
cccccccccccccccccccccccccccdd67777777777777761011cccccc1ccccccccccccccccccccccccccc171cccccccccccccc16cccccccc1cdccccccccccccc66
cccccccccccccccccccccccccccc67777777777777777dcccc111cccccccccccccccccccccccccccccc171ccccccccccccccc5cccccccc171c0ccccccccccc6c
cccccccccccccccccccc1cccccccc67777777777777777cccc161ccccccccccccccccccc61ccccccccc171cccccccccccccc1dcccccc1c5d71cccccccccccccc
cccccccccccccccccc1cccccccccc777777777777777777dd1611ccccccccccccccccccccccccccccccc71cccccccccccccc1dcccccccc1101c1cccccccccccc
ccccccccccccccccccccccccccccc167777777777777777776dccccccccccccccccccccccccccccccc1c76cccccccccccccc10ccccccccc1cccccccccccccccc
ccccccccccccccccccccccccccc117757777777777776d7777cccc1ccccccccccccccccccccccccccccc77111100111cccc171cccccccccccccccccccccccccc
ccccccccccccccccccccccccc111c7d057777777701d16c0771dcccccccccccccccccccccccccccccc1077888888888881007ccccccccccccccccccccccccccc
ccccccccccccccccccccccccccc101107777777776d1ccc077d71ccccccccccccccccccccccccccc5088075d666667d8888171cccccccccccccccccccccccccc
cccccccccccccccccccccccccccc10117777777760100000777c61cccccccccccccccccccccccc108888d78888888888868dd801cccccccccccccccccccccccc
cccccccccccccccccccccccccc1188886777777777777d67776d6d1cccccccc1ccccccccccccc1588658868888888888888708881ccccccccccccccccccccc1c
ccccccccccccccccccccccccc18888d8877777777777777777771c171dcccccccccccccccccc088888888d0888888888887788d880cccccccccccccccccccc1c
ccccccccccccccccccccccc108868888886d767777777777777777cc117761cccccccccccc1188d888888875888888888178888d1811cccccccccccccccccccc
ccccccccccccccccccccccc088d888888885d7777777777777777677cc17761cccccccccc188588888888877088888888178888888811cc1cccccccccccccccc
cccccccccccccccccccccc188d888888888156677777777777777766ccccc1761cccccccc18888888888887771888888877881808d881ccccccccccccccccccc

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

