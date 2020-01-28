pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
fake_pi = .5
turnspeed = 5 * (fake_pi/180)
target = {
	x = 64,
	y = 64,
	spd = 5
}

rocket = {
	x=32,
	y=32,
	rotation = 0,
	spd = 3,
	length = 2
}


function draw_rocket(length,x0,y0,a)
	dx = x0 + cos(a)*length
	dy = y0 + sin(a)*length
	dx1 = x0 - cos(a)*length
	dy1 = y0 - sin(a)*length

	line(x0,y0,dx,dy,2)
	line(x0,y0,dx1,dy1,3)
end


function move_target()

	if btn(0) then
		target.x -= target.spd
	elseif btn(1) then
		target.x += target.spd
	elseif btn(2) then
		target.y -= target.spd
	elseif btn(3) then
		target.y += target.spd
	end

	if target.x > 128 then
		target.x=0
	elseif target.x < 0 then
		target.x=128
	end

	if target.y > 128 then 
		target.y = 0
	elseif target.y < 0 then
		target.y = 128
	end
	
end

function turn()
	diff = atan2(dx,dy) - rocket.rotation

	if diff > fake_pi then
		diff -= fake_pi * 2
	elseif diff < -fake_pi then
		diff += fake_pi * 2
	end

	if diff > turnspeed then
		rocket.rotation += turnspeed
	elseif diff < - turnspeed then
		rocket.rotation -= turnspeed
	else 
		rocket.rotation = atan2(dx,dy)
	end
	

end


function _update()
	cls(1)
	
	move_target()
	
	if rocket.x > 128 then
		rocket.x=0
	elseif rocket.x < 0 then
		rocket.x=128
	end

	if rocket.y > 128 then 
		rocket.y = 0
	elseif rocket.y < 0 then
		rocket.y = 128
	end
	dx = rocket.x - target.x
	dy = rocket.y - target.y
	turn()
	--[[rocket.rotation = atan2(dx,dy)--]]
	rocket.x -= cos(rocket.rotation)
	rocket.y -= sin(rocket.rotation)
		
	circfill(target.x,target.y,2,7)
	draw_rocket(rocket.length,rocket.x,rocket.y,rocket.rotation)
end

__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
