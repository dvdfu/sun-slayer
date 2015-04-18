Vector = require 'lib.vector'

Hydrant = Class('Hydrant')

function Hydrant:initialize()
	self.x, self.y = 0, 0
	self.vx, self.vy = 0, 0
	self.speed = 0
	self.w, self.h = 24*2, 32*2
	self.angle = 0
	self.va = 0
	self.sprite = love.graphics.newImage('img/hydrant.png')

	local spoutUp = love.graphics.newImage('img/spout.png')

	self.spoutUp = love.graphics.newParticleSystem(spoutUp, 1000)
	self.spoutUp:setAreaSpread('normal', 2, 2)
	self.spoutUp:setParticleLifetime(0.1, 0.5)
	self.spoutUp:setSpeed(400, 600)
	self.spoutUp:setLinearAcceleration(0, 1000, 0, 1000)
	self.spoutUp:setColors(0, 255, 255, 255, 0, 255, 255, 0)
	self.spoutUp:setSizes(1, 0.5)
end

function Hydrant:update(dt)
	self.spoutUp:update(dt)

	local d = Vector(0, self.h/2)
	d:rotate_inplace(self.angle)
	self.spoutUp:setSpread(math.pi / 6)
	self.spoutUp:setPosition(self.x + d.x, self.y + d.y)
	self.spoutUp:setDirection(math.pi/2 + self.angle)

	if love.keyboard.isDown('up') then
		self.spoutUp:emit(20)
		if self.speed < 8 then
			self.speed = self.speed + 0.1
		else
			self.speed = 8
		end
	else
		if self.speed > 0.02 then
			self.speed = self.speed - 0.02
		elseif self.speed < -0.02 then
			self.speed = self.speed + 0.02
		else
			self.speed = 0
		end
	end

	if love.keyboard.isDown('left') then
		if self.va > -0.1 then
			self.va = self.va - 0.005
		else
			self.va = -0.1
		end

		d = Vector(self.w/2, -10)
		d:rotate_inplace(self.angle)
		self.spoutUp:setSpread(math.pi / 24)
		self.spoutUp:setPosition(self.x + d.x, self.y + d.y)
		self.spoutUp:setDirection(0 + self.angle)
		self.spoutUp:emit(20)
	elseif love.keyboard.isDown('right') then
		if self.va < 0.1 then
			self.va = self.va + 0.005
		else
			self.va = 0.1
		end

		d = Vector(-self.w/2, -10)
		d:rotate_inplace(self.angle)
		self.spoutUp:setSpread(math.pi / 24)
		self.spoutUp:setPosition(self.x + d.x, self.y + d.y)
		self.spoutUp:setDirection(math.pi + self.angle)
		self.spoutUp:emit(20)
	else
		if self.va > 0.005 then
			self.va = self.va - 0.005
		elseif self.va < -0.005 then
			self.va = self.va + 0.005
		else
			self.va = 0
		end
	end

	-- if self.x + self.w/2 > love.window.getWidth() then
	-- 	self.x = love.window.getWidth() - self.w/2
	-- 	self.angle = -self.angle
	-- elseif self.x - self.w/2 < 0 then
	-- 	self.x = self.w/2
	-- 	self.angle = -self.angle
	-- end

	-- if self.y + self.h/2 > love.window.getHeight() then
	-- 	self.y = love.window.getHeight() - self.h/2
	-- 	self.angle = math.pi - self.angle
	-- elseif self.y - self.h/2 < 0 then
	-- 	self.y = self.h/2
	-- 	self.angle = math.pi - self.angle
	-- end

	self.angle = self.angle + self.va
	self.vx = self.speed*math.cos(self.angle - math.pi/2)
	self.vy = self.speed*math.sin(self.angle - math.pi/2)
	self.x, self.y = self.x + self.vx, self.y + self.vy
end

function Hydrant:draw(dt)
	love.graphics.draw(self.sprite, self.x, self.y, self.angle, 2, 2, self.w/4, self.h/4)
	love.graphics.draw(self.spoutUp)
end

return Hydrant