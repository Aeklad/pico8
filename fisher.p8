pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

function _init()
 poke(0x5f2c,3) --This poke doubles the pixel size: screen space is 64X64: Good for Gameshell games
 palt(8,true) --Changes the Hot Pink Color 8 to be transparent so I can use black as a solid color
 palt(0,false) -- Makes the Black Color 0 Opaque
 at=0 -- store the animation timer
 aw=0.5 -- amount of time to wait between animation frames
 friction=0.85 --mulitiplied to scrolling x movement each update to slow to a stop when acc is 0
 acc=0 --acceleration added or subtracted to scrolling x movement each update according to user input
 flp=false --flips the sprite horizontally
 left = false -- use this to check if any button other than left is being pressed
 right = false --same for the right
 fall=false

 pl = { --player variables
  s=2,
  w=2,
  pw=16,
  ph=16,
  h=2,
  x=24,
  y=35,
  fishing=false
 }

 holes={}
 hitbox={}

 parallax = { --Map  coordinates and placement for parallax background
  cx={16,0,0,16,0},
  cy={0,0,4,8,6},
  x={0,0,0,0,0},
  y={0,8,32,20,48},
  cw={16,16,16,16,16},
  ch={5,4,2,4,4},
  dx={0,0,0,0,0},
  max_dx={1,1.5,2,2,3}
 }

 create_hole(64)
 create_hole(-64)
end

function create_hitbox(_x)
 local b = {
  pw=4,
  ph=8,
  x=_x,
  y=44,
  dx=0,
  max_dx=2
  }
 add(hitbox,b)
end

function create_hole(_x)
 local b = {
  s=97,
  w=3,
  h=1,
  pw=24,
  ph=8,
  x=_x,
  y=44,
  dx=0,
  max_dx=2
  }
 add(holes,b)
 create_hitbox(_x+10)
end
  
function collide(a,b)
 return a.pw+a.x>b.x and a.x < b.pw+b.x
end
 
function move() -- set the acceleration variable so character appears to move left or right and flip accordingly
 acc=0
 if btn(1) and not right then acc =.5 end
 if btn(0) and not left then acc=-.5 end
 if parallax.dx[1] < 0 then
  flp=true
 else
  flp=false
 end
end

function animate(sp,f1,f2,aw,loop)
 if f1 > sp.s then sp.s=f1 end
 if time()-at > aw then --advance frame only when actual time minus timestored is greater than aw
  sp.s+=sp.w
  if sp.s> f2 then 
   if loop then
    sp.s=f1 
   else
    sp.s=f2
   end
  end
  at=time()
 end
end

function parallax_scroll() --loop through the 5 map coordinate tables and apply movement

 for i=1,5 do
  parallax.dx[i]*=friction
  parallax.dx[i]+=acc
  parallax.dx[i]=mid(-parallax.max_dx[i],parallax.dx[i],parallax.max_dx[i])
  parallax.x[i]%=(128)
  parallax.x[i]-=parallax.dx[i]
 end

end


function _update()
 left = btn(1) or btn(2) or btn(3) or btn(4) or btn(5)
 right = btn(0) or btn(2) or btn(3) or btn(4) or btn(5)
 
 if not fall then

 parallax_scroll()
 move()
 
  if acc !=0  then
   animate(pl,2,6,.05,true)
  elseif btn(3) then
   animate(pl,12,14,.2,true)
  elseif btn(2) then
   animate(pl,32,44,.05,false)
  else 
   animate(pl,8,10,.2,true)
  end

 else
  acc=0
  animate(pl,102,112,.2,false)
  if pl.s >=112 then
   _init()
  end
 end

 for h in all(holes) do
  h.dx *= friction
  h.dx += acc
  h.dx = mid(-h.max_dx,h.dx,h.max_dx)
  if not fall then
   h.x -=h.dx
  end
  if collide(pl,h) then 
   pal(10,3)
  else
   pal(10,10)
  end 
 end
 for hb in all(hitbox) do
  hb.dx *= friction
  hb.dx += acc
  hb.dx = mid(-hb.max_dx,hb.dx,hb.max_dx)
  hb.x -=hb.dx
  if collide(pl,hb) then
   fall = true
  end
 end
end

function _draw() 
 cls(13)

 for i=1,5 do
  map(parallax.cx[i],parallax.cy[i],parallax.x[i],parallax.y[i],parallax.cw[i],parallax.ch[i])
  map(parallax.cx[i],parallax.cy[i],parallax.x[i]-128,parallax.y[i],parallax.cw[i],parallax.ch[i])
 end

 for hl in all(holes) do
  spr(hl.s,hl.x,hl.y,hl.w,hl.h)
 end
 spr(pl.s,pl.x,pl.y,pl.w,pl.h,flp)
 for hb in all(hitbox) do
  line(hb.x,44,hb.x+hb.pw,44,10)
  print(hb.x)
 end
 
end
__gfx__
00000000000000008888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
0000000000000000888aaaaaa8888888888aaaaaa88888888aa88888888888888888aaaaa8888888888aaaaaa88888888888aaaaa8888888888aaaaaa8888888
000000000000000088aaaaa77a88888888aaaaa77a88888888aaaaaaa8888888888aaaaa7a88888888aaaaaa7a888888888aaaaa7a88888888aaaaaa7a888888
00000000000000008aaaaaa707888888aaaaaaa70788888888aaaaa77a88888888aaaaa7778888888aaaaaa77788888888aaaaa7778888888aaaaaa777888888
00000000000000008aa8aaaa798888888888aaaa79888888888aaaa70788888888aaaaa7708888888aa8aaa77088808888aaaaa7708888888aa8aaa770888088
0000000000000000a888899999888088888889999988888888888aaa7988888888aa89999988808888a889999988088888aa89999988808888a8899999880088
0000000000000000888888888888088888888aaaa88888088888899999888888888a88888888088888888aaaa8808888888a88888888080888888aaaa8808088
000000000000000088888aaaa88088888888aaaaa888008888888aaaa888000888888aaaa88088888888aaaaa808888888888aaaa88088088888aaaaa8088088
00000000000000008888aaaaa80888888888aaaaa88008888888aaaaa80088888888aaaaa80888888888aaaaa98888888888aaaaa80888088888aaaaa9888088
00000000000000008888aaaaa98888888888aaaaa99888888888aaaaa98888888888aaaaa98888888888aaaaa98888888888aaaaa98888088888aaaaa9888088
00000000000000008888aaaaa988888888880000088888888888aaaaa88888888888aaaaa988888888880000088888888888aaaaa98888088888000008888808
00000000000000008888000008888888888808808888888888880000088888888888000008888888888800000888888888880000088880888888000008888808
00000000000000008880888808888888888808808888888888888008888888888880888808888888888088880888888888808888088880888880888808888808
00000000000000008888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
00000000000000008888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
00000000000000008888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888088888888888888888888888
88888aaaaa88888888888aaaaa888888888888888888888888888888888888888888888888888888888888888888880888888888088888888888888888888888
8888aaaaa7a888888888aaaaa7a888888888aaaaa8888888888aaaaa8888888888aaaaa8888888888aaaaa888888808888aaaaa8808888888888888888888888
888aaaaa77788888888aaaaa77788888888aaaaa7a88888888aaaaa7a88888888aaaaa7a88888888aaaaa7a8888808888aaaaa70808888888888888888888888
888a8aaa7708888888aa8aaa7708888888aaaaa7778888888aaaaa7778888888aaaaa77788888888aaaa7708888088888aaaa777808888888888888888888888
88a8889999980008888888999998808888a8aaa7708888888aaaaa7708888888aaaaa77088880008aaaa7778880888888aaaa777808888888888888888888888
88888aaaa880888888888aaaa88808088a8889999988888888a89999988888888a89999988808880a899999889888888aa899999898888888888888888888888
8888aaaaa80888888888aaaaa880888888888aaaa88800888888aaaa8888888888a8aaaa8a9888888a88aaaaaa888888a888aaaaaa8888888888888888888888
8888aaaaa98888888888aaaaaa9888888888aaaaa8808808888aaaaaa88800888888aaaaaa9888888888aaaaaa8888888888aaaaaa8888888888888888888888
8888aaaaa98888888888aaaaaa9888888888aaaaaa988888888aaaaaaa8088088888aaaaaa8888888888aaaaaa8888888888aaaaaa8888888888888888888888
888800000888888888880000088888888888aaaaaa9888888888aaaaaa98888888888aaaa888888888888aaaa888888888888aaaa88888888888888888888888
88880000088888888888000008888888888800000888888888880000089888888888800008888888888880000888888888888000088888888888888888888888
88808888088888888880888808888888888088880888888888888088088888888888880880888888888888808088888888888080888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888881111111118888888818888888888888888888888888888888888888888888888888888888888888888888888888883888888888888883888888888888
88888811111111118888888811888888888888888888888888888888888888888888888888888888888888888888888888830788888888888833788888888888
88888111111111118888888811188888888888888888888888888888888888888888888888888888888888888888888888883788888888888830388888888888
88881111111111118888888811118888888888888888888800000000000088888888888888888888888888888888888888830378888888888380878888888888
88811111111111118888888811111888888888888888888855555555555500000000000000000000000000000000000088880888888888888387838888888888
88111111111111118888888811111188888888888888888866666666666655555555555557775555555577555555555588888888888388888830788888888888
81111111111111118888888811111118888888888888888866666666666666666666666665556666666657666676666688888888883078888383838888888888
11111111111111118888888811111111888888888888888866666666666666666666666666666666666665666656666688888888838338888830787888888888
88888888888888888888877777777777777888888888888866666666666666666666666666666666888888888888888887878788888388888383838888888888
88888888888888877777766666666666666777777888888867777666666666666666666666666666878888888888888887888888838078883833887888888888
88888888877777766666666666666666666666666777777877777766666666666666666666666666888788878788888887787888833787888380788788888888
77777777766666666666666666666666666666666666666757755666666666666666666666666666878877888887888888878888883378888383878888888888
66666666666666666666666666666666666666666666666665566666667777766666666688888888888888887788878888887787838037883833883788888888
66666666666666666666666666666666666666666666666666666666677777566666666688888888888888888777888888888878888083888380378888888888
66666666666666666666666666666666666666666666666666666666655555666666666688888888888888888887787888888888888088883880887888888888
66666666666666666666666666666666666666666666666666666666666666666666666688888888888888888888888888888888888888888888888888888888
66666666888888888888888888888888888888880000000088888888888888888888888888888888888888888888888888888888888888888888888888888888
66666666866666666666666666666666888888880000000088888888888888888888888888888888888888888888888888888888888888888888888888888888
6666666666111111111111111111111188888888000000008888aaaaa88888888888888888888888888888888888888888888888888888888888888888888888
66666666110000000000000000000008888888880000000088aaaaaaaaa888888888888aa8888888888888888888888888888888888888888888888888888888
5555555500000000000000000000088888888888000000008a8aaaaa77a8888888888888aaaa8888888888888888888888888888888888888888888888888888
88888888888888888000000088888888888888880000000088888aaa70788888888888888aaaa888888888888888888888888888888888888888888888888888
8888888888888888888888888888888888888888000000008888899977888888888888888aaaaa888888888888a8888888888888888888888888888888888888
888888888888888888888888888888888888888800000000888aaaaa99888888888888888aaa77a888888888888a888888888888888888888888888888888888
888888888888888888888888888888888888888800000000888aaaaaaa88880088888888aa9a707888888888888aa88888888888888888888888888888888888
8888888888888888888888888888888888888888000000008888aaaaaa8800888888888aaaa977788888888888aaa88888888888888888888888888888888888
8888888888888888888888888888888888888888000000008888aaaaa90088888888888aaaa999888888888888aaaa8888888888888888a88888888888888888
888888888888888888888888888888888888888800000000888899aaa8888888888888aaaaaaa888888888888aaaaa888888888888888a888888888888888888
88888888888888888888888888888888888888880000000088880899a8888888888888aaaaa9908888888888aaaaaa88888888888888aa888888888888888888
88888888888888888888888888888888888888880000000088888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888880000000088888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888880000000088888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
__map__
424242424242424242424240434242425a5b00000000005a5b00005c00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4242424240434242424240414143424200005a5c5a000000000000005a5b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
424043404141434242404141414143420000005a5b0000005a5c000000005c00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4041414141414141414141414141414300000000005b5a000000005a00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
5051525354555050505050505051535500000000000000000000005b5a000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
6060606060606060606060606060606000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
464748494a48484848484a4848484b4800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
5857585858565857585856575858575800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000004e004d0000004e004d00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000004d5e005d0000005e4d5d00004d00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000004c5d00000000004c005d00004c5d00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
