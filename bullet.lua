Timer = require 'lib.timer'

Bullet = Class('Bullet')

Bullet.static.sprite = love.graphics.newImage('img/water.png')

function Bullet:initialize(x, y, angle)
	self.x, self.y = x, y
	self.vx, self.vx = 0, 0
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
	self.vx, self.vy = self.speed*math.cos(self.angle - math.pi/2), self.speed*math.sin(self.angle - math.pi/2) + self.grav
	self.x, self.y = self.x + self.vx, self.y + self.vy 

	local delta = Vector(sun.x - self.x, sun.y - self.y)
	if delta:len() < sun.r/2 and not self.dead then
		self.dead = true
		sun.hits = sun.hits + 1
	end

	delta = Vector(moon.x - self.x, moon.y - self.y)
	if delta:len() < moon.r/2 and not self.dead then
		moon.vx, moon.vy = moon.vx + self.vx/10, moon.vy + self.vy/10
		moon.vx, moon.vy = math.min(moon.vx, 12), math.min(moon.vy, 12)
		self.dead = true
	end

	for i, fireball in pairs(sun.fireballs) do
		local delta = Vector(fireball.x - self.x, fireball.y - self.y)
		if delta:len() < fireball.r/2 and not self.dead then
			self.dead = true
			fireball.hp = fireball.hp - 1
			fireball.hit = true
			if fireball.hp == 0 then
				fireball.dead = true
			end
		end
	end

	if self.y > 0 or self.deadTimer > 2 then
		self.dead = true
	end
end

function Bullet:draw()
	love.graphics.draw(self.spout)
	love.graphics.draw(Bullet.static.sprite, self.x, self.y, self.angle, 1, 1, self.w/2, self.h/2)
end

return Bullet