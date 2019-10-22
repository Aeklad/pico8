pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
--help!!
function _init()
 t=0
 dpal=explodeval("0,1,1,2,1,13,6,4,4,9,3,13,1,13,14")
 dirx=explodeval("-1,1,0,0,1,1,-1,-1")
 diry=explodeval("0,0,-1,1,-1,1,1,-1")
 itm_name=explode("dagger,staff,short sword,broad sword,bastard sword,vorpal sword,cloth armor,leather armor,scale mail,chain mail,plate armor,magic plate,food 1,food 2,food 3,food 4,food 5,food 6,small rock,polished stone,balanced knife,throwing axe")
 itm_type=explode("wep,wep,wep,wep,wep,wep,arm,arm,arm,arm,arm,arm,fud,fud,fud,fud,fud,fud,thr,thr,thr,thr")
 itm_stat1=explodeval("1,2,3,4,5,6,0,0,0,0,1,2,1,2,3,4,5,6,1,2,3,4")
 itm_stat2=explodeval("0,0,0,0,0,0,1,2,3,4,3,3,1,1,1,1,1,1,0,0,0,0")
 itm_minf=explodeval("1,2,3,4,5,6,1,2,3,4,5,6,1,1,1,1,1,1,1,2,3,4")
 itm_maxf=explodeval("3,4,5,6,7,8,3,4,5,6,7,8,8,8,8,8,8,8,4,6,7,8")
 itm_desc=explode(",,,,,,,,,,,, heals, heals a lot, increases hp, stuns, is cursed, is blessed,,,,")
 mob_name=explode("player,slime,giant bat,skeleton,goblin,hydra,troll,cyclops,zorn")
 mob_ani=explodeval("240,192,196,200,204,208,212,216,220")
 mob_hp=explodeval("5,1,2,3,3,4,5,14,8")
 mob_los=explodeval("4,4,4,4,4,4,4,4,4")
 mob_atk=explodeval("1,1,2,1,2,3,3,5,5")
 mob_minf=explodeval("1,1,2,3,4,5,6,7,8")
 mob_maxf=explodeval("1,3,4,5,6,7,8,8,8")
 mob_spec=explode(",,,divdes,steals food,stun,ghost,slow,sleep")
 crv_sig=explodeval("255,214,124,179,233")
 crv_msk=explodeval("0,9,3,12,6")
 
 wall_sig=explodeval("251,233,253,84,146,80,16,144,112,208,241,248,210,177,225,120,179,0,124,104,161,64,240,128,224,176,242,244,116,232,178,212,247,214,254,192,48,96,32,160,245,250,243,249,246,252")
 
 wall_msk=explodeval("0,6,0,11,13,11,15,13,3,9,0,0,9,12,6,3,12,15,3,7,14,15,0,15,6,12,0,0,3,6,12,9,0,9,0,15,15,7,15,14,0,0,0,0,0,0")

 debug={}
 startgame()
end

function _update60()
 t+=1
 _upd()
 dofloats()
 dohpwind()
end

function _draw()
 _drw()
 drawind()
 drawlogo() 
 --fadeperc=0
 checkfade()
 cursor(4,4)
 color(8)
 for txt in all(debug) do
  print(txt)
 end
end

function startgame()
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

 p_t=0
 inv,eqp={},{}
 makeipool()
 foodnames()
 takeitem(17)
 takeitem(18)
 wind={}
 float={}
 talkwind = nil
 hpwind=addwind(5,5,28,13,{})
 thrdx,thrdy=0,-1
 _upd=update_game
 _drw=draw_game
 st_steps,st_kills,st_meals,st_killer=0,0,0,""
 genfloor(0)
end
-->8
--updates tab 1

function update_game()
 if talkwind then
  if getbutt()==5 then
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
 move_mnu(curwind)
 if btnp(4) then
  if curwind==invwind then
   _upd=update_game
   invwind.dur=0
   statwind.dur=0
  elseif curwind==usewind then
   curwind.dur=0
   curwind=invwind
  end
 elseif btnp(5) then
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
 if btnp(2) then
  wnd.cur-=1
 elseif btnp(3) then
  wnd.cur+=1
 end
 wnd.cur=(wnd.cur-1)%#wnd.txt+1
end

function update_pturn()

 dobuttbuff() 
 p_t=min(p_t+.125,1)
 if p_mob.mov then
  p_mob:mov()
 end

 if p_t==1 then
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
   if p_mob.stun then
    p_mob.stun=false
    doai()
   end
  end
 end
end

function update_gover()
 if btn(❎) then
  fadeout()
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
  showinv()
 elseif butt==4 then
  genfloor(floor+1)
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
  if sin(time()*8)>0 then
   drawmob(m)
  end
  m.dur -=1
  if m.dur<=0 then
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
 
-- for x=0,15 do
--  for y=0,15 do
--    print(roomap[x][y],x*8,y*8,8)
--  end
-- end

 for f in all(float) do
  oprint8(f.txt,f.x,f.y,f.c,0)
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
  spr(144,7,logo_y,14,3)
  palt()
  oprint8("shepherds of the deep",19,logo_y+20,7,0)
 end
end

function drawmob(m)
  local col=7
  if m.flash>0 then
   m.flash-=1
   col=4
  end
  draw_spr(get_frame(m.ani),m.x*8+m.ox,m.y*8+m.oy,col,m.flp)	
end
--function draw_gover()
-- cls(2)
-- print("u dead",50,50,7)
--end
--
--function draw_win()
-- cls(2)
-- print("u win",50,50,7)
--end

function draw_gover()
 cls()
 palt(12,true)
 spr(gover_spr,gover_x,30,gover_w,2)
 if not win then
  print("killed by a "..st_killer,28,43,6)
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

function get_frame(_ani)
	return _ani[flr(t/15)%#_ani+1]
end

function draw_spr(_spr,_x,_y,_c,_flip)
 pal(7,_c)
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
 return arr[1+flr(rnd(#arr))]
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
   sfx(58)
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
 if tle==7 or tle==8 then
  --vase
  sfx(59)
  mset(destx,desty,76)
  if rnd(3)<1 and floor>0 then
   if rnd(5)<1 then
    addmob(getrnd(mobpool),destx,desty)
   else
    if freeinvslot()==0 then
     showmsg("inventory full",120)
    else
     local itm=getrnd(fipool_com)
     takeitem(itm)
     showmsg(itm_name[itm].."!",60)
    end
   end
  end
 elseif tle==10 or tle==12 then
  --chest
  if freeinvslot()==0 then
   showmsg("inventory full",120)
   skipai=true
  else
   local itm=getrnd(fipool_com)
   if tle==12 then
    itm=getitm_rar()
   end

   sfx(61)
   mset(destx,desty,tle-1)
   takeitem(itm)
   showmsg(itm_name[itm].."!",60)
  end
 elseif tle==13 then
  --door
  sfx(62)
  mset(destx,desty,1)
 elseif tle==6 then
  --stone tablet
  if floor==0 then
   showtalk({" welcom to gip! "," please be careful "," it's super dangerous "," "})
  end
 elseif tle==110 then
  win=true
 end
end

function trig_step()
 local tle=mget(p_mob.x,p_mob.y)
 if tle==14 then 
  p_mob.bless=0
  fadeout()
  genfloor(floor+1)
  floormsg()
  return true
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
   return not fget(tle,2)
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
 end
 defm.bless=0
 local def=defm.defmin+flr(rnd(defm.defmax-defm.defmin+1))
 dmg-=min(def,dmg)
 defm.hp-=dmg
 defm.flash=10
 addfloat("-"..dmg,defm.x*8,defm.y*8,9)
 if defm.hp<=0 then
  if defm != p_mob then 
   st_kills+=1 
  else
   st_killer=atkm.name
  end
  add(dmob,defm)
  del(mob,defm)
  defm.dur=10
 end
end


function healmob(mb,hp)
	hp=min(mb.hpmax-mb.hp,hp)
 mb.hp+=hp
 mb.flash=10
 addfloat("+"..hp,mb.x*8,mb.y*8,7)
end

function stunmob(mb)
 mb.stun=true
 mb.flash=10
 addfloat("stun",mb.x*8-3,mb.y*8,7)
end

function blessmob(mb,val)
 mb.bless=mid(-1,1,mb.bless+val)
 mb.flash=10
 local txt="bless"
 if val <0 then txt="curse" end
 addfloat(txt,mb.x*8-5,mb.y*8,7)
 if mb.spec=="ghost" and val>0 then
  add(dmob,mb)
  del(mob,mb)
  mb.dur=10
 end
end

function checkend()
 if win then
  wind={}
  gover_spr=112
  gover_x=13
  gover_w=13
  _upd=update_gover
  _drw=draw_gover
  fadeout(0.02)
  return false
 elseif p_mob.hp<=0 then
  wind={}
  gover_spr=80 
  gover_x=28
  gover_w=9
  _upd=update_gover
  _drw=draw_gover
  fadeout(0.02)
  return false
 end
 return true
end

function los(x1,y1,x2,y2)
 local frst,sx,sy,dx,dy=true
 if dist(x1,y1,x2,y2)== 1 then return true end
 if x1<x2 then
  sx,dx=1,x2-x1
 else
  sx,dx=-1,x1-x2
 end
 if y1<y2 then
  sy,dy=1,y2-y1
 else 
  sy,dy=-1,y1-y2
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
    showmsg(itm_name[itm]..itm_desc[itm],120)
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
	end
end

function throw()
 local tx,ty=throwtile()
 local itm=inv[thrslt]
 if inbounds(tx,ty) then
  local mb=getmob(tx,ty)
  if mb then
   if itm_type[itm]=="fud" then
    eat(itm,mb)
   else
    hitmob(nil,mb,itm_stat1[itm])
    sfx(58)
   end
  end
 end
 mobbump(p_mob,thrdx,thrdy)
 inv[thrslt]=nil
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
 end
end

function floormsg()
 showmsg("floor"..floor,120)
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
  flash=0,
  stun=false,
  charge=1,
  lastmoved=false,
  bless=0,
  spec=mob_spec[typ],
  hp=mob_hp[typ],
  hpmax=mob_hp[typ],
  atk=mob_atk[typ],
  defmin=0,
  defmax=0,
  los=mob_los[typ],
  task=ai_wait,
  name=mob_name[typ]
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
   if m.stun then
    m.stun=false
   else
    m.lastmoved=m.task(m)
    moving=m.lastmoved or moving
   end
  end
 end
 if moving then
  _upd=update_aiturn
  p_t=0
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
  mobbump(m,dx,dy)
  if m.spec=="stun" and m.charge>0 then
   stunmob(p_mob)
   m.charge-=1
  elseif m.spec=="ghost" and m.charge>0 then
   hitmob(m,p_mob)
   blessmob(p_mob,-1)
   m.charge-=1
  else
   hitmob(m,p_mob)
  end
  sfx(57)
  return true
 else
  --move toward player
  if cansee(m,p_mob) then
   m.tx,m.ty=p_mob.x,p_mob.y
  end
  if m.x==m.tx and m.y==m.ty then
   --de aggro
   m.task=ai_wait
   addfloat("?",m.x*8+2,m.y*8,10)
   m.lastmoved=false
  else
   if m.spec=="slow" and m.lastmoved then
    return false
   end
   local bdst,cand=999,{}
   calcdist(m.tx,m.ty)
   for i=1,4 do
    local dx,dy=dirx[i],diry[i]
    local tx,ty=m.x+dx,m.y+dy
    if iswalkable(tx,ty,"checkmobs") then
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
 local target,x,y=2+flr(rnd((r.w*r.h)/6-1))
 target=min(5,target)
 for i=1,target do
  repeat
   x=r.x+flr(rnd(r.w))
   y=r.y+flr(rnd(r.h))
  until iswalkable(x,y,"checkmobs")
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
 local fud,fu=explode("potion,potion,potion,potion,potion,potion,potion,potion,potion,potion,potion,potion")
 local adj,ad=explode("red,yellow,green,blue,orange,purple,white,black,clear,brown,gray,milky")
 for i=1,#itm_name do
  if itm_type[i]=="fud" then
   fu,ad=getrnd(fud),getrnd(adj)
   del(fud,fu)
   del(adj,ad)
   itm_name[i]=ad.." "..fu
  end
 end
end


-->8
--gen
--tab 7 level gen

function genfloor(f)
 floor=f
 makefipool()
 mob={}
 add(mob,p_mob)
 fog=blankmap(0)
 if floor==1 then st_steps=0 end
 if floor==0 then
  copymap(16,0)
 elseif floor==winfloor then
  copymap(32,0)
 else
  fog=blankmap(0)
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
  if #flaglib>1 then
   debug[1]="Reconnect Area"
  end
until #flaglib==1
 debug[1]=#flaglib
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
 --flip()
end
-------------------
--rooms
-------------------

function genrooms()
 local fmax,rmax=5,4
 local mw,mh=6,6
 repeat
  local r=rndroom(mw,mh)
  if placeroom(r) then
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
  local sig=getsig(x,y)
  for i=1,#crv_sig do
   if bcomp(sig,crv_sig[i],crv_msk[i]) then
    return true
   end
  end
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

function nexttoroom(x,y)
 for i=1,4 do
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

 for x=0,15 do
  for y=0,15 do
   local tmp=distmap[x][y]
   if tmp>=0 and tmp<low and cancarve(x,y) then
    px,py=x,y
    low=tmp
   end
  end
 end
 mset(px,py,15)
 p_mob.x=px
 p_mob.y=py
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
    local sig,tle=getsig(x,y),3
    for i=1,#wall_sig do
     if bcomp(sig,wall_sig[i],wall_msk[i]) then
      tle=i+15
      break
     end
    end
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
 local funcs,func={
  deco_dirt,
  deco_torch,
  deco_carpet,
  deco_fern,
  deco_vase
 },deco_vase
 for r in all(rooms) do
  for x=0,r.w-1 do
   for y=r.h-1,1,-1 do
    if mget(r.x+x,r.y+y)==1 then
     func(r,r.x+x,r.y+y,x,y)
    end
   end
  end
  func=getrnd(funcs)
 end
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
 local chestdice,rpot,rare,place=explodeval("0,1,1,1,2,3"),{},true
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
 if rare then
  mset(x,y,12)
 else
  mset(x,y,10)
 end
end

__gfx__
00000000000000006606666000000000110111100000000044444000000000004444444000000000000000004444444000444000444444404444000000000000
00000000000000000000000000000000000000000000000004444400044444000444440044444400000000004000004044444440404040400000000011110000
00700700000000006660666000000000111011100000000004444400044444000444440040000400044440004000004044444440404040404444400000000000
00077000000000000000000000000000000000000000000004444400044444000444440044004400444444004400044000000000404040404444440011111000
00077000000000006066606000000000000000000000000004444400004440000044400040000400000000004000004044040440404040400000000011111100
00700700000100000000000000000000000100000000000004444400000400000004000040000400440044004000004044404440404040404444444000000000
00000000000000006660666000000000000000000000000000444440004440000044400044444400444444004444444044444440444444404444444011111110
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011111110
0000000000000000000000000dddddd0dddddd000dddddd00ddddd00dddddd00ddd0ddd0ddddddd00000ddd0ddd00000ddddddd00000ddd00000ddd0ddd00000
000000000000000000000000ddddddd0ddddddd0ddddddd0ddddddd0ddddddd0ddd0ddd0ddddddd00000ddd0ddd00000ddddddd00000ddd00000ddd0ddd00000
000000000000000000000000ddddddd0ddddddd0ddddddd0ddddddd0ddddddd0ddd00dd0ddddddd000000dd0dd000000ddddddd00000ddd000000dd0ddd00000
000000000000000000000000ddd000000000ddd0ddd00000ddd0ddd00000ddd0ddd00000000000000000000000000000000000000000ddd000000000ddd00000
00000dd05ddddd50dd000000ddd000000000ddd0ddd0ddd0ddd0ddd0ddd0ddd0ddd00dd0dd000dd0dd000dd0dd000dd000000dd0dd00ddd0ddddddd0ddd00dd0
0000ddd0ddddddd0ddd00000ddd000000000ddd0ddd0ddd0ddd0ddd0ddd0ddd0ddd0ddd0ddd0ddd0ddd0ddd0ddd0ddd00000ddd0ddd0ddd0ddddddd0ddd0ddd0
0000ddd05ddddd50ddd00000ddd000000000ddd0ddd0ddd0ddd0ddd0ddd0ddd0ddd0ddd0ddd0ddd0ddd0ddd0ddd0ddd00000ddd0ddd0ddd0ddddddd0ddd0ddd0
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000ddd00ddddd00ddd00000ddd000000000ddd00dddddd0ddd0ddd0dddddd00ddd0ddd0ddd0ddd0ddd0ddd0ddd0ddd0ddd0ddd0ddd00000ddd0ddd0ddddddd0
0000ddd0ddddddd0ddd00000ddd000000000ddd0ddddddd0ddd0ddd0ddddddd0ddd0ddd0ddd0ddd0ddd0ddd0ddd0ddd0ddd0ddd0ddd00000ddd0ddd0ddddddd0
0000ddd0ddddddd0ddd00000ddd000000000ddd0ddddddd0dd000dd0ddddddd0dd000dd0dd00ddd0dd000dd0dd000dd0ddd00dd0dd000000dd00ddd0ddddddd0
0000ddd0ddd0ddd0ddd00000ddd000000000ddd0ddd00000000000000000ddd0000000000000ddd00000000000000000ddd00000000000000000ddd000000000
0000ddd0ddddddd0ddd00000ddddddd0ddddddd0ddddddd0dd000dd0ddddddd0ddddddd0dd00ddd000000dd0dd000000ddd00000ddddddd00000ddd0dd000000
0000ddd0ddddddd0ddd00000ddddddd0ddddddd0ddddddd0ddd0ddd0ddddddd0ddddddd0ddd0ddd00000ddd0ddd00000ddd00000ddddddd00000ddd0ddd00000
0000ddd00ddddd00ddd000000dddddd0dddddd000dddddd0ddd0ddd0dddddd00ddddddd0ddd0ddd00000ddd0ddd00000ddd00000ddddddd00000ddd0ddd00000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000ddd0ddddddd0ddd00000ddddddd0ddd0ddd0ddd0ddd0ddd0ddd0ddd0ddd00000ddd0ddd000000000ddd000000000ddd0ddd0ddd000000000000000000000
0000ddd0ddddddd0ddd00000ddddddd0ddd0ddd0ddd0ddd0ddd0ddd0ddd0ddd00000ddd0ddd000000000ddd000000000ddd0ddd0ddd000000000000000000000
00000dd0ddddddd0dd000000ddddddd0ddd0ddd0ddd0ddd0ddd0ddd0ddd0ddd000000dd0dd00000000000dd000000000dd000dd0dd0000000000000000000000
00000000000000000000000000000000ddd0ddd0ddd00000ddd0ddd00000ddd00000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000ddddddd0ddd0ddd0ddddddd0ddddddd0ddddddd0dd00000000000dd000000dd0dd000dd000000000dd0000000000000000000000
000000000000000000000000ddddddd0ddd0ddd0ddddddd0ddddddd0ddddddd0ddd000000000ddd00000ddd0ddd0ddd000000000ddd000000000000000000000
000000000000000000000000ddddddd0ddd0ddd00dddddd00ddddd00dddddd00ddd000000000ddd00000ddd0ddd0ddd000000000ddd000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
d000000000000000000000d000000000011111001101111000000000100000101010010000000000000000000000000000000000066666666666666666610000
000000000d0000000000000000000d00110010100000000011000000010001000001100010101010001000000100010000001000666666666666666666611000
dd000000d000000000000dd0000000d0101001101110111011100000011010001010010000000000010000000000000000000000611661666166161616615100
1d0000001d00000000000d1000000d10100100101001001011100110001010000000000001010100000001000010001000000000661661611161611616615100
11000000110000000000011000000110110010101100101001101110001010000101001000000000000000000000010000000100666661666661666616615100
10010000100100000001001000010010101001101010011000101100001100001000110010101010000000000100000000100000666666666666666666615100
10000000100000000000001000000010011111000111110000010000000100000101001001010100000000000000100000000100616616116161661666615100
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000616616616161611616615100
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000611666616161666611615100
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000666666666666666666615100
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000616616166616616616615100
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000616116166166616611615100
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000616666116161661616615100
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000666666666666666666615100
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000616166616166166616615100
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000616616166161661616615100
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000611616166161661616615100
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000666666666666666666615100
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000616666161166616166615100
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000616116166161616166615100
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000616166166161616166615100
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000666666666666666666615100
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000616616166161166166615100
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000611616166161616166615100
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000616616661161616616615100
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000666666666666666666615100
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000666666666666666666615100
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000111111111111111111115100
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000015555555555555555551100
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001111111111111111111000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
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
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00770000000000000007700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000070000000
00700000000770000007000000077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000077000000
00070700000700000000700000070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000077700000
00700700007070700000070000007070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000077000000
07070700070700700077070000770070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000070000000
00070000007700700707070007077070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00070000007070000007000000707000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__label__
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888777777888eeeeee888eeeeee888888888888888888888888888888888888888888888888888888ff8ff8888228822888222822888888822888888228888
8888778887788ee88eee88ee888ee88888888888888888888888888888888888888888888888888888ff888ff888222222888222822888882282888888222888
888777878778eeee8eee8eeeee8ee88888e88888888888888888888888888888888888888888888888ff888ff888282282888222888888228882888888288888
888777878778eeee8eee8eee888ee8888eee8888888888888888888888888888888888888888888888ff888ff888222222888888222888228882888822288888
888777878778eee18eee8eee8eeee88888e88888888888888888888888888888888888888888888888ff888ff888822228888228222888882282888222288888
888777888778ee1718ee8eee888ee888888888888888888888888888888888888888888888888888888ff8ff8888828828888228222888888822888222888888
888777777778ee1771ee8eeeeeeee888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
11111111111111177711111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1eee1e1e1ee1111777711eee11ee1ee1111111111666166116661666117111711111111111111111111111111111111111111111111111111111111111111111
1e111e1e1e1e1e17711111e11e1e1e1e111111111161161611611161171111171111111111111111111111111111111111111111111111111111111111111111
1ee11e1e1e1e1e11171111e11e1e1e1e111111111161161611611161171111171111111111111111111111111111111111111111111111111111111111111111
1e111e1e1e1e1e1111e111e11e1e1e1e111111111161161611611161171111171111111111111111111111111111111111111111111111111111111111111111
1e1111ee1e1e11ee11e11eee1ee11e1e111116661666161616661161117111711111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111161616661661111116161666166116661666166611111166166616661666111111111111111111111111111111111111111111111111111111111111
11111111161616161616177716161616161616161161161111111611161616661611111111111111111111111111111111111111111111111111111111111111
11111111161616661616111116161666161616661161166111111611166616161661111111111111111111111111111111111111111111111111111111111111
11111111161616111616177716161611161616161161161111111616161616161611111111111111111111111111111111111111111111111111111111111111
11111666116616111666111111661611166616161161166616661666161616161666111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111166116661616111116611666166616161111116616661666166611111111111111111111111111111111111111111111111111111111111111111111
11111111161616161616177716161616161616161111161116161666161111111111111111111111111111111111111111111111111111111111111111111111
11111111161616611616111116161661166616161111161116661616166111111111111111111111111111111111111111111111111111111111111111111111
11111111161616161666177716161616161616661111161616161616161111111111111111111111111111111111111111111111111111111111111111111111
11111666166616161666111116661616161616661666166616161616166611111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111166166616661666166611661666166616661171117111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111611116116161616116116111616166616111711111711111111111111111111111111111111111111111111111111111111111111111111
11111111111111111666116116661661116116111666161616611711111711111111111111111111111111111111111111111111111111111111111111111111
11111111111111111116116116161616116116161616161616111711111711111111111111111111111111111111111111111111111111111111111111111111
11111111111111111661116116161616116116661616161616661171117111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1eee1ee11ee111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1e111e1e1e1e11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1ee11e1e1e1e11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1e111e1e1e1e11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1eee1e1e1eee11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1eee1e1e1ee111ee1eee1eee11ee1ee1111111111616166616611666166616661171117111111111111111111111111111111111111111111111111111111111
1e111e1e1e1e1e1111e111e11e1e1e1e111111111616161616161616116116111711111711111111111111111111111111111111111111111111111111111111
1ee11e1e1e1e1e1111e111e11e1e1e1e111111111616166616161666116116611711111711111111111111111111111111111111111111111111111111111111
1e111e1e1e1e1e1111e111e11e1e1e1e111111111616161116161616116116111711111711111111111111111111111111111111111111111111111111111111
1e1111ee1e1e11ee11e11eee1ee11e1e111116661166161116661616116116661171117111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111161616661661117111711111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111161616161616171111171111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111161616661616171111171111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111161616111616171111171111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111666116616111666117111711111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1eee1ee11ee111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1e111e1e1e1e11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1ee11e1e1e1e11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1e111e1e1e1e11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1eee1e1e1eee11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1eee1e1e1ee111ee1eee1eee11ee1ee1111111111661166616661616117111711111111111111111111111111111111111111111111111111111111111111111
1e111e1e1e1e1e1111e111e11e1e1e1e111111111616161616161616171111171111111111111111111111111111111111111111111111111111111111111111
1ee11e1e1e1e1e1111e111e11e1e1e1e111111111616166116661616171111171111111111111111111111111111111111111111111111111111111111111111
1e111e1e1e1e1e1111e111e11e1e1e1e111111111616161616161666171111171111111111111111111111111111111111111111111111111111111111111111
1e1111ee1e1e11ee11e11eee1ee11e1e111116661666161616161666117111711111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111166116661616117111711111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111161616161616171111171111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111161616611616171111171111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111161616161666171111171111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111666166616161666117111711111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1eee1ee11ee111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1e111e1e1e1e11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1ee11e1e1e1e11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1e111e1e1e1e11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1eee1e1e1eee11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1eee1e1e1ee111ee1eee1eee11ee1ee1111111661666166616661666116616661666166611711171111111111111111111111111111111111111111111111111
1e111e1e1e1e1e1111e111e11e1e1e1e111116111161161616161161161116161666161117111117111111111111111111111111111111111111111111111111
1ee11e1e1e1e1e1111e111e11e1e1e1e111116661161166616611161161116661616166117111117111111111111111111111111111111111111111111111111
1e111e1e1e1e1e1111e111e11e1e1e1e111111161161161616161161161616161616161117111117111111111111111111111111111111111111111111111111
1e1111ee1e1e11ee11e11eee1ee11e1e111116611161161616161161166616161616166611711171111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
111116661111161611111cc111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1111161611111616177711c111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1111166611111161111111c111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1111161111111616177711c111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
111116111666161611111ccc11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
111116661111161611111c1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
111116161111161617771c1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
111116661111166611111ccc11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
111116111111111617771c1c11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
111116111666166611111ccc11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1eee1ee11ee111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1e111e1e1e1e11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1ee11e1e1e1e11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1e111e1e1e1e11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1eee1e1e1eee11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
82888222822882228888822888828228822288888888888888888888888888888888888888888888888888888888822282228882822282288222822288866688
82888828828282888888882888288828828288888888888888888888888888888888888888888888888888888888828288828828828288288282888288888888
82888828828282288888882888288828822288888888888888888888888888888888888888888888888888888888822282228828822288288222822288822288
82888828828282888888882888288828828288888888888888888888888888888888888888888888888888888888888282888828828288288882828888888888
82228222828282228888822282888222822288888888888888888888888888888888888888888888888888888888888282228288822282228882822288822288
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888

__gff__
0000050500000303030103010307020005050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505000000000000000004040000000000000000000000000000000000000000000000000000000000000000000000000000030000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
0202020202020202020202010202020203030303030303030303030303030303030303030303030303030303030303030101020202020202020202020202020200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
02010201010201010101010101010e0203030303030303030303030303030303030303030303030303030303030303030101020202020202020202020202020200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
02010201010601020a0101010201010203030303030310111203030303030303030303030303030303030303030303030101020202020202020202020202020200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
02010201010101020101020d020d0202030303031011240f2311120303030303030303030303030303030303030303030101020202020202020202020202020200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010101010102c00202010201010203030303204444444444220303030303030303030310111111111112030303030101020202020202020202020202020200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0201010101010101020202020202060203030303200144444401220303030303030303030320040404040422030303030101020202020202020202020202020200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
020f010101010101010101010101c00203030303200101440101220303030303030303030320014d4e4f5022030303030101020202020202020202020202020200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
020202020d020d0202020202020d020203031011240801060108231112030303030303030320015d5e5f6022030303030101020202020202020202020202020200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
02c0010d01010101020101010101010203032007070101440101070722030303030303030320016d6e6f7022030303030101020202020202020202020202020200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0201010201010101020107070701010203032007070101440101070722030303030303030320017d7e7f8022030303030101020202020202020202020202020200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
020c010201010601020801c0c00107020303303114400144014213313203030303030303033031140f133132030303030101020202020202020202020202020200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0201010201010101020101c008c0070203030303200101440101220303030303030303030303033031320303030303030101020202020202020202020202020200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0201010d010101010d0101080807080203030303200101440101220303030303030303030303030303030303030303030101020202020202020202020202020200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
02020202020202020202020202020202030303033031140e1331320303030303030303030303030303030303030303030101020202020202020202020202020200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0202020202020202020202020202020203030303030330313203030303030303030303030303030303030303030303030101020202020202020202020202020200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0202020202020202020202020202020203030303030303030303030303030303030303030303030303030303030303030101020202020202020202020202020200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00100000200001e000220001e00020000220000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00030000095500b5200a5300955005560035500252000550005500820000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00020000200501b040170400103000020086200661001610000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000200003e6003e6103e61032000390102f000300001b610176100561004610036100361003610006100261001610016100060000600006001f000200001e0001e0001c0001b0001b0001a000190001700016000
000600000442003420024300143002410014100040000400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000400000054000560005000150003550095500d55000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00070000012000121005210082200c220045100440001200003000030001700017000070000700007000070000000000000000000000000000000000000000000000000000000000000000000000000000000000
000100001d600095400e54010530105300a5400255000500005000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
