pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
a = {
	x = 32,
	y = 32,
	col = 12
}

b = {
	x = 100,
	y = 100,
	col = 14
}
				
c = {
	x = 64,
	y = 64,
	col = 2,
	r = 10
}
				
ac = {
	x = 0,
	y = 0
}
					
lindir = {
	x = 0,
	y = 0
}

proj = {
	x = 0,
	y = 0
	}
							
clos = {
	x = 0,
	y = 0
	}

function length(p1,p2)
	lx = p2.x - p1.x
	ly = p2.y - p1.y
	
	return sqrt(lx*lx + ly*ly)
		
end
															

function move(n,spd)
	
	if btn (0) then
			n.x -= spd
	end
	
	if btn (1) then
			n.x += spd
	end
	
	if btn (2) then
			n.y -= spd
	end
		
		if btn (3) then
				n.y += spd
		end
		
end

function normalize(p1,p2)

	dx = p2.x - p1.x
	dy = p2.y - p1.y		
	len = sqrt(dx*dx + dy*dy)		
	nx = dx/len		
	ny = dy/len
	
	return dx/len, dy/len
	
end

function dot(p1,p2)

	return(p1.x*p2.x + p1.y*p2.y)

end		

function _update()

	move(c,1)
	
	lindir.x, lindir.y = normalize(a,b)
	ac.x = c.x-a.x 
	ac.y = c.y-a.y 
	dist = dot(ac,lindir)
	
	if dist < 0 then
			dist = 0
	end
	
	if dist > length(a,b) then
			dist = length(a,b)
	end		
		
	proj.x = lindir.x * dist
	proj.y = lindir.y * dist
	clos.x = a.x + proj.x
	clos.y = a.y + proj.y
	
	
	 
	
		
end

function _draw()
	cls(1)

	circ(a.x, a.y ,5 ,a.col)
	print("a", a.x, a.y, a.col)
	
	circ(b.x, b.y ,5 ,b.col)
	print("b", b.x, b.y, b.col)
	
	circ(c.x, c.y ,c.r ,c.col)
	print("c", c.x, c.y, c.col)
	
	pset(clos.x, clos.y, 15)
	line(a.x,a.y,b.x,b.y,4)
	line(a.x,a.y,c.x,c.y,7)
	if length(c,clos) < c.r then
			print("hit!")
	end
		
end
__gfx__
00000000007770000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000777770000bbbb0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700077077700b77b77000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000070070700b7cb7c000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000077777700bbbbbb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700077777000bbbbbb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000777000bbbbbb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000007070700b0b0b0b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
