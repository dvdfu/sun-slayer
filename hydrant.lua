Vector = require 'lib.vector'
Timer = require 'lib.timer'

Hydrant = Class('Hydrant')

function Hydrant:initialize()
	self.speedCap = 3
	self.angleCap = 0.08

	self:reset()

	self.sprite = love.graphics.newImage('img/hydrant.png')

	local part = love.graphics.newImage('img/part.png')
	self.spout = love.graphics.newParticleSystem(part, 5000)
	self.spout:setAreaSpread('normal', 0.5, 0.5)
	self.spout:setParticleLifetime(0.2, 0.3)
	self.spout:setSpeed(50, 200)
	self.spout:setSpread(math.pi/24)
	-- self.spout:setLinearAcceleration(0, 500, 0, 500)
	self.spout:setColors(128, 255, 255, 255, 0, 128, 255, 255)
	self.spout:setSizes(2, 0)

	self.blast = love.graphics.newParticleSystem(part, 5000)
	-- self.blast:setAreaSpread('normal', 0.5, 0.5)
	self.blast:setParticleLifetime(0.5, 3)
	self.blast:setSpeed(100, 400)
	self.blast:setSpread(math.pi * 2)
	self.blast:setLinearAcceleration(0, 500, 0, 500)
	self.blast:setColors(128, 255, 255, 255, 0, 128, 255, 255)
	self.blast:setSizes(2, 0)
	self.blast:setSizeVariation(1)
end

function Hydrant:update(dt)
	Timer.update(dt)
	self.spout:update(dt)
	self.blast:update(dt)

	if self.dead then return end

	local d = Vector(0, self.h/2)
	d:rotate_inplace(self.angle)
	self.spout:setPosition(self.x + d.x, self.y + d.y)
	self.spout:setDirection(math.pi/2 + self.angle)

	if self.vy < 8 then
		self.vy = self.vy + 0.1
	else
		self.vy = 8
	end

	if love.keyboard.isDown('up') then
		self.spout:emit(5)
		self.speed = 0.2
		local px, py = self.speed*math.cos(self.angle - math.pi/2), self.speed*math.sin(self.angle - math.pi/2)
		if px > 0 then
			if self.vx < 8 then
				self.vx = self.vx + px
			else
				self.vx = 8
			end
		elseif px < 0 then
			if self.vx > -8 then
				self.vx = self.vx + px
			else
				self.vx = -8
			end
		end
		if py > 0 then
			if self.vy < 8 then
				self.vy = self.vy + py
			else
				self.vy = 8
			end
		elseif py < 0 then
			if self.vy > -8 then
				self.vy = self.vy + py
			else
				self.vy = -8
			end
		end
	else
		self.speed = 0
	end

	if love.keyboard.isDown('left') then
		if self.va > -self.angleCap then
			self.va = self.va - 0.002
		else
			self.va = -self.angleCap
		end

		d = Vector(self.w/2, 5)
		d:rotate_inplace(self.angle)
		self.spout:setPosition(self.x + d.x, self.y + d.y)
		self.spout:setDirection(0 + self.angle)
		self.spout:emit(5)
	elseif love.keyboard.isDown('right') then
		if self.va < self.angleCap then
			self.va = self.va + 0.002
		else
			self.va = self.angleCap
		end

		d = Vector(-self.w/2, 5)
		d:rotate_inplace(self.angle)
		self.spout:setPosition(self.x + d.x, self.y + d.y)
		self.spout:setDirection(math.pi + self.angle)
		self.spout:emit(5)
	else
		if self.va > 0.005 then
			self.va = self.va - 0.005
		elseif self.va < -0.005 then
			self.va = self.va + 0.005
		else
			self.va = 0
		end
	end

	self.angle = self.angle + self.va
	self.x, self.y = self.x + self.vx, self.y + self.vy

	if self.y + self.h/3 + self.vy > 0 then
		self:explode()
	end

	function love.keypressed(key)
		if key == ' ' and not self.dead then
			self:explode()
		end
	end
end

function Hydrant:draw(dt)
	love.graphics.draw(self.spout)
	love.graphics.draw(self.blast)
	if not self.dead then
		love.graphics.draw(self.sprite, self.x, self.y, self.angle, 1, 1, self.w/2, self.h/2)
	end

	love.graphics.rectangle('fill', -1000, 0, 2000, 800)
end

function Hydrant:explode()
	self.blast:setPosition(self.x, self.y)
	self.blast:emit(200)
	self.dead = true
	Timer.add(2.5, function()
		self:reset()
	end)
end

function Hydrant:reset()
	self.dead = false
	self.w, self.h = 24, 32
	self.x, self.y = 0, -self.h/2
	self.vx, self.vy = 0, -8
	self.speed = 0
	self.angle = 0
	self.va = 0
end

return Hydrant