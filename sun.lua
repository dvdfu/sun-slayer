Timer = require 'lib.timer'
Fireball = require 'fireball'

Sun = Class('Sun')

function Sun:initialize()
	self.sprite = love.graphics.newImage('img/sun.png')
	self.x, self.y = 600, -2400
	self.size = 160
	self.r = 640

	self.fireballs = {}
	self.fireballTimer = Timer.new()
	self.fireballReady = true

	self.fire = love.graphics.newParticleSystem(part, 5000)
	self.fire:setParticleLifetime(0.6, 0.6)
	self.fire:setSpeed(50, 200)
	self.fire:setSpread(math.pi*2)
	self.fire:setColors(255, 255, 0, 255, 255, 128, 0, 255)
	self.fire:setSizes(2, 1)
	self.fire:setEmissionRate(400)
	self.fire:setPosition(self.x, self.y)

	self.explosion = love.graphics.newParticleSystem(part, 5000)
	self.explosion:setParticleLifetime(0.1, 0.6)
	self.explosion:setSpeed(100, 700)
	self.explosion:setLinearAcceleration(0, 500, 0, 500)
	self.explosion:setSpread(math.pi*2)
	self.explosion:setColors(255, 255, 0, 255, 255, 128, 0, 255, 255, 0, 0, 255, 40, 40, 40, 255)
	self.explosion:setSizes(8, 0)

	self.trail = love.graphics.newParticleSystem(part, 5000)
	self.trail:setParticleLifetime(0.1, 0.6)
	self.trail:setSpeed(200, 400)
	self.trail:setSpread(math.pi/12)
	self.trail:setColors(255, 255, 0, 255, 255, 128, 0, 255, 255, 0, 0, 255, 40, 40, 40, 255)
	self.trail:setSizes(14, 2)
end

function Sun:update(dt)
	self.fireballTimer.update(dt)
	self.fire:update(dt)
	self.explosion:update(dt)
	self.trail:update(dt)

	for i, fireball in pairs(self.fireballs) do
		fireball:update(dt)
		self.trail:setPosition(fireball.x, fireball.y)
		self.trail:setDirection(fireball.angle + math.pi)
		self.trail:emit(1)

		if fireball.dead then
			table.remove(self.fireballs, i)
			self.explosion:setPosition(fireball.x, fireball.y)
			self.explosion:emit(300)
		end
	end

	local dx, dy = self.x - hydrant.x, self.y - hydrant.y
	local dist = math.sqrt(dx*dx + dy*dy)

	if dist < self.r/2 + 16 and not hydrant.dead then
		hydrant:explode()
	end
	if dist < 1000 then
		if self.fireballReady then
			local fireball = Fireball:new(self.x, self.y, self.r/8)
			table.insert(self.fireballs, fireball)
			self.fireballReady = false
			self.fireballTimer.add(3, function()
				self.fireballReady = true
			end)
		end
	end
end

function Sun:draw()
	-- love.graphics.draw(self.fire)
	love.graphics.draw(self.trail)
	
	for _, fireball in pairs(self.fireballs) do
		fireball:draw()
	end

	love.graphics.draw(self.sprite, self.x, self.y, 0, self.r/self.size, self.r/self.size, self.size/2, self.size/2)
	love.graphics.draw(self.explosion)
end

return Sun
