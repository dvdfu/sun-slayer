Timer = require 'lib.timer'

Bullet = Class('Bullet')

Bullet.static.sprite = love.graphics.newImage('img/water.png')
Bullet.static.part = love.graphics.newImage('img/part.png')

function Bullet:initialize(x, y, angle)
	self.x, self.y = x, y
	self.w, self.h = 16, 16
	self.angle = angle
	self.speed = 16
	self.dead = false
	self.deadTimer = Timer.new()
	self.deadTimer.add(1, function()
		self.dead = true
	end)

	self.spout = love.graphics.newParticleSystem(Bullet.static.part, 5000)
	self.spout:setParticleLifetime(0.2, 0.3)
	-- self.spout:setLinearAcceleration(0, 500, 0, 500)
	self.spout:setColors(128, 255, 255, 255, 0, 128, 255, 255)
	self.spout:setSizes(1.5, 0.5)
	self.spout:setEmissionRate(20)
end

function Bullet:update(dt)
	self.deadTimer.update(dt)
	self.spout:update(dt)
	self.spout:setPosition(self.x, self.y)

	self.x = self.x + self.speed*math.cos(self.angle - math.pi/2)
	self.y = self.y + self.speed*math.sin(self.angle - math.pi/2)
	if self.y > 0 then
		self.dead = true
	end
end

function Bullet:draw()
	love.graphics.draw(self.spout)
	love.graphics.draw(Bullet.static.sprite, self.x, self.y, self.angle, 1, 1, self.w/2, self.h/2)
end

return Bullet