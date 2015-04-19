Timer = require 'lib.timer'
Fireball = require 'fireball'

Sun = Class('Sun')

function Sun:initialize()
	self.sprite = love.graphics.newImage('img/sun.png')
	self.x, self.y = 600, -1600
	self.size = 160
	self.r = 640

	self.fireballs = {}
	self.fireballTimer = Timer.new()
	self.fireballTimer.addPeriodic(5, function()
		local fireball = Fireball:new(self.x, self.y)
		table.insert(self.fireballs, fireball)
	end)

	local part = love.graphics.newImage('img/part.png')
	self.fire = love.graphics.newParticleSystem(part, 5000)
	self.fire:setParticleLifetime(0.6, 0.6)
	self.fire:setSpeed(50, 200)
	self.fire:setSpread(math.pi*2)
	self.fire:setColors(255, 255, 0, 255, 255, 128, 0, 255)
	self.fire:setSizes(2, 1)
	self.fire:setEmissionRate(400)
	self.fire:setPosition(self.x, self.y)
end

function Sun:update(dt)
	self.fireballTimer.update(dt)
	self.fire:update(dt)

	for i, fireball in pairs(self.fireballs) do
		fireball:update(dt)
		if fireball.dead then
			table.remove(self.fireballs, i)
		end
	end

	local dx, dy = self.x - hydrant.x, self.y - hydrant.y
	local dist = math.sqrt(dx*dx + dy*dy) - self.r/2

	if dist < 0 and not hydrant.dead then
		hydrant:explode()
	end
	for i, bullet in pairs(hydrant.bullets) do
		local dx, dy = self.x - bullet.x, self.y - bullet.y
		local dist = math.sqrt(dx*dx + dy*dy) - self.r/2
		if dist < 0 and not bullet.dead then
			bullet.dead = true
			self.r = self.r - 2
		end
	end
end

function Sun:draw()
	love.graphics.draw(self.sprite, self.x, self.y, 0, self.r/self.size, self.r/self.size, self.size/2, self.size/2)

	love.graphics.setBlendMode('additive')
	love.graphics.draw(self.fire)
	love.graphics.setBlendMode('alpha')

	for _, fireball in pairs(self.fireballs) do
		fireball:draw()
	end
end

return Sun
