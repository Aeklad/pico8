pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
--help!!
function _init()
 debug={}
 cartdata("aeklad_dungeon_v1")
 dset(0,0)
 random=rnd()
 seed=random
 oldseed=dget(0)
 floorsd={}
 day = stat(92)
 month= stat(91)
 year= stat(90)
 daily=day*0.1+month*3.1+(year-2019)*37.2
 srand(daily)
 for i=0,7 do
  floorsd[i]=rnd()+i
 end
 srand(random)
 t=0
 shake=0
 dpal=explodeval("0,1,1,2,1,13,6,4,4,9,3,13,1,13,14")
 dirx=explodeval("-1,1,0,0,1,1,-1,-1")
 diry=explodeval("0,0,-1,1,-1,1,1,-1")
 itm_name=explode("dagger,staff,short sword,broad sword,bastard sword,vorpal sword,cloth armor,leather armor,scale mail,chain mail,plate armor,magic plate,food 1,food 2,food 3,food 4,food 5,food 6,food 7,small rock,polished stone,balanced knife,throwing axe")
 itm_type=explode("wep,wep,wep,wep,wep,wep,arm,arm,arm,arm,arm,arm,fud,fud,fud,fud,fud,fud,fud,thr,thr,thr,thr")
 itm_ico=explodeval("90,91,92,105,106,107,108,125,126,127,141,142,89,175,190,191,238,239,254,143,158,159,174")
 itm_stat1=explodeval("1,2,3,4,5,6,0,0,0,0,1,2,1,2,3,4,5,6,7,1,2,3,4")
 itm_stat2=explodeval("0,0,0,0,0,0,1,2,3,4,3,3,1,1,1,1,1,1,1,0,0,0,0")
 itm_minf=explodeval("1,2,3,4,5,6,1,2,3,4,5,6,1,1,1,1,1,1,1,2,3,4,4")
 itm_maxf=explodeval("3,4,5,6,7,8,3,4,5,6,7,8,8,8,8,8,8,8,4,6,7,8,8")
 itm_desc=explode(",,,,,,,,,,,, heals, heals a lot, increases hp, stuns, is cursed, is blessed, freezes,,,")
 mob_name=explode("player,slime    ,giant bat,skeleton ,goblin   ,hydra    ,troll    ,cyclops   ,zorn     ")
 mob_ani=explodeval("240,192,196,200,204,208,212,216,220")
 mob_col=explodeval("7,5,5,6,11,13,12,15,15")
 mob_hp=explodeval("5,1,2,3,3,4,5,14,3")
 mob_los=explodeval("4,4,4,4,4,4,4,4,4")
 mob_atk=explodeval("1,1,2,1,2,3,3,5,5")
 mob_minf=explodeval("1,1,2,3,4,5,6,7,8")
 mob_maxf=explodeval("2,3,4,5,6,7,8,8,8")
 mob_spec=explode("player,divide,fly,fast,steal,stun,curse,slow,magic")
 mob_loot=explodeval("0,0,0,0,0,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15")
 mob_tagline=explode("player,slimes: sometimes they divide,bats: they like to fly,skeletons: are they so fast?,goblins: tricky little thieves,hydras: three heads-stunning,trolls: curses all around,cyclops: these guys are slow,zorns: they magical!")
 crv_sig=explodeval("255,214,124,179,233")
 crv_msk=explodeval("0,9,3,12,6")
 free_sig=explodeval("0,0,0,0,16,64,32,128,161,104,84,146")
 free_msk=explodeval("8,4,2,1,6,12,9,3,10,5,10,5")

 wall_sig=explodeval("251,233,253,84,146,80,16,144,112,208,241,248,210,177,225,120,179,0,124,104,161,64,240,128,224,176,242,244,116,232,178,212,247,214,254,192,48,96,32,160,245,250,243,249,246,252")
 
 wall_msk=explodeval("0,6,0,11,13,11,15,13,3,9,0,0,9,12,6,3,12,15,3,7,14,15,0,15,6,12,0,0,3,6,12,9,0,9,0,15,15,7,15,14,0,0,0,0,0,0")
 attract=true
 startgame()
end

function _update60()
 t+=1
 _upd()
 dohpwind()
 dofloats()
end

function _draw()
 doshake()
 _drw()
  
 if floor>-1 then
  drawind()
  drawlogo() 
  for f in all(float) do
   oprint8(f.txt,f.x,f.y,f.c,0)
  end
 end
 --fadeperc=0
 checkfade()
 cursor(4,4)
 color(8)
 for txt in all(debug) do
  print(txt)
 end
end

function startgame()
 challenge=false
 oldseed=dget(0)
 seed=random
 poke(0x3101,194)--start loop
 music(0)
 tani=0
 fadeperc=1
 buttbuff=-1
 logo_t=240
 logo_y=35
 skipai=false
 win=false
 winfloor=9
 mob={}
 dmob={}
 p_mob=addmob(1,1,1)
 mob_typ=1
 p_t=0
 inv,eqp={},{}
 makeipool()
 foodnames()
 red=89
 yellow=175
 green=190
 orange=191
 purple=238
 white=239
 gray=254
 wind={}
 float={}
 talkwind = nil
 hpwind=addwind(5,5,38,13,{})
 thrdx,thrdy=0,-1
 --takeitem(12)
 --takeitem(13)
 --takeitem(14)
 --takeitem(15)
 --takeitem(16)
 --takeitem(17)
 _upd=update_game
 _drw=draw_game
 st_steps,st_kills,st_meals,st_killer=0,0,0,""
 if attract then
  genfloor(-1)
 else
  genfloor(0)
 end
end
-->8
--updates tab 1

function update_game()
 if talkwind then
  if getbutt()==5 then
   sfx(53)
   talkwind.dur=0
   talkwind=nil
  end
 else
  dobuttbuff() 
  dobutt(buttbuff)
  buttbuff=-1
 end
end

function update_inv()
 --inventory
 if move_mnu(curwind) and curwind==invwind then
  showhint()
 end
 if btnp(4) then
  sfx(53)
  if curwind==invwind then
   _upd=update_game
   invwind.dur=0
   statwind.dur=0
   if hintwind then
    hintwind.dur=0
   end
  elseif curwind==usewind then
   curwind.dur=0
   curwind=invwind
  end
 elseif btnp(5) then
  sfx(54)
  if curwind==invwind and invwind.cur!=3 then
   showuse()
  elseif curwind==usewind then
   --use window confirme
   triguse()
  end
 end
end
 
function update_throw()
 local b=getbutt()
  if b>=0 and b<=3 then
   thrdx=dirx[b+1]
   thrdy=diry[b+1]
  end
 if b==4 then
  _upd=update_game
 elseif b==5 then
  throw()
 end
end

function move_mnu(wnd)
 local moved=false
 if btnp(2) then
  sfx(56)
  wnd.cur-=1
  moved=true
 elseif btnp(3) then
  sfx(56)
  wnd.cur+=1
  moved=true
 end
 wnd.cur=(wnd.cur-1)%#wnd.txt+1
 return moved
end

function update_pturn()
 p_mob.turns=1--THIS IS Something!
 if p_mob.freeze then 
  st_killer="cold drink"
  p_mob.hp=0
 end
 dobuttbuff() 
 p_t=min(p_t+.125,1)
 if p_mob.mov then
  p_mob:mov()
 end

 if p_t==1 then
  if p_mob.movecount >1 then
   p_mob.movecount =0
  end
  p_mob.movecount +=1
  _upd=update_game
  if trig_step() then return end
  if checkend() and not skipai then
   doai()
  end
  skipai=false 
 end
end

function update_aiturn()
 dobuttbuff() 
 p_t=min(p_t+.125,1)
 for m in all(mob) do
  if m!=p_mob and m.mov then  
   m:mov()
  end
 end
 if p_t==1 then
  _upd=update_game
  if checkend()then
   if p_mob.turns==1 then
    doai()
    p_mob.turns -=1
   end
   if p_mob.stun then
    p_mob.stun=false
    doai()
   end
  end
 end
end

function update_gover()
 if btn(❎) then
  attract=false
  sfx(54)
  fadeout()
  load("rogue.pi")
  startgame()
 end
 --gameover
end

function dobuttbuff()
 if buttbuff==-1 then
  buttbuff=getbutt()
 end
end

function getbutt()
 for i=0,5 do
  if btnp(i) then
   return i
  end
 end
 return -1
end

function dobutt(butt)
 if butt<0 then return end
 if logo_t>0 then logo_t=0 end
 if butt<4 then
  moveplayer(dirx[butt+1],diry[butt+1])
 elseif butt==5 then
  sfx(54)
  showinv()
 --elseif butt==4 then
  --genfloor(floor+1)
 end
end
 
-->8
--draws tab 2

function draw_game()
 cls(0)
 if fadeperc==1 then return end
 animap()
 map()
 for m in all(dmob) do
  if sin(time()*8)>0 or m==p_mob then
   drawmob(m)
  end
  m.dur -=1
  if m.dur<=0 and m!=p_mob then 
   del(dmob,m)
  end
 end

 for i=#mob,1,-1 do
  drawmob(mob[i])
 end

 if _upd==update_throw then
  local tx,ty=throwtile()
  local lx1,ly1=p_mob.x*8+3+thrdx*4,p_mob.y*8+3+thrdy*4
  local lx2,ly2=mid(0,tx*8+3,127),mid(0,ty*8+3,127)
  rectfill(lx1+thrdy,ly1+thrdx,lx2-thrdy,ly2-thrdx,0)
  local thrani,mb=flr(t/7)%2==0,getmob(tx,ty)
  if thrani then
   fillp(0b1010010110100101)
  else
   fillp(0b0101101001011010)
  end
  line(lx1,ly1,lx2,ly2,7)
  fillp()
  oprint8("x",lx2-1,ly2-2,7)
  if mb and thrani then 
   mb.flash=1
  end
 end

 for x=0,15 do
  for y=0,15 do
   if fog[x][y]==1 then
    rectfill2(x*8,y*8,8,8,0)
   end
  end
 end
 if floor==-1 then
  draw_attract()
 end
end

function drawlogo()
 if logo_y>-24 then
  logo_t-=1
  if logo_t<0 then
   logo_y+=logo_t/20
  end
  palt(12,true)
  palt(0,false)
  spr(228,20,logo_y,10,2)
  palt()
  --oprint8("find the sphere of world saving",0,logo_y+24,7,0)
 end
end

function drawmob(m)
  local col=m.col
  if m.flash>0 then
   m.flash-=1
   col=4
  elseif m.bless<0 then
   col=3
  elseif m.bless>0 then
   col=10
  elseif m.stun then
   col=2
  elseif m.freeze then
   col=7
  end
  draw_spr(m.col,get_frame(m,m.ani),m.x*8+m.ox,m.y*8+m.oy,col,m.flp)	
end

function draw_gover()
 cls()
 palt(12,true)
 spr(gover_spr,gover_x,30,gover_w,2)
 if not win then
  print("killed by a "..st_killer,20,46,6)
 end
 palt()
 color(5)
 cursor(40,56)
 if not win then
  print("floor: "..floor)
 end
 print("steps: "..st_steps)
 print("kills: "..st_kills)
 print("meals: "..st_meals)
 print("press x",46,90,5+abs(sin(time()/3)*2))
end

function draw_attract()
 local s1,s2="in the depths danger lurks","press x to start your adventure"
 _upd=update_gover
 copymap(0,64)
 palt(12,true)
 palt(0,false)
 spr(144,11,8,14,3)
 palt()
 if t%240== 0 or attract then
  attract=false
  mob_typ+=1
  if mob_typ > 9 then 
   mob_typ=2
  end
  mob={}
  add(mob,addmob(mob_typ,7,9))
 end
 print(s1,hcenter(s1),34,7)
 print(s2,hcenter(s2),120,5+abs(sin(time()/3)*2))
 if mob_typ >=2 then
  print(mob_tagline[mob_typ],hcenter(mob_tagline[mob_typ]),84,7)
 end
end

function animap()
 tani+=1
 if (tani<15) return --weird syntax i don't get it<f2>
 tani=0
 for x=0,15 do
  for y=0,15 do
   local tle=mget(x,y)
   if tle==64 or tle==66 then
    tle+=1
   elseif tle==65 or tle==67 then
    tle-=1
   end
  mset(x,y,tle)
  end
 end
end


-->8
--tools tab 3

function get_frame(_mob,_ani)
 if not _mob.freeze then
  return _ani[flr(t/15)%#_ani+1]
 else
  return _mob.frame
 end
end

function draw_spr(_mob_default_color,_spr,_x,_y,_c,_flip)
 pal(_mob_default_color,_c)
 spr(_spr,_x,_y,1,1,_flip)
 pal()
end

function rectfill2(_x,_y,_w,_h,_c)
 rectfill(_x,_y,_x+max(_w-1,0),_y+max(_h-1,0),_c)
end

function oprint8(_t,_x,_y,_c,_c2)
 for i=1,8 do
  print(_t,_x+dirx[i],_y+diry[i],_c2)
 end
 print(_t,_x,_y,_c)
end

function hcenter(s)
 --screen center minus the string length
 --times half a characters width in pixels
 return 64-#s*2
end

function dist(fx,fy,tx,ty)
 local dx,dy=fx-tx,fy-ty
 return sqrt(dx*dx+dy*dy)
end

function dofade()
 local p,kmax,col,k=flr(mid(0,fadeperc,1)*100)
 for j=1,15 do
  col=j
  kmax=flr((p+j*1.46)/22)
  for k=1,kmax do
   col=dpal[col]
  end
  pal(j,col,1)
 end
end

function checkfade()
 if fadeperc>0 then
  fadeperc=max(fadeperc-0.04,0)
  dofade()
 end
end

function wait(_wait)
 repeat
  _wait-=1
  flip()
 until _wait<0
end
 
function fadeout(spd,_wait)
 if (spd==nil) spd=0.04
 if (_wait==nil) _wait=0
 repeat
  fadeperc=min(fadeperc+spd,1)
  dofade()
  flip()
 until fadeperc==1
 wait(_wait)
end

function blankmap(_dflt)
 local ret={}
 if(_dflt==nil) _dflt=0

 for x=0,15 do
  ret[x]={}
  for y=0,15 do
   ret[x][y]=_dflt
  end
 end
 return ret
end

function getrnd(arr)
 
 local i= 1+flr(rnd(#arr))
 return arr[i],i
end

function copymap(x,y)
 local tle
 for _x=0,15 do
  for _y=0,15 do
   tle=mget(_x+x,_y+y)
   mset(_x,_y,tle)
   if tle==15 then
    p_mob.x,p_mob.y=_x,_y
   end
  end
 end
end

function explode(s)
 local retval,lastpos={},1
 for i=1,#s do
  if sub(s,i,i)=="," then
   add(retval,sub(s,lastpos,i-1))
   i+=1
   lastpos=i
  end
 end
 add(retval,sub(s,lastpos,#s))
 return retval
end

function explodeval(_arr)
 return toval(explode(_arr))
end

function toval(_arr)
 local _retarr={}
 for _i in all(_arr) do
  add(_retarr,flr(tonum(_i)))
 end
 return _retarr
end

function doshake()
 local shakex,shakey=16,16--16-rnd(32),16-rnd(32)
 camera(shakex*shake,shakey*shake)
 shake*=.95
 if (shake<0.05) shake=0
end
-->8
--gameplay tab 4
function moveplayer(dx,dy)
 local destx,desty=p_mob.x+dx,p_mob.y+dy
 local tle=mget(destx,desty)

 if iswalkable(destx,desty,"checkmobs") then
  sfx(63)
  mobwalk(p_mob,dx,dy)
  st_steps+=1
  p_t=0
  _upd=update_pturn
 else
  --not walkable
  mobbump(p_mob,dx,dy)
  p_t=0
  _upd=update_pturn

  local mob=getmob(destx,desty)
  if mob then
   sfx(57)
   hitmob(p_mob,mob)
  else
   if fget(tle,1) then
    trig_bump(tle,destx,desty) 
   else
    skipai=true
    --mset(destx,desty,1)
   end
  end
 end
 unfog()
end

function trig_bump(tle,destx,desty)
 for i=1,23 do
  if tle==itm_ico[i] then
   if freeinvslot()>0 then
    takeitem(i)
    showmsg("found! "..itm_name[i],60) 
    mset (destx,desty,76)
   end
  end
 end
   
 if tle==7 or tle==8 then
  --vase
  sfx(59)
  mset(destx,desty,76)
  if rnd(3)<1 and floor>0 then
   if rnd(5)<1 then
    addmob(getrnd(mobpool),destx,desty)
    sfx(60)
   else
    if freeinvslot()==0 then
     local itm=getrnd(fipool_com)
     --showmsg("found! "..itm_name[itm],60) 
     showmsg("inventory full",120)
     mset(destx,desty,itm_ico[itm])
     sfx(61)
    else
     --sfx(61)
     local itm=getrnd(fipool_com)
     takeitem(itm)
     showmsg(itm_name[itm].."!",60)
    end
   end
  end
 elseif tle==10 or tle==12 then
  --chest
  local itm=getrnd(fipool_com)
  if tle==12 then
   itm=getitm_rar()
  end
  if freeinvslot()==0 then
   showmsg("inventory full",120)
   --showmsg("found! "..itm_name[itm],60) 
   sfx(61)
   mset(destx,desty,tle-1)
   mset(destx,desty,itm_ico[itm])
   skipai=true
  else
   sfx(47)
   sfx(61)
   mset(destx,desty,tle-1)
   takeitem(itm)
   showmsg(itm_name[itm].."!",60)
  end
 elseif tle==13 then
  --door
  sfx(50)
  mset(destx,desty,62)
 elseif tle==6 then
  --stone tablet
  if floor==0 then
   sfx(54)
   showtalk(explode(" this is a dark, and scary place., north is bad, east is worse, but only open, once per day. "))
  end
 elseif tle==110 then
  win=true
 end
end

function trig_step()
 cfloor=floor
 local tle=mget(p_mob.x,p_mob.y)
 for i=1,23 do
  if tle==itm_ico[i] then
   if freeinvslot()>0 then
    takeitem(i)
    showmsg("found! "..itm_name[i],60) 
    mset (p_mob.x,p_mob.y,76)
   end
  end
 end
 if tle==14 then 
  sfx(55)
  p_mob.bless=0
  fadeout()
  genfloor(floor+1)
  floormsg()
  return true
 elseif tle==5 then
  sfx(55)
  seed=daily
  dset(0,daily)
  challenge=true
  fadeout()
  genfloor(floor+1)
  floormsg()
 else
  return false
 end
end

function getmob(x,y)
 for m in all(mob) do
  if m.x==x and m.y==y then
   return m
  end
 end
 return false
end

function iswalkable(x,y,mode)
 --turniary formula-- x(variable)=cond(true/false) and
 local mode = mode or ""
 -- if mode== nil then mode="" end
 if inbounds(x,y) then
  local tle=mget(x,y)
  if mode=="sight" then
   return not fget(tle,2) --fget(tle,3) flyable tile
  else
   if not fget(tle,0) then
    if mode=="checkmobs" then
     return not getmob(x,y)
    end
    return true
   end
  end
 end
 return false
end

function isflyable(x,y)
 if inbounds(x,y) then
  local tle=mget(x,y)
   if fget(tle,3) then
    return true
   end
 end
 return false
end

function inbounds(x,y)
 return not(x<0 or y<0 or x>15 or y>15)
end

function hitmob(atkm,defm,rawdmg)
 local dmg=atkm and atkm.atk or rawdmg
 --add curse/bless
 if defm.bless<0 then
  dmg*=2
 elseif defm.bless>0 then
  dmg=flr(dmg/2)
 elseif defm.spec=="divide" and defm.charge>0 then
  --divide(defm)
  defm.charge-=1
 end
 defm.bless=0
 local def=defm.defmin+flr(rnd(defm.defmax-defm.defmin+1))
 dmg-=min(def,dmg)
 defm.hp-=dmg
 defm.flash=10
 addfloat("-"..dmg,defm.x*8,defm.y*8,9)
 shake=defm==p_mob and 0.08 or 0.04
 if defm.hp<=0 then
  if defm != p_mob then 
   st_kills+=1 
  else
   st_killer=atkm.name
  end
  add(dmob,defm)
  defm.loot=getrnd(mob_loot)+floor--flr(rnd()*13+(5+floor))
  if defm.loot>12 then
   if freeinvslot()>0 then
    takeitem(defm.loot)
    showmsg("found! "..itm_name[defm.loot],60) 
   else
    if defm!=p_mob then 
     --showmsg("found! "..itm_name[defm.loot],60) 
     sfx(61)
    end
   -- showmsg("inventory full",60)
    mset(defm.x,defm.y,itm_ico[defm.loot])
   end
  end
  del(mob,defm)
  defm.dur=10
 end
end

function healmob(mb,hp)
	hp=min(mb.hpmax-mb.hp,hp)
 mb.hp+=hp
 mb.flash=10
 addfloat("+"..hp,mb.x*8,mb.y*8,7)
 sfx(62)
end

function stunmob(mb)
 mb.stun=true
 mb.flash=10
 addfloat("stun",mb.x*8-3,mb.y*8,7)
 sfx(62)
end
function freeze_mob(mb)
 mb.freeze=true
 mb.flash=10
 addfloat("freeze",mb.x*8-3,mb.y*8,7)
 sfx(62)
end

function blessmob(mb,val)
 mb.bless=mid(-1,1,mb.bless+val)
 mb.flash=10
 local txt="bless"
 if val <0 then txt="curse" end
 addfloat(txt,mb.x*8-5,mb.y*8,7)
 if mb.spec=="curse" and val>0 then
  add(dmob,mb)
  del(mob,mb)
  mb.dur=10
 end
 sfx(62)
end

function rob(mb)
 for i= 1,6 do
  local itm=inv[i]
  if itm_type[itm]=="fud" then
   addfloat(itm_name[itm].." stolen!",32,mb.y*8+10,7)
   eat(itm,mb)
   inv[i]=nil
   break
  else
   print("")
  end
 end
end

function divide(mb)
 local r=flr(rnd()*7+1)
 local xoffset=getrnd(dirx)
 local yoffset=getrnd(diry)
 if r==3 then
  addmob(2,mb.x+xoffset,mb.y+yoffset)
 end
end

function magic(m)
 local spells={"stun","rob","hit","curse"}
 local spell=getrnd(spells)
 if spell=="stun" then
  stunmob(p_mob)
 elseif spell=="rob" then
  rob(m)
 elseif spell=="hit" then
  hitmob(m,p_mob)
 elseif spell=="curse" then
  blessmob(p_mob,-1) 
 else
  return nil
 end
 addfloat("magic!",m.x*8-3,m.y*8,7)
end

function checkend()
 if win then
  music(32)
  gover_spr, gover_x, gover_w=112,13,13
  showgover()
  return false
 elseif p_mob.hp<=0 then
  music(61)
  gover_spr, gover_x, gover_w=80,20,9
  showgover()
  return false
 end
 return true
end

function showgover()
 wind,_upd,_drw={},update_gover,draw_gover
 fadeout(0.02)
end

function los(x1,y1,x2,y2)
 local frst,sx,sy,dx,dy=true
 if dist(x1,y1,x2,y2)== 1 then return true end
 if y1>y2 then
  x1,x2,y1,y2=x2,x1,y2,y1
 end
  sy,dy=1,y2-y1
 if x1<x2 then
  sx,dx=1,x2-x1
 else 
  sx,dx=-1,x1-x2
 end
 local err,e2=dx-dy 
 while not(x1==x2 and y1==y2) do
  if not frst and iswalkable(x1,y1,"sight")==false then return false end
  e2,frst=err+err,false
  if e2>-dy then
   err-=dy
   x1+=sx
  end
  if e2<dx then
   err+=dx
   y1+=sy
  end
 end
 return true
end
 
function unfog()
 local px,py=p_mob.x,p_mob.y
 for x=0,15 do
  for y=0,15 do
   if fog[x][y]==1 and dist(px,py,x,y)<= p_mob.los and los(px,py,x,y) then
    unfogtile(x,y)
   end
  end
 end
end

function unfogtile(x,y)
 fog[x][y]=0
 if iswalkable(x,y,"sight") then
  for i=1,4 do
   local tx,ty=x+dirx[i],y+diry[i]
   if inbounds(tx,ty) and not iswalkable(tx,ty,"checkmobs") then
    fog[tx][ty]=0
   end
  end
 end
end

function calcdist(tx,ty)
 local cand,stp,candnew={},0
 distmap=blankmap(-1)
 add(cand,{x=tx,y=ty})
 distmap[tx][ty]=0
 repeat
 stp+=1
 candnew={}
 for c in all(cand) do
  for d=1,4 do
   local dx=c.x+dirx[d]
   local dy=c.y+diry[d]
   if inbounds(dx,dy) and distmap[dx][dy]==-1 then
    distmap[dx][dy]=stp
    if iswalkable(dx,dy) then
     add(candnew,{x=dx,y=dy})
    end
   end
  end
 end
 cand=candnew
until #cand==0
end

function updatestats()
	local atk,dmin,dmax=1,0,0
	if eqp[1] then
		atk+=itm_stat1[eqp[1]]
	end
    if eqp[2] then
     dmin+=itm_stat1[eqp[2]]
     dmax+=itm_stat2[eqp[2]]
    end
	p_mob.atk=atk
	p_mob.defmin=dmin
	p_mob.defmax=dmax
	 
end

function eat(itm,mb)
	local effect=itm_stat1[itm]
 if not itm_known[itm] then
  showmsg(itm_name[itm]..itm_desc[itm],120)
  itm_known[itm]=true
 end
 if mb==p_mob then st_meals+=1 end
	if effect==1 then
     --heal
     healmob(mb,1)
    elseif effect==2 then
     --heal a lot
     healmob(mb,3)
    elseif effect==3 then
     --plus maxhp
     mb.hpmax+=1
     healmob(mb,1)
    elseif effect==4 then
     --stun       
    stunmob(mb)
    elseif effect==5 then
     --curse
     blessmob(mb,-1)
    elseif effect==6 then
     --bless
     blessmob(mb,1)
    elseif effect==7 then
     --freeze
     freeze_mob(mb)
	end
end

function throw()
 local tx,ty=throwtile()
 local itm=inv[thrslt]
 inv[thrslt]=nil
 sfx(52)
 if inbounds(tx,ty) then
  local mb=getmob(tx,ty)
  local tle=mget(tx,ty)
  if mb then
   if itm_type[itm]=="fud" then
    eat(itm,mb)
   else
    hitmob(nil,mb,itm_stat1[itm])
    sfx(57)
   end
  elseif tle then
   trig_bump(tle,tx,ty)
  end
 end
 mobbump(p_mob,thrdx,thrdy)
 p_t=0
 _upd=update_pturn
end

function throwtile()
 local tx,ty=p_mob.x,p_mob.y
 repeat
  tx+=thrdx
  ty+=thrdy
 until not iswalkable(tx,ty,"checkmobs")
 return tx,ty
end

-->8
--ui tab 5

function addwind(_x,_y,_w,_h,_txt)
 local w={x=_x,
  y=_y,
  w=_w,
  h=_h,
  txt=_txt
 }
 add(wind,w)
 return w
end

function drawind()
 for w in all(wind) do
  local wx,wy,ww,wh=w.x,w.y,w.w,w.h
  rectfill2(wx,wy,ww,wh,1)
  rect(wx+1,wy+1,wx+ww-2,wy+wh-2,6)
  wx+=4
  wy+=4
  clip(wx,wy,ww-8,wh-8)
  if w.cur then
   wx+=6
  end

  for i=1,#w.txt do
   local txt,c=w.txt[i],6
   if w.col and w.col[i] then
    c=w.col[i]
   end
   print(txt,wx,wy,c)
   if i==w.cur then
    spr(255,wx-5+sin(time()),wy)
   end
   wy+=6
  end
  clip()
  if w.dur then
   w.dur-=1
   if w.dur<=0 then
    local dif=wh/4
    w.y+=dif/2
    w.h-=dif
    if wh<3 then
     del(wind,w)
    end
   end
  else

  if w.butt then
  oprint8("❎",wx+ww-15,wy-1+sin(time()),6,0)
  end

  end
 end
end

function showmsg(txt,dur)
 local wid=(#txt+2)*4+7
 local w=addwind(63-wid/2,50,wid,13,{txt})
 w.dur=dur
end

function showtalk(txt)
 talkwind=addwind(16,50,94,#txt*6+7,txt)
 talkwind.butt=true
end

function addfloat(_txt,_x,_y,_c)
 add(float,{txt=_txt,x=_x,y=_y,c=_c,ty=_y-10,t=0})
end

function dofloats()
 for f in all(float) do
  f.y+=(f.ty-f.y)/10
  f.t+=1
  if f.t>70 then
   del(float,f)
  end
 end
end
 
function dohpwind()
 hpwind.txt[1]="♥"..p_mob.hp.."/"..p_mob.hpmax
 local hpy=5
 if p_mob.y<8 then
  hpy=110
 end
 hpwind.y+=(hpy-hpwind.y)/5
end

function showinv()
 local txt,col,itm,eqt={},{}
 _upd=update_inv
 for i=1,2 do
  itm=eqp[i]
  if itm then
   eqt=itm_name[itm]
   add(col,6)
  else
   eqt=i==1 and "[weapon]" or "[armor]"
   add(col,5)
  end
  add(txt,eqt)
 end
 add(txt,"…………………………")
 add(col,6)
 for i=1,6 do
  local itm=inv[i]
  if itm then
   add(txt,itm_name[itm])
   add(col,6)
  else
   add(txt,"...")
   add(col,5)
  end
 end
 invwind=addwind(5,17,84,62,txt)
 invwind.cur=3
 invwind.col=col
 txt="ok   "
 if p_mob.bless<0 then
  txt="curse "
 elseif p_mob.bless>0 then
  txt="bless "
 end 
 statwind=addwind(5,5,84,13,{txt.."atk:"..p_mob.atk.." def:"..p_mob.defmin.."-"..p_mob.defmax})
 curwind=invwind
 showhint()
end

function showuse()
 local itm=invwind.cur<3 and eqp[invwind.cur] or inv[invwind.cur-3]
 local typ,txt=itm_type[itm],{}
 if itm==nil then return end
 if (typ=="wep" or typ=="arm") and invwind.cur>3 then 
  add(txt,"equip")
 end
 if typ=="fud" then
  add(txt,"eat")
 end
 if typ=="thr" or typ=="fud" then
  add(txt,"throw")
 end
 add(txt,"trash")
 usewind=addwind(84,invwind.cur*6+11,36,7+#txt*6,txt)
 usewind.cur=1
 curwind=usewind
end

function triguse()
 local verb,i,back=usewind.txt[usewind.cur],invwind.cur,true
 local itm=i<3 and eqp[i] or inv[i-3]
 if verb=="trash" then
  if i<3 then
   eqp[i]=nil
  else
   inv[i-3]=nil
  end
 elseif verb=="equip" then
  local slot=2
  if itm_type[itm]=="wep" then
   slot=1
  end
  inv[i-3]=eqp[slot]
  eqp[slot]=itm
 elseif verb=="eat" then
  eat(itm,p_mob)
  _upd,inv[i-3],p_mob.mov,p_t,back=update_pturn,nil,nil,0,false
 elseif verb=="throw" then
  _upd,thrslt,back=update_throw,i-3,false
 end
 updatestats()
 --?
 usewind.dur=0
 if back then
  del(wind,invwind)
  del(wind,statwind)
  showinv()
  invwind.cur=i
 else
  invwind.dur=0
  statwind.dur=0
  if hintwind then
   hintwind.dur=0
  end
 end
end

function floormsg()
 showmsg("floor "..floor,120)
end
function showhint()
 if hintwind then
  hintwind.dur=0
  hintwind=nil
 end
 if invwind.cur>3 then
  local itm=inv[invwind.cur-3]
  if itm and itm_type[itm]=="fud" then
   local txt = itm_known[itm] and itm_name[itm]..itm_desc[itm] or "???"
   hintwind = addwind(5,78,#txt*4+7,13,{txt})
  end
 end
end

-->8
--mobs and items tab 6

function addmob(typ,mx,my)
 local m={
  x=mx,
  y=my,
  ox=0,
  oy=0,
  flp=false,
  ani={},
  frame=(mob_ani[typ])+flr(rnd()*4)+1,
  flash=0,
  col=mob_col[typ],
  freeze=false,
  turns = 1,
  stun=false,
  cast=false,
  stimer=0,
  charge=1,
  lastmoved=false,
  movecount=0,
  bless=0,
  spec=mob_spec[typ],
  hp=mob_hp[typ],
  hpmax=mob_hp[typ],
  atk=mob_atk[typ],
  defmin=0,
  defmax=0,
  los=mob_los[typ],
  task=ai_wait,
  name=mob_name[typ],
  loot=13
 }
 for i=0,3 do
  add(m.ani,mob_ani[typ]+i)
 end
 add(mob,m)
 return m
end

function mobwalk(mb,dx,dy)
 mb.x+=dx
 mb.y+=dy
 mobflip(mb,dx)
 mb.sox, mb.soy=-dx*8,-dy*8
 mb.ox, mb.oy= mb.sox, mb.soy
 mb.mov=mov_walk
end

function mobbump(mb,dx,dy)
 mobflip(mb,dx)
 mb.sox, mb.soy=dx*8,dy*8
 mb.ox, mb.oy=0,0
 mb.mov=mov_bump
end

function mobflip(mb,dx)
 mb.flp=dx==0 and mb.flp or dx<0
-- turniary statement in place of if statements
-- if dx<0 then
--   mb.flp=true
-- elseif dx>0 then
--   mb.flp=false
-- end
end

function mov_walk(self)
 local tme=1-p_t
 self.ox=self.sox*tme
 self.oy=self.oy*tme
end

function mov_bump(self)
 local tme=p_t>0.5 and 1-p_t or p_t
-- another turniary replacing if statements
-- local tme=p_t
-- if p_t>0.5 then
--  tme=1-p_t
-- end
 self.ox=self.sox*tme
 self.oy=self.soy*tme
end

function doai()
 local moving=false
 for m in all(mob) do
  if m!=p_mob then  
   m.mov=nil
   if m.stun or m.freeze then
    m.stimer+=1
    if m.stimer>=2 then m.stun=false end
   else
    m.lastmoved=m.task(m)
    moving=m.lastmoved or moving
   end
  end
 end
 if moving then
  _upd=update_aiturn
  p_t=0
 else
  p_mob.stun=false
 end
end

function ai_wait(m)
 if cansee(m,p_mob) then
  --agrro
  m.task=ai_attac
  m.tx,m.ty=p_mob.x,p_mob.y
  addfloat("!",m.x*8+2,m.y*8,10)
  return false
 end
 m.lastmoved=false
 return false
end

function ai_attac(m)
 if dist(m.x,m.y,p_mob.x,p_mob.y)==1 then
  --p_ttack player
  dx,dy=p_mob.x-m.x,p_mob.y-m.y
   if m.spec!="fast" and m.lastmoved then
    return false
   end
  mobbump(m,dx,dy)
  if m.spec=="stun" and m.charge>0 then
   stunmob(p_mob)
   m.charge-=1
  elseif m.spec=="curse" and m.charge>0 then
   hitmob(m,p_mob)
   blessmob(p_mob,-1)
   m.charge-=1
  elseif m.spec=="steal" and m.charge>0 then
   rob(m)
   m.charge-=1
  else
   hitmob(m,p_mob)
  end
  sfx(58)
  return true
 else
  --move toward player
  if cansee(m,p_mob) then
   m.tx,m.ty=p_mob.x,p_mob.y
   m.charge+=1
   if m.spec=="magic" and m.charge%8==(flr(rnd(8))) then
    magic(m)
    return false
   end
  end
  if m.x==m.tx and m.y==m.ty then
   --de aggro
   m.task=ai_wait
   addfloat("?",m.x*8+2,m.y*8,10)
   --m.lastmoved=false
  else
   if m.movecount>1 then
    m.movecount=0
   end
   if (m.spec=="slow" or m.spec=="magic") and p_mob.movecount <2 then
    return false
   end
   if m.spec!="fast" and m.lastmoved then
    return false
   end
   local bdst,cand=999,{}
   calcdist(m.tx,m.ty)
   for i=1,4 do
    local dx,dy=dirx[i],diry[i]
    local tx,ty=m.x+dx,m.y+dy
    if m.spec=="fly" and isflyable(tx,ty,"checkmobs") or iswalkable(tx,ty,"checkmobs") then
     local dst=distmap[tx][ty]
     if dst<bdst then
      cand={}
      bdst=dst
     end
     if dst==bdst then
      add(cand,i)
     end
    end
   end
   if #cand>0 then
    local c=getrnd(cand)
    mobwalk(m,dirx[c],diry[c])
    if m.movecount >2 then
     m.movecount=0
    end
    return true
   end
  end
 end
 return false
end

function cansee(m1,m2)
 return dist(m1.x,m1.y,m2.x,m2.y)<=m1.los and los(m1.x,m1.y,m2.x,m2.y)
end

function spawnmobs()
 mobpool={}
 for i=2,#mob_name do
  if mob_minf[i]<=floor and mob_maxf[i]>=floor then
   add(mobpool,i)
  end
 end
 if #mobpool==0 then return end
  
 local minmons=explodeval("3,5,7,9,10,11,12,13")
 local maxmons=explodeval("6,10,14,18,20,22,24,24")
 local placed,rpot=0,{}
 for r in all(rooms) do
  add(rpot,r)
 end
 repeat
  local r=getrnd(rpot)
  placed+=infestroom(r)
  del(rpot,r)
 until #rpot==0 or placed>maxmons[floor]
 if placed<minmons[floor] then
  repeat
   local x,y
   repeat
    x,y=flr(rnd(16)),flr(rnd(16))
  until iswalkable(x,y,"checkmobs") and (mget(x,y)==1 or mget(x,y)==4)
  addmob(getrnd(mobpool),x,y)
  placed+=1
  until placed>=minmons[floor]
 end
end

function infestroom(r)
 if r.nospawn then return 0 end
 local target,x,y=2+flr(rnd((r.w*r.h)/6-1))
 target=min(5,target)
 for i=1,target do
  repeat
   x=r.x+flr(rnd(r.w))
   y=r.y+flr(rnd(r.h))
  until iswalkable(x,y,"checkmobs") and (mget(x,y)==1 or mget(x,y)==4)
   addmob(getrnd(mobpool),x,y)
  end
 return target
end



-------------------------------------------------------
-- items
-------------------------------------------------------
function takeitem(itm)
 local i=freeinvslot()
 if i==0 then return false end
 inv[i]=itm
 sfx(61)
 return true
end

function freeinvslot()
 for i=1,6 do
  if not inv[i] then
   return i
  end
 end
 return 0
end

function makeipool()
 ipool_rar={}
 ipool_com={}

 for i=1,#itm_name do
  local t=itm_type[i]
  if t=="wep" or t=="arm" then
   add(ipool_rar,i)
  else
   add(ipool_com,i)
  end
 end
end

function makefipool()
 fipool_rar={}
 fipool_com={}

 for i in all(ipool_rar) do
  if itm_minf[i]<=floor 
  and itm_maxf[i]>=floor then
   add(fipool_rar,i)
  end
 end
 for i in all(ipool_com) do
  if itm_minf[i]<=floor 
  and itm_maxf[i]>=floor then
   add(fipool_com,i)
  end
 end
end

function getitm_rar()
 if #fipool_rar>0 then
  local itm=getrnd(fipool_rar)
  del(fipool_rar,itm)
  del(ipool_rar,itm)
  return itm
 else
  return getrnd(fipool_com)
 end
end

function foodnames()
 local adj,ad=explode("red,yellow,green,orange,purple,white,gray")
 local ico,ic=explodeval("89,175,190,191,238,239,254")
 itm_known={}
 for i=1,#itm_name do
  if itm_type[i]=="fud" then
   ad,ic=getrnd(adj)
   --del(ico,ic)
   del(adj,ad)
   itm_name[i]=ad.." ".."potion"
   itm_ico[i]=ico[ic]
   itm_known[i]=false
  end
 end
end

-->8
--gen
--tab 7 level gen

function genfloor(f)
 if challenge then  
  srand(floorsd[f])
  --challenge= false
 end
 floor=f
 makefipool()
 mob={}
 --if floor>-1 then
 add(mob,p_mob)
 --end
 fog=blankmap(1)
 --unfog()
 if floor==1 then
 poke(0x3101,66)--end loop
 
  st_steps=0
 end
 if floor==-1 then
  attract=true
 fog=blankmap(0)
 elseif floor==0 then
  add(mob,p_mob)
  copymap(16,0)
  if oldseed>=daily then
    mset(10,5,34)
   end
  unfog()
 elseif floor==winfloor then
  copymap(32,0)
  fog=blankmap(0)
 else
  fog=blankmap(1)
  mapgen()
  unfog()
 end
end

function mapgen()
 repeat
  copymap(48,0)
  rooms={}
  roomap=blankmap(0)
  doors={}
  genrooms()
  mazeworm()
  placeflags()
  carvedoors()
until #flaglib==1
 carvescuts()
 startend()
 fillends()
 prettywalls()
 installdoors()
 spawnchests()
 spawnmobs()
 decorooms()
end

function snapshot()
 return
 --cls()
 --map()
 --for i=0,1 do
 -- flip()
 --end
end

function dice()
 return flr(rnd(8)+1)
end
-------------------
--rooms
-------------------

function genrooms()
 local fmax,rmax=5,4
 local mw,mh=10,10
 repeat
  local r=rndroom(mw,mh)
  if placeroom(r) then
   if #rooms==1 then
    mw/=2
    mh/=2
   end
   rmax-=1
   snapshot()
  else
   fmax-=1
   if r.w>r.h then
    mw=max(mw-1,3)
   else
    mh=max(mh-1,3)
   end
  end
 until fmax<=0 or rmax<=0
end

function rndroom(mw,mh)
 --clamp max area
 local _w=3+flr(rnd(mw-2))
 mh=mid(35/_w,3,mh)
 local _h=3+flr(rnd(mh-2))
 return {
  x=0,
  y=0,
  w=_w,
  h=_h
 }

end

function placeroom(r)
 local cand,c={}
 for _x=0,16-r.w do
  for _y=0,16-r.h do
   if doesroomfit(r,_x,_y) then
    add(cand,{x=_x,y=_y})
   end
  end
 end
 if #cand==0 then return false end
 c=getrnd(cand)
 r.x=c.x
 r.y=c.y
 add(rooms,r)
 for _x=0,r.w-1 do
  for _y=0,r.h-1 do
   mset(_x+r.x,_y+r.y,1)
   roomap[_x+r.x][_y+r.y]=#rooms
   end
  end
  return true
end

function doesroomfit(r,x,y)
 for _x=-1,r.w+1 do
  for _y=-1,r.h+1 do
   if iswalkable(_x+x,_y+y) then
    return false
   end
  end
 end
 return true
end
------------------
--maze
------------------

function mazeworm()
 repeat
  local cand={}
  for _x=0,15 do
   for _y=0,15 do
     if cancarve(_x,_y,false) and not nexttoroom(_x,_y) then
      add(cand,{x=_x,y=_y})
     end
   end
  end
  if#cand>0 then
   local c=getrnd(cand)
   digworm(c.x,c.y)
  end
 until #cand<=1
end

function digworm(x,y)
 local dr,stp=1+flr(rnd(4)),0
 repeat 
  mset(x,y,1)
  snapshot()
  if not cancarve(x+dirx[dr],y+diry[dr],false) or (rnd()<0.5 and stp>2)then
   stp=0
   local cand={}
   for i=1,4 do
    if cancarve(x+dirx[i],y+diry[i],false) then
     add(cand,i)
    end
   end
   if #cand==0 then
    dr=8
   else
    dr=getrnd(cand)
   end
  end
  x+=dirx[dr]
  y+=diry[dr]
  stp+=1
 until dr==8 
end

function cancarve(x,y,walk)
 if not inbounds(x,y) then return false end
 local walk=walk==nil and iswalkable(x,y) or walk
 if iswalkable(x,y)==walk then 
  return sigarray(getsig(x,y),crv_sig,crv_msk)!=0 
 end
 return false
end
function bcomp(sig,match,mask)
 local mask=mask and mask or 0
 return bor(sig,mask)==bor(match,mask)
end

function getsig(x,y)
 local sig,digit=0
 for i=1,8 do
  local dx,dy=x+dirx[i],y+diry[i]
  if iswalkable(dx,dy) then
   digit=0
  else
   digit=1
  end
  sig=bor(sig,shl(digit,8-i))
 end
 return sig
end

function sigarray(sig,arr,marr)
 for i=1,#arr do
  if bcomp(sig,arr[i],marr[i]) then
   return i
  end
 end
 return 0
end

----------------------
-- doorways
----------------------

function placeflags()
 local curf=1
 flags,flaglib=blankmap(0),{}
 for _x=0,15 do
  for _y=0,15 do
   if iswalkable(_x,_y) and flags[_x][_y]==0 then
    growflag(_x,_y,curf)
    add(flaglib,curf)
    curf+=1
   end
  end
 end
end

function growflag(_x,_y,flg)
 local cand,candnew={{x=_x,y=_y}}
 repeat 
  candnew={}
  for c in all(cand) do
   for d=1,4 do
    local dx,dy=c.x+dirx[d],c.y+diry[d]
    flags[_x][_y]=flg
    if iswalkable(dx,dy) and flags[dx][dy]!=flg then
     flags[dx][dy]=flg
     add(candnew,{x=dx,y=dy})
    end
   end
  end
  cand=candnew
 until #cand==0
end

function carvedoors()
 local x1,y1,x2,y2,found,_f1,_f2=1,1,1,1
 repeat
  local drs={}
  for _x=0,15 do
   for _y=0,15 do
    if not iswalkable(_x,_y) then
     local sig=getsig(_x,_y)
     found=false
     if bcomp(sig,0b11000000,0b00001111) then
      x1,y1,x2,y2,found=_x,_y-1,_x,_y+1,true
     elseif bcomp(sig,0b00110000,0b00001111)then
      x1,y1,x2,y2,found=_x-1,_y,_x+1,_y,true
     end
     _f1=flags[x1][y1]
     _f2=flags[x2][y2]
     if found and _f1!=_f2 then
      add(drs,{x=_x,y=_y,f1=_f1,f2=_f2})
     end
    end
   end
  end
 if #drs>0 then
  local d=getrnd(drs)
  add(doors,d)
  mset(d.x,d.y,1)
  snapshot()
  growflag(d.x,d.y,d.f1)
  del(flaglib,d.f2)
 end
 until #drs==0
end


function carvescuts()
 local x1,y1,x2,y2,cut,found=1,1,1,1,0
 repeat
  local drs={}
  for _x=0,15 do
   for _y=0,15 do
    if not iswalkable(_x,_y) then
     local sig=getsig(_x,_y)
     found=false
     if bcomp(sig,0b11000000,0b00001111) then
      x1,y1,x2,y2,found=_x,_y-1,_x,_y+1,true
     elseif bcomp(sig,0b00110000,0b00001111)then
      x1,y1,x2,y2,found=_x-1,_y,_x+1,_y,true
     end
     if found then
      calcdist(x1,y1)
      if distmap[x2][y2]>20 then
      add(drs,{x=_x,y=_y,})
     end
    end
   end
  end
 end
 if #drs>0 then
  local d=getrnd(drs)
  add(doors,d)
  mset(d.x,d.y,1)
  snapshot()
  cut+=1
 end
 until #drs==0 or cut>=3
end


function fillends()
 local filled,tle
 repeat
  filled=false
  for _x=0,15 do
   for _y=0,15 do
    tle=mget(_x,_y)
    if cancarve(_x,_y,true) and tle!=14 and tle!=15 then
     filled=true
     mset(_x,_y,2)
     snapshot()
    end
   end
  end
 until not filled
end

function isdoor(x,y)
 local sig=getsig(x,y)
 if bcomp(sig,0b11000000,0b00001111) or bcomp(sig,0b00110000,0b00001111)then
  return nexttoroom(x,y)
 end
 return false
end

function nexttoroom(x,y,dirs)
 local dirs = dirs or 4
 for i=1,dirs do
  if inbounds(x+dirx[i],y+diry[i]) and roomap[x+dirx[i]][y+diry[i]]!=0 then 
   return true
  end
 end
 return false
end
function installdoors()
 for d in all(doors) do
  local dx,dy=d.x,d.y
  if (mget(dx,dy)==1 or mget(dx,dy)==4) and isdoor(dx,dy) and not next2tile(dx,dy,13) then
   mset(dx,dy,13)
   snapshot()
  end
 end
end


-------------------------
-- decorations
-------------------------
function startend()
 local high,low,px,py,ex,ey=0,9999
 repeat
  px,py=flr(rnd(16)),flr(rnd(16))
 until iswalkable(px,py)
 calcdist(px,py)
 for x=0,15 do
  for y=0,15 do
   local tmp=distmap[x][y]
   if iswalkable(x,y)and tmp> high then
    px,py=x,y
    high=tmp
   end
  end
 end
 calcdist(px,py)
 high=0
 for x=0,15 do
  for y=0,15 do
   local tmp=distmap[x][y]
   if tmp>high and cancarve(x,y) then
    ex,ey=x,y
    high=tmp
   end
  end
 end
 mset(ex,ey,14)

 debugmap=blankmap(0)
 for x=0,15 do
  for y=0,15 do
   local tmp=distmap[x][y]
   if tmp>=0 then
    local score=starscore(x,y,8)
    tmp=tmp-score
    if tmp<low and score>=0 then
     px,py,low=x,y,tmp
    end
   end
  end
 end
 if roomap[px][py]>0 then
  rooms[roomap[px][py]].nospawn=true
 end
 mset(px,py,15)
 p_mob.x=px
 p_mob.y=py
end

function starscore(x,y)
 if roomap[x][y]==0 then
  if nexttoroom(x,y) then return -1 end
  if freestanding(x,y)>0 then
   return 5
  else
   if cancarve(x,y) then
    return 0
   end
  end
 else
  local scr=freestanding(x,y)
  if scr>0 then
   return scr<=8 and 3 or 0
  end
 end
 return -1
end

function next2tile(_x,_y,tle)
 for i=1,4 do
  if inbounds(_x+dirx[i],_y+diry[i]) and mget(_x+dirx[i],_y+diry[i])==tle then
   return true
  end
 end
 return false
end


function prettywalls()
 for x=0,15 do
  for y=0,15 do
   local tle=mget(x,y)
   if tle==2 then
    local ntle=sigarray(getsig(x,y),wall_sig,wall_msk)
    tle=ntle==0 and 3 or 15+ntle
    mset(x,y,tle)
   elseif tle == 1 then
    if not iswalkable(x,y-1) then
     mset(x,y,4)
    end
   end
  end
 end
end
function decorooms()
 tarr_dirt=explodeval("1,74,75,76")
 tarr_fern=explodeval("1,70,70,70,71,71,71,72,73,74")
 tarr_vase=explodeval("1,1,7,8")
 local funcs,func,rpot={
  deco_dirt,
  deco_torch,
  deco_carpet,
  deco_fern,
  deco_vase
 },deco_vase,{}

 for r in all(rooms) do
  add(rpot,r)
 end

 repeat 
  local r=getrnd(rpot)
  del(rpot,r)
  for x=0,r.w-1 do
   for y=r.h-1,1,-1 do
    if mget(r.x+x,r.y+y)==1 then
     func(r,r.x+x,r.y+y,x,y)
    end
   end
  end
  func=getrnd(funcs)
 until #rpot==0
end

function deco_torch(r,tx,ty,x,y)
 if rnd(3)>1 and y%2==1 and not next2tile(tx,ty,13) then
  if x==0 then
   mset(tx,ty,64)
  elseif x==r.w-1 then
   mset(tx,ty,66)
  end
 end
end
function deco_carpet(r,tx,ty,x,y)
 deco_torch(r,tx,ty,x,y)
 if x>0 and x<r.w-1 and y<r.h-1 then
  mset(tx,ty,68)
 end
end
function deco_dirt(r,tx,ty,x,y)
 mset(tx,ty,getrnd(tarr_dirt))
end
function deco_fern(r,tx,ty,x,y)
 mset(tx,ty,getrnd(tarr_fern))
end
function deco_vase(r,tx,ty,x,y)
 if iswalkable(tx,ty,"checkmobs")
 and not next2tile(tx,ty,13) 
 and not bcomp(getsig(tx,ty),0,0b00001111) then
  mset(tx,ty,getrnd(tarr_vase))
 end
end
function spawnchests()
 local chestdice,rpot,rare,place=explodeval("1,l,2,2,2,3"),{},true
 place=getrnd(chestdice)
 for r in all(rooms) do
  add(rpot,r)
 end
 while place>0 and #rpot >0 do
  local r=getrnd(rpot)
  placechest(r,rare)
  rare=false
  place-=1
  del(rpot,r)
 end
end

function placechest(r,rare)
 local x,y
 repeat
  x=r.x+flr(rnd(r.w-2))+1
  y=r.y+flr(rnd(r.h-2))+1
 until mget(x,y)==1 
 --if rare then
  --mset(x,y,12)
 --else
  --mset(x,y,10)
 --end
 mset(x,y,rare and 12 or 10)
end
function freestanding(x,y)
 return sigarray(getsig(x,y),free_sig,free_msk)
end
__gfx__
00000000000000006606666000000000101100114101444044444000000000004444444000000000000000004444444000444000444444404440004010001110
00000000000000000000000000000000100110014010101004444400044444000444440044444400000000004000004044444440404040400000004010000000
00700700000000006660666000000000000000004104444004444400044444000444440040000400044440004000004044444440404040404444004010011110
00077000000000000000000000000000110011004014444004444400044444000444440044004400444444004400044000000000404040404444004010011110
00077000000000006066606000000000011001104101010004444400004440000044400040000400000000004000004044040440404040400000004010000000
00700700000100000000000000000000000100004044444004444400000400000004000040000400440044004000004044404440404040404444404010111110
00000000000000006660666000000000000000004144444000444440004440000044400044444400444444004444444044444440444444404444404010111110
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000005555550555555000505050005050500050505005500555055555550000055505550000055555550000005500000555055000000
00000000000000000000000055555550555555505555555055555550555555505550555055555550000055505550000055555550000055500000555055500000
00000000000000000000000055550500505055500555555005555550555555005500055005050500000005505500000005050500000005500000055055000000
00000000000000000000000055500000000055505555555055555550555555505550000000000000000000000000000000000000000055500000000055500000
00000500050505000500000055000000000005500555555005555550555555005500055055000550550005505500055000000550050005500505050055000550
00005550555555505550000055500000000055505555555055555550555555505550555055505550555055505550555000005550555055505555555055505550
00000550555555505500000055000000000005500555555005555550555555005500555055505550555055505550555000005550555005505555555055000550
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000550055555005500000055000000000005500505050055505550050505005550555055000550555055505550555055000550555000005500055055555550
00005550555555505550000055500000000055505555555055505550555555505550555055505550555055505550555055505550555000005550555055555550
00000550555555505500000055000000000005500555555055000550555555505500055055000550550005505500055055000550500000005500055005050500
00005550555055505550000055500000000055505555555000000000555555500000000000005550000000000000000055500000000000000000555000000000
00000550555555505500000055550500050555500555555055000550555555500505050055000550000005505500000055000000050505000000055005000000
00005550555555505550000055555550555555505555555055505550505050505555555055505550000055505550000055500000555555500000555055500000
00000550055555005500000005555550555555000505050055505550050505005555555055500550000055505550000055000000555555500000055055500000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000550555555505500000005050500055550000555555005555500555555500000555055500000000055500000000055505550555000001000001088000088
00005500555555505550000055555550505555005555555055555050555555000000555055500000000055500000000055505550555000001100011080000008
00000550050505000500000055555550055550500555555005555500555555500000055055000000000005500000000055000550550000001010101000000000
00000000000000000000000055555550505555005555555055555050555555000000000000000000000000000000000000000000000000001010101000000000
00000000000000000000000055555550055550500555555005555500555555505500000000000550000005505500055000000000550000001010101000000000
00000000000000000000000050505050505555005555555055555550555555505550000000005550000055505550555000000000555000001010101000000000
00000000000000000000000005050500055555500555555005555500050505005550000000005550000055505550555000000000555000001100011080000008
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000001088000088
d000000000000000000000d000000000011111001101111000010000000100000001000000010000000000100000000000000000110111100111111011011110
000000000d0000000000000000000d00110010100000000000111000001010000010100000101000001000100100010000001000000000111666666111000000
dd000000d000000000000dd0000000d0101001101110111000010000011001000111010001110100010000000000000001000000111101666666666616101110
1d0000001d00000000000d1000000d10100100101001001001111100011101000011100000111000001101000010001000000000000016171717676666610000
11000000110000000000011000000110110010101100101000010000001110000111010001110100001100000000011010110100000161767676767661661000
10010000100100000001001000010010101001101010011011111110000100000011100011111110001010000100011000100000001617677777777761666100
10000000100000000000001000000010011111000111110000010000000100000001000000010000000000000000110000000100016171777777777611166610
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000016117777777777611666610
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc00000000000000000000000000000000016176777777777611666610
ccccccccc7cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc00000000000000000000000000000000166767777777771611616661
cccccccc777ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc08000000000000000000000000000000166677777777666111166661
ccccccc777cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc08000000045667004444444007000000166777777766616111616661
7777ccc77ccc77777cc777c77777cccc7777777cc7777cc777777777777777ccccccc77788000000000000000000000045777000166677766666161111161661
cc77cc77ccc7777777cc7c7cc77cccccc7c77777cc77cccc777777cc7c77777cccccc77788000000000000000000000005000000166666616161111161616661
cc77cc77cc7777cc777c7c7cc77cccccc7c7ccc77c77cccc77cccccc7c7ccc77ccccc77788000000000000000000000000000000166661611111111116666761
ccc7777ccc777ccc777c7c7cc77cccccc7c7ccc77c77cccc77c7cccc7c7ccc77ccccc77700000000000000000000000000000000016666111111111616177710
cccc77cccc777ccc777c7c7cc77cccccc7c7ccc77c77ccc77777cccc7c7ccc77ccccc7770000000000000760007007e000000000016111111111111161617610
cccc77cccc777ccc777c7c7cc77cccccc7c7ccc77c77ccc77777cccc7c7ccc77cccccc7c000000000000760000007ec077000770011111111111111616666610
cccc77cccc777ccc777c7c7cc77cccccc7c7ccc77c77cc7c77cccccc7c7ccc77cccccc7c00600000000760007007ec0077777760001661616161616167776100
cccc77ccccc77cc777cc7c7cc77cccccc7c7cc77cc77cccc77cc77cc7c7cc77ccccccccc0056660090760000007ec00077777760000166661616161666761000
ccc777cccccc777777ccc777777ccccc77777777cc77ccc7777777777777777cccccc777445555500960000007ec007007777600000016666161616776610000
cc77777cccccc7777ccc777777ccccccc77777cc77777cc77777777c77777cccccccc777005111009440000004c0000007777600000001666666777776100000
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc00100000440400004000700007666600000000111677676111000000
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc00000000000000000000000000000000000000000111111000000000
777777777c777cc777ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc777777cccccccccccccccc7cc000000005500055065000560
c77c77cc7cc7ccc77777cc77777ccc77cccccc77777ccccccccccccc7ccc777c77cc777ccc77cc777cc77ccc77777ccccccc777c440004406666666056565650
c77c77cc7cc7cc7ccc77cc77cc77c7777ccccc7c7777cccccccccc7777c7777777cc77cccc7cccc77ccc7ccc7c7777cccccc777c444444205555555065656560
c77c77c77cc7c77cccc77c77ccc77c77cccccc7ccc777cccccccc77cc7c7cccc77cc77cccc7cccc77ccc7ccc7ccc77cccccc777c444444200666660006565600
c77c77c77cc7c77cccc77c77ccc77c77cccccc7ccc777cccccccc77cc7c7cccc77cc77cccc7cccc77ccc7ccc7ccc77cccccc777c044442000555550005656500
c77cc7777c77c7ccccc77c77ccc77c77cccccc77ccc77cccccccc77cc7c7ccc777cc77cccc7cccc7777ccccc77ccc77ccccc777c044442000666660006565600
cc7cc777cc77c7cccccc7c77ccc77c77cccccc77cccc7cccccccc777ccc77c7777cc777ccc7cccc777777ccc77cccc7ccccc77cc042222000555550005656500
cc7ccc77cc7cc7cccccc7c77ccc7cc77cccccc77cccc7ccccccccc777ccccc7cc7ccc77ccc7cccc77c777ccc77cccc7cccccc7cc000000000000000000000000
ccc7cc77777c777ccccc7c77cc7ccc77cccccc77cccc7cccccccccc777ccc77cc77cc777cc7cccc77ccccccc77cccc7cccccc7cc770007707700077000000000
ccc7c77777ccc77cccc7cc77777ccc77cccccc7ccccc7ccccccccccc77ccc777777ccc77c7ccccc77cccc7cc7ccccc7cccccc7cc66555660cc777cc000000000
ccc777cc77ccc77cccc7cc77777ccc77ccc7cc7ccccc7cccccccccccc7ccc7ccc77ccc7777ccccc77cccc7cc7ccccc7ccccccccc57757750ee777ee005550000
cccc77cc77cccc77777ccc77cc7ccc77ccc7cc7cccc77ccccccc7cccc77cc7ccc77cccc777ccccc7777c77cc7cccc7ccccccc7cc0565650001e7e10055550000
cccc77cc77cccc77777ccc77cc7ccc77ccc7cc7cccc77ccccccc7cccc77cc7ccc77ccccc77ccccc7777c77cc7cccc7ccccccc7cc065556000ce7ec0055500000
cccc7ccc7cccccc777cccc77ccc7cc77cc77cc7ccc777ccccccc77ccc7cc77cccc7ccccc77cccc77777777cc7ccc77cccccc777c066666000ceeec0000000000
cccccccccccccccc7cccc7777cc7c7777777c777777ccccccccc777c77c7777cc77ccccc7cccccccccccc7c777777ccccccc777c0555550001ccc10000000000
cccccccccccccccccccccccccccc7cccccc7cccccccccccccccc777777cccccccccccccccccccccccccccccccccccccccccccccc000000000000000000000000
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc77777cccccccccccccc77777cccccccccccccccccccccccccc0000000000000750
77777777ccccccc77777ccc777777cc7777ccccc7777cccccccccccc777ccc777777777770cccccc7777777ccccc7777ccccc7777ccccccc0000000000006500
7777777777ccccc777770cc7777770c77770cccc77770ccccccccccc7770cc777777777770cccccc77777770cccc77770cccc77770cccccc0677000000065000
77777777777cccc777770cc7777770c77770cccc77770ccccccc77777770ccc77000007770cccc7770007777cccc77770cccc77770cccccc6565000000650000
c77000077777cccc07700ccc777700cc7700ccccc7700cccccc777777770ccc770ccccc770cccc7700ccc77777ccc7700ccccc7700cccccc555000000f500000
c7770ccc0777ccccc770cccc77770ccc777cccccc770cccccc7700007770ccc770cccccc70ccc7770ccccc77770cc777cccccc770ccccccc00000000f4000000
c7770cccc7777cccc770cccc77770ccc7777ccccc770ccccc7700cccc770ccc7777cccccc0ccc7000cccccc7770cc7777ccccc770ccccccc0000000040000000
c7770cccc77770ccc770cccc77770ccc7777ccccc770ccccc770ccccc770ccc7777cccccccccc70cccccccc7770cc77777cccc770ccccccc0000000000000000
c7770ccccc7770ccc770cccc77770ccc77777cccc770cccc7700cccccc00ccc77777777c7ccc770cccccccc7770cc777777ccc770ccccccc0000000000000000
c7770cccccc777ccc770cccc77770ccc7777777cc770cc77770ccc777777ccc77707777770cc770cccccccc7770cc77777777c770ccccccc0000700000000000
c7770cccccc777077770cccc77770ccc770777777770cc77700cccc777770cc77000077770cc770cccccccc7770cc770777777770ccccccc000667000a000000
c7770cccccc777077770cccc77770ccc770c77777770cc7770ccccc777700cc777ccc00700cc770cccccccc7770cc770c77777770ccccccc000066600a000000
c7770cccccc777077770cccc77770ccc770cc7777770cc7770ccccc77770ccc7770cccc70ccc770cccccccc7770cc770cc7777770ccccccc00060500aa000000
c7770cccccc777077770cccc77770ccc770cc0077770cc7770ccccc77770ccc7700cccc00ccc7777ccccccc7770cc770cccc77770ccccccc00600000aa000000
c7770cccccc770077770cccc77770ccc770ccccc7770cc7777ccccc77770ccc770ccccccc7cc7777ccccccc7000cc770cccccc770ccccccc05000000aa000000
c7770ccccc7770c77770cccc77770ccc770cccccc770cc77770cccc77770ccc770cccccc770c77777ccccc770cccc770cccccc770ccccccc0000000000000000
c7770ccccc7770c77770cccc77770ccc770cccccc770cc77770cccc77770ccc770cccccc770c77777ccccc770cccc770cccccc770ccccccc0000000000000000
c7770ccccc7770c77770ccc777770ccc770cccccc770cc77777cccc77770ccc770ccccc7770cc777777ccc700cccc770cccccc770ccccccc0000000000000000
c7770cccc77700cc0777077777770ccc770cccccc770ccc07777ccc77770cc7777777777770cc07777777770ccccc770cccccc770ccccccc0b00000009000000
7777777777700cccc777777077770cc7777ccccc7770cccc77777ccc7770cc7777777777770ccc007777770ccccc7777ccccc7770ccccccc0b00000009000000
777777777700cccccc07770077777cc77770cccc7777ccccc07777777777ccc000000000070ccccc0000000ccccc77770cccc77770ccccccbb00000099000000
77777777770cccccccc7770c777770c77770cccc77770ccccc77777777770cccccccccccc70ccccccccccccccccc77770cccc77770ccccccbb00000099000000
c0000000000ccccccccc000cc00000cc0000ccccc0000cccccc0000000000ccccccccccccc0cccccccccccccccccc0000ccccc0000ccccccbb00000099000000
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc0000000000000000
00000000000000000000000000000000000000000000000000500500005005000006600000000000000066000000000000000000000000000000000000000000
00000000000000000000000000000000505005050050050000055000000550000006000000066000000060000000660000000000000000000000000000000000
0000000000000000000000000000000050055005000550000005500050055005050000000006000000500000000060000000000000b000000000000000b00000
00000000000000000000000000000000050550500005500000500500055005500066000005000000000660500050005000b0000000b3b00000b0000000b3b000
0000000000000000000000000000000000500500555005550050050000000000000005000066050000000000000660000b30b00000b300000b33b00000b30000
0050000000055000005550000000550000000000050000500050050000000000005500000000000000055000000000000333000000b300000b33000000b30000
55550000055505000050550005555550000000000000000000500500000000000050500000555000000505000005550030003000030300000033000000303000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
de0ed00000de0000de00de00000ed000000c000000000000000c000000000000000f7f0000000000000f7f00000000000077f00007808f0007808400007f4000
1d0d10edde1d0ed01dde1d00de0d1ed0000cc000000c0000000cc0000000c00000f70700000f7f0000f70700000f7f0007ff440007f8f4000778f40007fff400
0d0d0d111d0d0d100d1d0d001d0d0d1000c7cd0000ccc00000c7ccd0000ccc0000ff740000f7070000ff7f0000f707000fafa40007afa40007afa40007afa400
0d0d0d000d0d0d000d0d0d000d0d0d000ccc7000cc7ccd0000cc7d000cc7ccd00fff4f400fff74000fff4f400fff7f0000ff40007f44400000ff400000f444f0
00d0dd000dd0dd0000d0dd000dd0dd000cccd1000cc7d0000cccc10000cc7d000fff4f400ff4f4f00fff4f400ff4ff40070f0400f40404000f0404000f040440
0d1d1d0001dd1d000dddd10001dd1d0000c110000c1d100000c1dc0000c1d1000ff44f400f4ff4f00ff4ff400f44ff40700f004004040040f0000040f0000040
d10d0dd0d01d0d000101d0d0d01d0d0000c0d100c10110000c1001000c1011000f40f440f40f44000044f400f400f44044040440000404404400044044000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc0000000000000000
00000000000000000000000000000000cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc0000000000000000
00000000000000000000000000000000cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc0200000007000000
00000000000000000000000000000000cccc77777ccc77777ccccc77777cccc77777ccccccc77cccc77cccc77cccc7777ccc77ccc77cc77c0200000007000000
00000000000000000000000000000000ccc77cccccc77ccc77ccc77ccc77ccc77cc77cccccc77cccc77cccc77ccc77cccccc77cc77ccc77c2200000077000000
00000000000000000000000000000000cc77cccccc77ccccc77c77ccccc77cc77ccc77ccccc77cccc77cccc77cc77ccccccc77c77cccc77c2200000077000000
00000000000000000000000000000000c77cccccc77cccccc7777cccccc77cc7cccc77ccccc77cccc77cccc77c77cccccccc7777ccccc7cc2200000077000000
00000000000000000000000000000000c77cccccc77cccccc7777cccccc77cc7cccc77ccccc7ccccc77cccc77c77cccccccc777cccccc7cc0000000000000000
00770000000000000007700000000000c77cccc7777cccccc7777cccccc77cc7cccc77ccccc7ccccc77cccc77c77cccccccc7c77cccccccc0000000070000000
00700000000770000007000000077000c77cccc7777cccccc7777cccccc77c77cccc77cccc77ccccc77cccc7cc77ccccccc77cc77ccccccc0000000077000000
00070000000700000000700000070000c77cccc7777ccccc77c77ccccc77cc77ccc77ccccc77ccccc77cccc7cc77ccccccc77cc77ccc77cc0500000077700000
00700000007070000000000000007000cc77ccc77c77ccc77ccc77ccc77ccc77cc77cccccc77ccccc77ccc77ccc77cccccc77ccc77cc77cc0500000077000000
07077000070707000077770000770000ccc777777cc77777ccccc77777cccc77777ccccccc777777cc7777cccccc77777cc77ccc77cc77cc5500000070000000
00070000007700000707000007077700cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc5500000000000000
00070000007070000007000000707000cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc5500000000000000
00000000000000000000000000000000cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc0000000000000000
__label__
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888ffffff882222228888888888888888888888888888888888888888888888888888888888888888228228888ff88ff888222822888888822888888228888
88888f8888f882888828888888888888888888888888888888888888888888888888888888888888882288822888ffffff888222822888882282888888222888
88888ffffff882888828888888888888888888888888888888888888888888888888888888888888882288822888f8ff8f888222888888228882888888288888
88888888888882888828888888888888888888888888888888888888888888888888888888888888882288822888ffffff888888222888228882888822288888
88888f8f8f88828888288888888888888888888888888888888888888888888888888888888888888822888228888ffff8888228222888882282888222288888
888888f8f8f8822222288888888888888888888888888888888888888888888888888888888888888882282288888f88f8888228222888888822888222888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555550000000000000000000000000000000000000000000000000000000000000000005555550000000000000000000000000000000000000000005555555
55555550777777770000000000000000000000000000000000000000000000000000000005555550000000000011111111112222222222333333333305555555
55555550777777770000000000000000000000000000000000000000000000000000000005555550000000000011111111112222222222333333333305555555
55555550777777770000000000000000000000000000000000000000000000000000000005555550000000000011111111112222222222333333333305555555
55555550777777770000000000000000000000000000000000000000000000000000000005555550000000000011111111112222222222333333333305555555
55555550777777770000000000000000000000000000000000000000000000000000000005555550000000000011111111112222222222333333333305555555
55555550777777770000000000000000000000000000000000000000000000000000000005555550000000000011111111112222222222333333333305555555
55555550777777770000000000000000000000000000000000000000000000000000000005555550000000000011111111112222222222333333333305555555
55555550777777770000000000000000000000000000000000000000000000000000000005555550000000000011111111112222222222333333333305555555
55555550777777777777777700000000000000000000000000000000000000000000000005555550000000000011111111112222222222333333333305555555
55555550777777777777777700000000000000000000000000000000000000000000000005555550444444444455555555556666666666777777777705555555
55555550777777777777777700000000000000000000000000000000000000000000000005555550444444444455555555556666666666777777777705555555
55555550777777777777777700000000000000000000000000000000000000000000000005555550444444444455555555556666666666777777777705555555
55555550777777777777777700000000000000000000000000000000000000000000000005555550444444444455555555556666666666777777777705555555
55555550777777777777777700000000000000000000000000000000000000000000000005555550444444444455555555556666666666777777777705555555
55555550777777777777777700000000000000000000000000000000000000000000000005555550444444444455555555556666666666777777777705555555
55555550777777777777777700000000000000000000000000000000000000000000000005555550444444444455555555556666666666777777777705555555
55555550777777777777777777777777000000000000000000000000000000000000000005555550444444444455555555556666666666777777777705555555
55555550777777777777777777777777000000000000000000000000000000000000000005555557777777777775555555556666666666777777777705555555
5555555077777777777777777777777700000000000000000000000000000000000000000555555700000000007999999999aaaaaaaaaabbbbbbbbbb05555555
5555555077777777777777777777777700000000000000000000000000000000000000000555555708888888807999999999aaaaaaaaaabbbbbbbbbb05555555
5555555077777777777777777777777700000000000000000000000000000000000000000555555708888888807999999999aaaaaaaaaabbbbbbbbbb05555555
5555555077777777777777777777777700000000000000000000000000000000000000000555555708888888807999999999aaaaaaaaaabbbbbbbbbb05555555
5555555077777777777777777777777700000000000000000000000000000000000000000555555708888888807999999999aaaaaaaaaabbbbbbbbbb05555555
5555555077777777777777777777777700000000000000000000000000000000000000000555555708888888807999999999aaaaaaaaaabbbbbbbbbb05555555
5555555077777777777777770000000000000000000000000000000000000000000000000555555708888888807999999999aaaaaaaaaabbbbbbbbbb05555555
5555555077777777777777770000000000000000000000000000000000000000000000000555555708888888807999999999aaaaaaaaaabbbbbbbbbb05555555
5555555077777777777777770000000000000000000000000000000000000000000000000555555700000000007999999999aaaaaaaaaabbbbbbbbbb05555555
5555555077777777777777770000000000000000000000000000000000000000000000000555555777777777777dddddddddeeeeeeeeeeffffffffff05555555
55555550777777777777777700000000000000000000000000000000000000000000000005555550ccccccccccddddddddddeeeeeeeeeeffffffffff05555555
55555550777777777777777700000000000000000000000000000000000000000000000005555550ccccccccccddddddddddeeeeeeeeeeffffffffff05555555
55555550777777777777777700000000000000000000000000000000000000000000000005555550ccccccccccddddddddddeeeeeeeeeeffffffffff05555555
55555550777777777777777700000000000000000000000000000000000000000000000005555550ccccccccccddddddddddeeeeeeeeeeffffffffff05555555
55555550777777770000000000000000000000000000000000000000000000000000000005555550ccccccccccddddddddddeeeeeeeeeeffffffffff05555555
55555550777777770000000000000000000000000000000000000000000000000000000005555550ccccccccccddddddddddeeeeeeeeeeffffffffff05555555
55555550777777770000000000000000000000000000000000000000000000000000000005555550ccccccccccddddddddddeeeeeeeeeeffffffffff05555555
55555550777777770000000000000000000000000000000000000000000000000000000005555550ccccccccccddddddddddeeeeeeeeeeffffffffff05555555
55555550777777770000000000000000000000000000000000000000000000000000000005555550000000000000000000000000000000000000000005555555
55555550777777770000000000000000000000000000000000000000000000000000000005555555555555555555555555555555555555555555555555555555
55555550777777770000000000000000000000000000000000000000000000000000000005555555555555555555555555555555555555555555555555555555
55555550777777770000000000000000000000000000000000000000000000000000000005555555555555555555555555555555555555555555555555555555
55555550000000000000000000000000000000000000000000000000000000000000000005555550000000555556667655555555555555555555555555555555
55555550000000000000000000000000000000000000000000000000000000000000000005555550000000555555666555555555555555555555555555555555
5555555000000000000000000000000000000000000000000000000000000000000000000555555000000055555556dddddddddddddddddddddddd5555555555
555555500000000000000000000000000000000000000000000000000000000000000000055555500080005555555655555555555555555555555d5555555555
55555550000000000000000000000000000000000000000000000000000000000000000005555550000000555555576666666d6666666d666666655555555555
55555550000000000000000000000000000000000000000000000000000000000000000005555550000000555555555555555555555555555555555555555555
55555550000000000000000000000000000000000000000000000000000000000000000005555550000000555555555555555555555555555555555555555555
55555550000000000000000000000000000000000000000000000000000000000000000005555555555555555555555555555555555555555555555555555555
55555550000000000000000000000000000000000000000000000000000000000000000005555555555555555555555555555555555555555555555555555555
55555550000000000000000000000000000000000000000000000000000000000000000005555556665666555556667655555555555555555555555555555555
55555550000000000000000000000000000000000000000000000000000000000000000005555556555556555555666555555555555555555555555555555555
5555555000000000000000000000000000000000000000000000000000000000000000000555555555555555555556dddddddddddddddddddddddd5555555555
555555500000000000000000000000000000000000000000000000000000000000000000055555565555565555555655555555555555555555555d5555555555
55555550000000000000000000000000000000000000000000000000000000000000000005555556665666555555576666666d6666666d666666655555555555
55555550000000000000000000000000000000000000000000000000000000000000000005555555555555555555555555555555555555555555555555555555
55555550000000000000000000000000000000000000000000000000000000000000000005555555555555555555555555555555555555555555555555555555
55555550000000000000000000000000000000000000000000000000000000000000000005555555555555555555555555555555555555555555555555555555
55555550000000000000000000000000000000000000000000000000000000000000000005555555555555555555555555555555555555555555555555555555
55555550000000000000000000000000000000000000000000000000000000000000000005555550005550005550005550005550005550005550005550005555
555555500000000000000000000000000000000000000000000000000000000000000000055555011d05011d05011d05011d05011d05011d05011d05011d0555
55555550000000000000000000000000000000000000000000000000000000000000000005555501110501110501110501110501110501110501110501110555
55555550000000000000000000000000000000000000000000000000000000000000000005555501110501110501110501110501110501110501110501110555
55555550000000000000000000000000000000000000000000000000000000000000000005555550005550005550005550005550005550005550005550005555
55555550000000000000000000000000000000000000000000000000000000000000000005555555555555555555555555555555555555555555555555555555
55555550000000000000000000000000000000000000000000000000000000000000000005555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555557000000055555555555555555555555555555555555555555555555555
55555555555555555555555557555555ddd5555d5d5d5d5555d5d55555555d555555557700000056666666666666555555555555555555555555555557777755
55555555555555555555555577755555ddd555555555555555d5d5d5555555d55555557770000056ddd6ddd6ddd6555556666655566666555666665577eee775
55555555555555555555555777775555ddd5555d55555d5555d5d5d55555555d555555770000005666d6d666d666555566ddd66566dd666566ddd665777ee775
55555555555555555555557777755555ddd555555555555555ddddd555ddddddd555557000000056ddd6ddd6ddd6555566d6d665666d66656666d6657777e775
555555555555555555555757775555ddddddd55d55555d55d5ddddd55d5ddddd5555550000000056d66666d666d6555566d6d665666d666566d6666577eee775
555555555555555555555755755555d55555d555555555555dddddd55d55ddd55555550000000056ddd6ddd6ddd6555566ddd66566ddd66566ddd66577777775
555555555555555555555777555555ddddddd55d5d5d5d55555ddd555d555d555555550000000056666666666666555566666665666666656666666577777775
555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555ddddddd5ddddddd5ddddddd5eeeeeee5
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000500500005005000006600000000000000066000000000000000000000000000000000000000000
00000000000000000000000000000000505005050050050000055000000550000006000000066000000060000000660000000000000000000000000000000000
0000000000000000000000000000000050055005000550000005500050055005050000000006000000500000000060000000000000b000000000000000b00000
00000000000000000000000000000000050550500005500000500500055005500066000005000000000660500050005000b0000000b3b00000b0000000b3b000
0000000000000000000000000000000000500500555005550050050000000000000005000066050000000000000660000b30b00000b300000b33b00000b30000
0050000000055000005550000000550000000000050000500050050000000000005500000000000000055000000000000333000000b300000b33000000b30000
55550000055505000050550005555550000000000000000000500500000000000050500000555000000505000005550030003000030300000133000000303000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001710000000000000
de0ed00000de0000de00de00000ed000000c000000000000000c000000000000000f7f0000000000000f7f00000000000077f00007808f0017718400007f4000
1d0d10edde1d0ed01dde1d00de0d1ed0000cc000000c0000000cc0000000c00000f70700000f7f0000f70700000f7f0007ff440007f8f4001777140007fff400
0d0d0d111d0d0d100d1d0d001d0d0d1000c7cd0000ccc00000c7ccd0000ccc0000ff740000f7070000ff7f0000f707000fafa40007afa4001777710007afa400
0d0d0d000d0d0d000d0d0d000d0d0d000ccc7000cc7ccd0000cc7d000cc7ccd00fff4f400fff74000fff4f400fff7f0000ff40007f4440001771100000f444f0
00d0dd000dd0dd0000d0dd000dd0dd000cccd1000cc7d0000cccc10000cc7d000fff4f400ff4f4f00fff4f400ff4ff40070f0400f4040400011714000f040440
0d1d1d0001dd1d000dddd10001dd1d0000c110000c1d100000c1dc0000c1d1000ff44f400f4ff4f00ff4ff400f44ff40700f004004040040f0000040f0000040
d10d0dd0d01d0d000101d0d0d01d0d0000c0d100c10110000c1001000c1011000f40f440f40f44000044f400f400f44044040440000404404400044044000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc0000000000000000
00000000000000000000000000000000cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc0000000000000000
00000000000000000000000000000000cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc0200000007000000
00000000000000000000000000000000cccc77777ccc77777ccccc77777cccc77777ccccccc77cccc77cccc77cccc7777ccc77ccc77cc77c0200000007000000
00000000000000000000000000000000ccc77cccccc77ccc77ccc77ccc77ccc77cc77cccccc77cccc77cccc77ccc77cccccc77cc77ccc77c2200000077000000
00000000000000000000000000000000cc77cccccc77ccccc77c77ccccc77cc77ccc77ccccc77cccc77cccc77cc77ccccccc77c77cccc77c2200000077000000
00000000000000000000000000000000c77cccccc77cccccc7777cccccc77cc7cccc77ccccc77cccc77cccc77c77cccccccc7777ccccc7cc2200000000000000
00000000000000000000000000000000c77cccccc77cccccc7777cccccc77cc7cccc77ccccc7ccccc77cccc77c77cccccccc777cccccc7cc0000000777777777
00770000000000000007700000000000c77cccc7777cccccc7777cccccc77cc7cccc77ccccc7ccccc77cccc77c77cccccccc7c77cccccccc0000000770000000
00700000000770000007000000077000c77cccc7777cccccc7777cccccc77c77cccc77cccc77ccccc77cccc7cc77ccccccc77cc77ccccccc0000000777000000
00070000000700000000700000070000c77cccc7777ccccc77c77ccccc77cc77ccc77ccccc77ccccc77cccc7cc77ccccccc77cc77ccc77cc0500000777700000
00700000007070000000000000007000cc77ccc77c77ccc77ccc77ccc77ccc77cc77cccccc77ccccc77ccc77ccc77cccccc77ccc77cc77cc0500000777000000
07077000070707000077770000770000ccc777777cc77777ccccc77777cccc77777ccccccc777777cc7777cccccc77777cc77ccc77cc77cc5500000770000000
00070000007700000707000007077700cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc5500000700000000
00070000007070000007000000707000cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc5500000700000000
00000000000000000000000000000000cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc0000000700000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000777777777
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888

__gff__
0000050500020b0b0b090b090b07020005050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505000000000000000004040404000000000000000000000000000000020b0b0b0000000000000000000000000b0b0b0b000300000000000000000000000000000b0b0b
000000000000000000000000000b0b0b00000000000000000000000000000b0b00000000000000000000000000000b020000000000000000000000000000020200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000020b00000000000000000000000000000200
__map__
0202020202020202020202010202020203030303030303030303030303030303000000000000000000000000000000000202020202020202020202020202020210111111111111111111111111111112000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
02010201010201010101010101010e0203030303030303030303030303030303000000000000000000000000000000000202020202020202020202020202020220000000000000000000000000000022000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
02010201010601020a0101010201010203030303030310111203030303030303000000000010111111111112000000000202020202020202020202020202020220000000000000000000000000000022000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
02010201010101020101020d020d0202030303031011240e2311120303030303000000000020044d4e4f0422000000000202020202020202020202020202020220000000000000000000000000000022000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010101010102c002020102010102030303032044444444441f1111120303000000000020015d5e5f0122000000000202020202020202020202020202020220000000000000000000000000000022000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0201010101010101020202020202060203030303200144444444444405220303000000000020406d6e6f4222000000000202020202020202020202020202020220000000000000000000000000000022000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
020f010101010101010101010101c002030303032001014401012c3131320303000000000020014444440122000000000202020202020202020202020202020220000000000000000000000000000022000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
020202020d020d0202020202020d020203031011240801060108231112030303000000000020404444444222000000000202020202020202020202020202020220000000000000000000000000000022000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
02c0010d01010101020101010101010203032007070101440101070722030303000000000020014444440122000000000202020202020202020202020202020220000000000000000000000000000022000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0201010201010101020107070701010203032007070101440101070722030303000000000020404444444222000000000202020202020202020202020202020220000000000000000000000000000022000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
020c010201010601020801c0c001070203033031144001440142133132030303000000000030140144011332000000000202020202020202020202020202020220000000000000000000000000000022000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0201010201010101020101c008c0070203030303200101440101220303030303000000000000200144012200000000000202020202020202020202020202020220000000000000000000000000000022000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0201010d010101010d0101080807080203030303200101440101220303030303000000000000204044422200000000000202020202020202020202020202020220000000000000000000000000000022000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
02020202020202020202020202020202030303033031140f1331320303030303000000000000200101012200000000000202020202020202020202020202020220000000000000000000000000000022000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
020202020202020202020202020202020303030303033031320303030303030300000000000030140f133200000000000202020202020202020202020202020220000000000000000000000000000022000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0202020202020202020202020202020203030303030303030303030303030303000000000000003031320000000000000202020202020202020202020202020230313131313131313131313131313132000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
010c00000057302000020000200000000005030200000503020000000000000000000054301000010000000000573000000000000000010000000000000000000100000000000000000000000000000000000000
010c00000015400141001310011100111001110011500100035000710003500035000350003500035000350008154081410813108121081110811108115065000710007500075000750007500075000750007500
010c0000071540714107131071210711107111071150f7001370013700137001370013700137001370003100031410313103121031110311103111031150e7000c7000c7000c7000c7000c7000c7000c7000c700
010c00000017400161001510014100121001110011100100220002200021000210001d0001d0001500015000140001400014000140001400014000140000d000100000c0000d0001000014000150001400010000
010c0000077140772107721077210772107711077110771107711077150a7000a1000a1000a1000a100021000a7110a7210a7210a7210a7210a7110a7110a7110a7110a715001000010005100000000000000000
010c0000227142272122721227212272122711227112271122711227151f2001f2001f2001f2001f20011500217142172121721217212172121711217112171121711217151c5001d50020500205001050011500
010c00000f7140f7210f7210f7210f7210f7210f7210f7210f7110f7110f7110f7110f7110f7110f7110f7110f2000f2000f2000f2000f2000f2000f2000f2001950020500205001c5001d500205002050010500
010c0000137141372113721137211372113721137211372113721137211372113711137111371513200260002500025000250002500018000000000000000000100000d00011000140001500014000190001d000
010c00001871418721187211872118721187211872118721187111871118711187111871118711187111871118200182001820018200182001820018200182000310000100001000010003100000000000000000
010c00000015400141001310011100111001110011500000001000a1000a1000a1000a1000a1000a1000a10000100001000a100001000a1000010004100001000a100001000910000100041000c1000910000100
011600000051400511005210052100521005110051100515215002150022500215001f5001f5000e500135000f2000f2000f2000f2000f2000f2000f2000f2000f2000f2000f2000f2000f2000f2000f2000f200
0116000008514085110852108521085210851108511085152150022500215001f50021500215000d50010500212002120021200212002120021200212000f200212002120021200212002120021200212000f200
0116000003514035210352103521035210352103521035251f500215002150022500215001f5001f5000e50013500225001f5001b5001f500225001f5001b5001f500215002150022500215001f5001f5000f500
0116000007514075210752107521075210752107521075251d5002150022500215001f50021500215000d50010500205001d5001a50016500205001d5001a5002050020500205001d500205001f5001d5001c500
01160000021740216102151021410212102111021111a00022000220001f0001f00019000190001a0001a0001f0001f0001f0001f00018000000000000000000000000f000130001600015000160001500013000
011600000b5240b5210b5310b5310b5310b5210b5210b525220002200021000210001c0001c0001d0001d00020000200002000020000110001a0001d000220002600026000280002600025000250002500025000
011800000c0250e0250f02513025140251300014000130001300014000137251472513725127250f7250e72501100080001000001000011000800010000001000110000100001000010001100100001000000000
011800001412513125141251312514125110000210002100000000210014725157251472513725127250c0001400005000051000c000140000010005100001000010000100051001400014000000000000000000
011600000072000720007200072000720007201610002100071000000002100000000710016000160000710003100160001300003000031001600013000001000310000100001000010003100160001600000000
0116000000120001200012000120001200012011000021000910000000021000000009100100000d000091000a10010000110000a0000a1001000011000001000a10000100001000010009100150000d00009000
011800000c1250e1250f125141251312511700117000e7000e1250812505125001250212502200022000e10001200010001a6001a70001200012001a3001a2001070014700147001070010500155001550014500
0118000013725137251320011200102000e2000f20011700157251a72511500115000e10005200050001a6001a70001200012001a3001a2001170014700147001170011500195001950018500000000000000000
01180000111250f1250d1250c1250b125117000e700137000012000120001200012000120001201310003200030001a6001a70001200012001a3001a2001370016700167000d7000f50016500165001350000000
011800001b725147250f200122051320511700117000e70008720087200872008720087200872016500157000a2000a0001a6001a70001200012001a3001a2000e70010700117000e7000d5000e5001150010500
011800001d7201d7201d7201d7201c7201c7201c7201c7201a7201a7201a7201a72019720197201972019720150001400014000140001400018000000000000000000100000c0000d00010000140001500014000
011800001a7201a7201a7201a720197201972019720197201672016720167201672015720157201572015720260002500019000190001900018000000000000000000000000d0001100014000150001400019000
01180000187201872018720187201872018720187201a0001a00022000220001f0001f00019000190001a0001a0001f0001f000130001300018000000000000000000000000f0001300016000150001600015000
011800000e1251012511125151251a12521000210001c000091250c12510125181251c1250c1001c0001d0000c1000c10010100181001c1001d0001a000220002900029000260002800028000280002800028000
011800001572517725117000e700097000e70011700027001572518725117000e700097000e7001170002700087000d700107000d700087000d7001070001700047000d700107000d700087000d7001070001700
01180000081250b1250c12513125141250e700117000e7000b7200b7200b7200b7200b7200b720117000e700001000010000100001000010000100117000d700117000d700117000d700087000d700117000d700
011800001072514725137000e7000a7000e700137000e7000872008720087200872008720087200f700137000f7000a7000f700137000f700137000f700137000f7000a7000f700137000f700000000000000000
0118000011720117201172011720117201172011720117251070009700107000970010700097001070009700117000e700117000e700117000e700117000e700117000e700117000e700097000d700107000d700
001800000972009720097200972009720097200972009725000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001800000e7200e7200e7200e7200e7200e7200e7200e725000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
011800000c3250e30010300113251332515300133000c2000c3251c2001c20013325113251c2001c2001c2000c3100c31507310073150c3100c31507310073150c3100c3100c3100c3100c3100c3100c3100c315
001800001032510200102000c3250e3251020010200102001332500000000000c3250e32500000000000000010720107250e0200e02510020100250e0200e0251302013020130201302013020130201302013025
0118000018735177351573517735137351173510735117351373511735107350e73511735107350e7350c73513730137301373013735157301573015730157351073010730107301073510730107301073010735
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0113000029700297002670026700257002570022700227000000026700217000e7000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
011300000250011500165001550016500115000d5000a5000e5000e5000e5000e5001400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
011800000c0000e0000f00013000140001300014000130001300014000130001400013000110000f0000e00025700197021970219702000000000000000000000000000000000000000000000000000000000000
011800001d1530c153055000450002500005000050000100011000c50010500035000050008500021000850007500000001050007500085000f50005500075000650003500005000050000500005000000000000
011800000c7000c7000c7000e7000e7000e7000c7410c7310c7210c7150c7000c7000e7440e7310f7240f7110f7110f7110f7000f7000f7000f7000b7410b7310b7210b7210b7210b7110b7150b7001170000000
011800000f7000f7000f7000f70011700117000014100131001210011518100181000214402131031240311103111031111610016100020001310002141021310212102121021210211102115161001610016100
011200001b0001f0002200023000220001f0002000022000230002700023000200001f000200001f0001b0001f00022000200002200023000270001d000200001f0001f0001f0001f00000000000000000000000
011200001f5001f5001b5001b50022500225002350023500225002250020500205001f5001f500205002050022500225002350023500255002550023500235002250022500225002250000000000000000000000
00040000065500653007520085200b5200f5100f5000800008000170000b0000b0000a0000a0000a0000f00003000030000800008000080001100005000050000300003000030000300003000030000300000000
011200001e0001e0001e000210001a0001e0001f0001f0001f0001f0001e0001e0001f0001f000210002100022000220002900029000290002900028000280002600026000260002600000000000000000000000
011200001a7001a70015500155001a5001a5001c5001c5001c5001a500155001550016500165001a5001a5001f5001f50022500225002250022500215001f5001e5001e5001e5001e50000000000000000000000
0103000017730147330e73306733027430374305753097530e7531760317603176031760317603176031760317603176031760317603176031760317603176031760317603176031760317603176031760317603
000300001852118525115001f5211f5250c500245212452511505235212352511500265212652513505275251f00522505235251f0052b5052b52523005240053352524005305052f52528005280053752137525
012d0000307131a5001b5001d5001d5001e5001d5001c5001b5001a5001a50019500185001650016500145001350011500105000e5000d5000c5000b5000a5000850004500015000050004500025000050000500
000100001c0101e0201d0201b02017010140100f0100a010050100001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000100000a0200e0200b03009040080400a040110301a0201b0101b00011000080000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
01080000005550355505555075550655516100161011610515104151011510115101151011510115101151050f1040f1010f1010f1010f1010f1010f1010f1050e1040e1010e1010e1010e1010e1010e1010e105
000100001012014120191100150001500015000150000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0001000007610086300c5500e5400f5400f5300e5200c5100a51007520055200e6000c60008600056000160000600016000000000000000000000000000000000000000000000000000000000000000000000000
01020000194231842316423134130d4130a4130641301000005000030000300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000100000463004630086000b60008010070400660002600036300262002600026000050000600016000060004600196001a6001b6001c6001b6001b6001b6000360007600036000460001600026000160000500
010c0000122250c2150f2002530000100001000010000100001000a0000a0000a0000a0000a200002000020000000000000000000000000000000000000000000000000000000000000000000000000000000000
010600000b7000b7000b7000b70030725201001d100377251e7001e7001e7001e70030700201001d100377001f10021100187001c7001d7001f70021700237002470023700217000000000000000000000000000
0003000019711167110d71107731047310372105711097110c72110721157211a7211f72125721257101a70010700187000000000000000000000000000000000000000000000000000000000000000000000000
010100000253206532086220040031200312000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__music__
03 00424344
00 00014243
00 00020347
00 00035a4e
01 0003424f
00 00014243
00 00480347
00 00424c4e
00 004b4d4f
00 00014344
00 00020708
00 00040502
00 00060108
00 00010244
00 00095d44
00 00090245
00 00080907
00 00060701
00 000a0b03
00 000c0d02
00 000f0b0e
00 00106744
00 000f1011
00 00121344
00 00717244
00 00141556
00 00161744
00 001b1c44
00 001d1e44
00 00181944
00 001f2021
02 001a0344
04 22232444
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
04 2a2b2c72
00 1c424344
00 2a2b4344

