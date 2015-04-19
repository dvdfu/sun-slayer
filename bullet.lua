Timer = require 'lib.timer'

Bullet = Class('Bullet')

Bullet.static.sprite = love.graphics.newImage('img/water.png')

function Bullet:initialize(x, y, angle)
	self.x, self.y = x, y
	self.grav = 0
	self.w, self.h = 16, 16
	self.angle = angle
	self.speed = 16
	self.dead = false
	self.deadTimer = 0

	self.spout = love.graphics.newParticleSystem(part, 5000)
	self.spout:setParticleLifetime(0.05, 0.1)
	self.spout:setColors(128, 255, 255, 255, 0, 128, 255, 255)
	self.spout:setSizes(1.5, 0.5)
	self.spout:setEmissionRate(20)
end

function Bullet:update(dt)
	self.deadTimer = self.deadTimer + dt
	self.spout:update(dt)
	self.spout:setPosition(self.x, self.y)

	self.grav = self.grav + 0.1
	self.x = self.x + self.speed*math.cos(self.angle - math.pi/2)
	self.y = self.y + self.speed*math.sin(self.angle - math.pi/2) + self.grav

	if self.y > 0 or self.deadTimer > 3 then
		self.dead = true
	end
end

function Bullet:draw()
	love.graphics.draw(self.spout)
	love.graphics.draw(Bullet.static.sprite, self.x, self.y, self.angle, 1, 1, self.w/2, self.h/2)
end

return Bullet