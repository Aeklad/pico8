pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
function _init()
 target = {
  x=64,
  y=64,
  c=7
 }

end

function lerp(tar,pos,perc)
 return (1-perc)*tar+perc*pos
end

function _update()
 tx=64
 ty=64
 if btn(0) then tx=0 end
 if btn(1) then tx=128 end
 if btn(2) then ty=0 end
 if btn(3) then ty=128 end
 target.x = lerp(tx,target.x,0.9)
 target.y = lerp(ty,target.y,0.9)
end
 

function _draw()
 cls()
 line(target.x,target.y,target.x,target.y+10)
 
end

__gfx__
00000000000000008888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
00000000000000008888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
00000000000000008888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
0000000000000000888aaaaaa8888888888aaaaaa88888888aa88888888888888888aaaaa8888888888aaaaaa888888888888888888888888888888888888888
000000000000000088aaaaa77988888888aaaaa77988888888aaaaaaa8888888888aaaaa7988888888aaaaaa7988888888888888888888888888888888888888
00000000000000008aaaaaa707888888aaaaaaa70788888888aaaaa77988888888aaaaa7778888888aaaaaa77788888888888888888888888888888888888888
00000000000000008aa8aaaa798888888888aaaa79888888888aaaa70788888888aaaaa7708888888aa8aaa77088808888888888888888888888888888888888
0000000000000000a888899999888088888889999988888888888aaa7988888888aa89999988808888a889999988088888888888888888888888888888888888
0000000000000000888888888888088888888aaaa88888088888899999888888888a88888888088888888aaaa880888888888888888888888888888888888888
000000000000000088888aaaa88088888888aaaaa888008888888aaaa888000888888aaaa88088888888aaaaa808888888888888888888888888888888888888
00000000000000008888aaaaa80888888888aaaaa88008888888aaaaa80088888888aaaaa80888888888aaaaa988888888888888888888888888888888888888
00000000000000008888aaaaa98888888888aaaaa99888888888aaaaa98888888888aaaaa98888888888aaaaa988888888888888888888888888888888888888
00000000000000008888aaaaa988888888889999988888888888aaaaa88888888888aaaaa9888888888899999888888888888888888888888888888888888888
00000000000000008888999908888888888898898888888888889999988888888888999998888888888899999888888888888888888888888888888888888888
00000000000000008880888808888888888808808888888888888008888888888880888808888888888088880888888888888888888888888888888888888888
00000000000000008888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888880888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888088888888888888888888888
88888aaaaa88888888888aaaaa888888888888888888888888888888888888888888888888888888888888888888880888888888088888888888888888888888
8888aaaaa79888888888aaaaa79888888888aaaaa8888888888aaaaa8888888888aaaaa8888888888aaaaa888888808888aaaaa8808888888888888888888888
888aaaaa77788888888aaaaa77788888888aaaaa7988888888aaaaa7988888888aaaaa7988888888aaaaa798888808888aaaaa70808888888888888888888888
888a8aaa7708888888aa8aaa7708888888aaaaa7778888888aaaaa7778888888aaaaa77788888888aaaa7708888088888aaaa777808888888888888888888888
88a8889999980008888888999998808888a8aaa7708888888aaaaa7708888888aaaaa77088880008aaaa7778880888888aaaa777808888888888888888888888
88888aaaa880888888888aaaa88808088a8889999988888888a89999988888888a89999988808880a899999889888888aa899999898888888888888888888888
8888aaaaa80888888888aaaaa880888888888aaaa88800888888aaaa8888888888a8aaaa8a9888888a88aaaaaa888888a888aaaaaa8888888888888888888888
8888aaaaa98888888888aaaaaa9888888888aaaaa8808808888aaaaaa88800888888aaaaaa9888888888aaaaaa8888888888aaaaaa8888888888888888888888
8888aaaaa98888888888aaaaaa9888888888aaaaaa988808888aaaaaaa8088088888aaaaaa8888888888aaaaaa8888888888aaaaaa8888888888888888888888
888899999888888888889999988888888888aaaaaa9888888888aaaaaa98880888888aaaa888888888888aaaa888888888888aaaa88888888888888888888888
88889999988888888888999998888888888899999888888888889999989888088888899998888888888889999888888888888999988888888888888888888888
88808888088888888880888808888888888088880888888888888088088888888888880880888888888888808088888888888080888888888888888888888888
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
66666666888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
66666666888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
66666666888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
66666666888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
55555555888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
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
88868888688888888888f8868888888888888668888888888886888868888888888f888868888888888888888888888888888888888888888888888888888888
88f66666666888888888f8f88f66f688886666f66666888888666666666688888ffff66666688888888888888888888888888888888888888888888888888888
88f6888888888888888fffff6688888888886688888868888888888888888888888ffff668888888888888888888888888888888888888888888888888888888
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
6f6f6f6f6f6f6f6f6f6f6f40436f6f005a5b00000000005a5b00005c00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
6f6f6f6f40436f6f6f6f404141436f0000005a5c5a000000000000005a5b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
6f4043404141436f6f404141414143000000005a5b0000005a5c000000005c00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4041414141414141414141414141414300000000005b5a000000005a00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
5051525354555050505050505051535500000000000000000000005b5a000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
6060606060606060606060606060606000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
464748494a48484848484a4848484b4800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
5857585858565857585856575858575800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000004e004d0000004e004d00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000004d5e005d0000005e4d5d00004d00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000004c5d00000000004c005d00004c5d00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000