pico-8 cartridge // http://www.pico-8.com
version 16
__lua__

function _make_smoke(x,y,init_size,color)
  local smoke_particle={}
  smoke_particle.x=x
  smoke_particle.y=y
  smoke_particle.color=color
  smoke_particle.width=init_size
  smoke_particle.width_final=init_size+rnd(3)+1
  smoke_particle.time_alive=0
  smoke_particle.max_time_alive=30+rnd(10)
  smoke_particle.dx=rnd(.8)*.4
  smoke_particle.dy=rnd(.05)
  smoke_particle.ddy=.02
  add(smoke,smoke_particle)
  return smoke_particle
end
function _init()
  smoke={}
  cursor_x=50
  cursor_y=50
  color=1
end
function _move_smoke(current_particle)
  if current_particle.time_alive>current_particle.max_time_alive-15 then
    del(smoke,current_particle)
  end
  if current_particle.time_alive>current_particle.max_time_alive then
    current_particle.width=current_particle.width+1
    current_particle.width=min(current_particle.width,current_particle.width_final)
  end
  current_particle.x=current_particle.x+current_particle.dx
  current_particle.y=current_particle.y+current_particle.dy
  current_particle.dy=current_particle.dy+current_particle.ddy
  current_particle.time_alive=current_particle.time_alive+1
end

function _update()
  foreach(smoke,_move_smoke) 
    if btn(0) then cursor_x=cursor_x-1 end
    if btn(1) then cursor_x=cursor_x+1 end
    if btn(2) then cursor_y=cursor_y-1 end
    if btn(3) then cursor_y=cursor_y+1 end
    if btn(4) then color = flr(rnd(16)) end
    _make_smoke(cursor_x,cursor_y,rnd(4),color)
    

end

function _draw_smoke(smoke_particle)
  circfill(smoke_particle.x,smoke_particle.y,smoke_particle.width,smoke_particle.color)
end
function _draw()
  cls()
  foreach(smoke,_draw_smoke) 
    

end






