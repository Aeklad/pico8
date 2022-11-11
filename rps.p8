pico-8 cartridge // http://www.pico-8.com
version 33
__lua__
poke (24364,3)
player1= {
           turn=1,
           shot=false,
           score=0
          }
player2= {
           turn=1,
           shot=false,
           score=0
          }
cpu= {
           turn=1,
           score=0
          }
playname={"rock","paper","scissors"}
gamestate=1          
stateplay=2
stateshoot=3
state2player=4
statetitle=5
t=0
shooting=false

function _init()
 c=0
 bp=-1
 wn=-1
 turns={player1.turn,player2.turn}
 players={player1,player2}
 gamestate=stateplay
end

function cpuplay()
 return flr(rnd(3))+1
end


--tick then false for 20 tick then false for 20
function timer()
 local tick = true
 t-=1
 if t>0 then
  tick=false
 else
  tick=true
  t=30
 end
 return tick
end

function shoot()
 if timer() then
  c+=1
 end
 if player1.turn==1 then 
  wn=2
 elseif player1.turn==2 then
  wn=3
 elseif player1.turn==3 then
  wn=1
 end
 if c > 3 then
  play(wn)
  c=0
  t=0
  player1.shot=false
  player2.shot=false
  shooting=false
  gamestate=stateplay
 end
end

function draw_play()
 if t>15 then
  spr(1,4,32)
  spr(1,50,32,1,1,1)
 elseif c==0 then 
  if not player2.shot then
   spr(player2.turn,4,32)
  end
  if not player1.shot then
   spr(player1.turn,50,32,1,1,1)
  end
 end
 if player1.shot and c==0 then
  print("ready",40,32,3)
 end 
 if player2.shot and c==0 then
  print("ready",0,32,3)
 end 

end

function play(w)
 if player1.turn^^player2.turn==w then
  player1.score+=1
 elseif player2.turn != player1.turn then
  player2.score+=1
 end
end

function read_input(pl)
 if not players[pl+1].shot then
  for i=0,2 do
   if btnp(i,pl) then
    shooting=true
    players[pl+1].shot=true
    if i==0 then
     turns[pl+1]=1
    elseif i==1 then 
     turns[pl+1]=3
    else
     turns[pl+1]=i
    end
    players[pl+1].turn=turns[pl+1]
   end
  end
 end
 if player1.shot and player2.shot then
  if timer() then
   gamestate=stateshoot
  end
 end
end

function human_play()
 
end

 

function singleplay()
  for i=0,2 do
   if btnp(i) then
    if i==0 then
     player1.turn=1
    elseif i == 1 then 
     player1.turn=3
    else
     player1.turn = i
    end
    player2.turn=cpuplay()
    gamestate=stateshoot
   end
  end
end

function _update()
 if gamestate==stateplay then
  --singleplay()
  read_input(0)
  read_input(1)
 elseif gamestate==state2player then
 elseif gamestate==stateshoot then
   shoot()
 end
end
 
function _draw()
 cls()
 print (player2.score,5,0,7)
 print (player1.score,53,0)
 print (c)
 print (player1.shot)
 print (player2.shot)
 print (gamestate)
 draw_play()
end
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000d0000000000d0000000000000000000000000000d0000000000d0000000000000000000000000000000000000000000000000000000000
0070070000dd00000d0000000000d0000000000000000000000000000d0000000000d00000dd0000000000000000000000000000000000000000000000000000
000770000dddd0000dddddd00ddd00000000000000000000000000000dddddd00ddd00000dddd000000000000000000000000000000000000000000000000000
00077000dddd0000ddd00000ddd00000000000000000000000000000ddd00000ddd00000dddd0000000000000000000000000000000000000000000000000000
00700700ddddd000ddddddd0ddddddd0000000000000000000000000ddddddd0ddddddd0ddddd000000000000000000000000000000000000000000000000000
00000000dddd0000ddd00000dddd0000dd000000000000dddddddd00ddd00000dddd0000dddd0000000000000000000000000000000000000000000000000000
0000000000ddd0000ddddd000dd000001d00000000000d111d0000000ddddd000dd0000000ddd000000000000000000000000000000000000000000000000000
00000000dddddd111ddddddddddddd111d000000dddddd111dddddd0000000000000000000000000000000000000000000000000000000000000000000000000
00000000111111111111111011111111110000001111111111000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000111111111100000011111111110000001111111111dddd00000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000111100000000000011110000000000001111000000000000000000000000000000000000000000000000000000000000000000000000000000
