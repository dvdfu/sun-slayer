Vector = require 'lib.vector'

Moon = Class('Moon')

function Moon:initialize()
	self.sprite = love.graphics.newImage('img/moon.png')
	self.x, self.y = -400, -1600
	self.vx, self.vy = 0, 0
	self.size = 80
	self.r = 240
	self.dead = false
end

function Moon:update(dt)
	local delta = Vector(hydrant.x - self.x, hydrant.y - self.y)
	if delta:len() < self.r/2 + 16 then
		local landx, landy = (delta:normalized()*(self.r/2 + 16)):unpack()
		hydrant.x, hydrant.y = self.x + landx, self.y + landy
		if love.keyboard.isDown('up') then
			hydrant.vx, hydrant.vy = -hydrant.vx*1, -hydrant.vy*1
			return
		end
		hydrant.onMoon = true
		hydrant.angle = math.atan2(landy, landx) + math.pi/2
		hydrant.vx, hydrant.vy = 0, 0
	end

	if self.y + self.r/2 > 0 then
		self.y = -self.r/2
		self.vy = -self.vy
	end

	self.vx, self.vy = self.vx*0.98, self.vy*0.98
	self.x, self.y = self.x + self.vx, self.y + self.vy
end

function Moon:draw()
	love.graphics.draw(self.sprite, self.x, self.y, 0, self.r/self.size, self.r/self.size, self.size/2, self.size/2)
end

return Moon