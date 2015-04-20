Vector = require 'lib.vector'

Moon = Class('Moon')

function Moon:initialize()
	self.sprite = love.graphics.newImage('img/moon.png')
	self.x, self.y = -500, -1000
	self.vx, self.vy = 0, 0
	self.size = 80
	self.r = 240
	self.dead = false

	local trailSpr = love.graphics.newImage('img/moon-trail.png')
	self.trail = love.graphics.newParticleSystem(trailSpr, 50)
	self.trail:setParticleLifetime(0.7)

	self.trail:setColors(255, 255, 255, 255, 255, 255, 255, 0)
	self.trail:setSizes(3, 3.6)
	self.trail:setParticleLifetime(0.1, 0.3)
	self.trail:setSpeed(10, 100)
	self.trail:setSpread(math.pi*2)
	self.trail:setEmissionRate(20)
end

function Moon:update(dt)
	self.trail:setPosition(self.x, self.y)
	self.trail:update(dt)
	local delta = Vector(hydrant.x - self.x, hydrant.y - self.y)
	if delta:len() < self.r/2 + 16 then
		local landx, landy = (delta:normalized()*(self.r/2 + 16)):unpack()
		hydrant.x, hydrant.y = self.x + landx, self.y + landy
		if love.keyboard.isDown('up') or love.keyboard.isDown('a') then
			return
		end
		hydrant.vx, hydrant.vy = 0, 0
		hydrant.onMoon = true
		hydrant.angle = math.atan2(landy, landx) + math.pi/2
	end

	if self.y + self.r/2 > 0 then
		self.y = -self.r/2
		self.vy = -self.vy
	end

	self.vx, self.vy = self.vx*0.98, self.vy*0.98
	self.x, self.y = self.x + self.vx, self.y + self.vy
end

function Moon:draw()
	if self.dead then return end
	love.graphics.setBlendMode('additive')
	love.graphics.draw(self.trail)
	love.graphics.setBlendMode('alpha')

	love.graphics.draw(self.sprite, self.x, self.y, 0, self.r/self.size, self.r/self.size, self.size/2, self.size/2)
end

return Moon