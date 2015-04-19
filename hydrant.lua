Vector = require 'lib.vector'
Timer = require 'lib.timer'
Bullet = require 'bullet'

Hydrant = Class('Hydrant')

function Hydrant:initialize()
	self.bullets = {}
	self.canShoot = true
	self.shootTimer = Timer.new()
	self.respawnTimer = Timer.new()
	self.waterMax = 2000
	self:reset()

	self.sprite = love.graphics.newImage('img/hydrant.png')
	self.indicator = love.graphics.newImage('img/indicator.png')

	local part = love.graphics.newImage('img/part.png')
	self.spout = love.graphics.newParticleSystem(part, 5000)
	self.spout:setAreaSpread('normal', 0.5, 0.5)
	self.spout:setParticleLifetime(0.1, 0.2)
	self.spout:setSpread(math.pi/3)
	self.spout:setLinearAcceleration(0, 500, 0, 500)
	self.spout:setColors(128, 255, 255, 255, 0, 128, 255, 255)
	self.spout:setSizes(2, 0)
	self.spout:setSpeed(50, 200)

	self.blast = love.graphics.newParticleSystem(part, 5000)
	self.blast:setParticleLifetime(0.1, 1.5)
	self.blast:setSpeed(100, 400)
	self.blast:setSpread(math.pi * 2)
	self.blast:setLinearAcceleration(0, 500, 0, 500)
	self.blast:setColors(128, 255, 255, 255, 0, 128, 255, 255)
	self.blast:setSizes(2, 0)
	self.blast:setSizeVariation(1)

	self.shootSound = love.audio.newSource("aud/shoot.wav")
	self.flySound = love.audio.newSource("aud/fly.wav")
	self.explodeSound = love.audio.newSource("aud/explode.wav")
end

function Hydrant:update(dt)
	self.shootTimer.update(dt)
	self.respawnTimer.update(dt)
	for i, bullet in pairs(self.bullets) do
		bullet:update(dt)
		if bullet.dead then
			table.remove(self.bullets, i)
			if bullet.deadTimer < 3 then
				self.blast:setPosition(bullet.x, bullet.y)
				self.blast:emit(4)
			end
		end
	end
	self.spout:update(dt)
	self.blast:update(dt)

	if self.dead then return end

	local d = Vector(0, self.h/2)
	d:rotate_inplace(self.angle)
	self.spout:setPosition(self.x + d.x, self.y + d.y)
	self.spout:setDirection(math.pi/2 + self.angle)

	if love.keyboard.isDown('up') and self.water > 2 then
		self.water = self.water - 2
		self.spout:emit(5)
		self.vx = self.vx + (self.speed*math.cos(self.angle - math.pi/2) - self.vx)*0.1
		self.vy = self.vy + (self.speed*math.sin(self.angle - math.pi/2) - self.vy)*0.1
		self.flySound:play()
	else 
		self.vy = self.vy + 0.1
	end

	if love.keyboard.isDown('left') then
		self.angle = self.angle - 0.05
	elseif love.keyboard.isDown('right') then
		self.angle = self.angle + 0.05
		-- d = Vector(-self.w/2, 5)
		-- d:rotate_inplace(self.angle)
		-- self.spout:setPosition(self.x + d.x, self.y + d.y)
		-- self.spout:setDirection(math.pi + self.angle)
		-- self.spout:setSpeed(700, 1000)
		-- self.spout:emit(1)
	end
	self.x, self.y = self.x + self.vx, self.y + self.vy

	if self.y + self.h/2 + self.vy > 0 then
		if love.keyboard.isDown('up') or self.vy > 8 then
			self:explode()
			return
		end
		self.y = -self.h/2
		self.vx = self.vx*0.95
		self.vy = 0
		self.angle = 0
		if self.water + 20 < self.waterMax then
			self.water = self.water + 20
		else
			self.water = self.waterMax
		end
	end

	if love.keyboard.isDown('a') and not self.dead and self.y < -self.h then
		if self.canShoot and self.water > 10 then
			d = Vector(0, -self.h/2)
			d:rotate_inplace(self.angle)
			local bullet = Bullet:new(self.x + d.x, self.y + d.y, self.angle + (math.random() - 0.5)*0.1)
			table.insert(self.bullets, bullet)
			
			self.water = self.water - 10
			self.shootSound:stop()
			self.shootSound:play()
			self.canShoot = false
			self.shootTimer.add(0.1, function()
				self.canShoot = true
			end)
		end
	end
end

function Hydrant:draw()
	love.graphics.draw(self.spout)
	love.graphics.draw(self.blast)
	for _, bullet in pairs(self.bullets) do
		bullet:draw()
	end
	if not self.dead then
		love.graphics.draw(self.sprite, self.x, self.y, self.angle, 1, 1, self.w/2, self.h/2)
	end
end

function Hydrant:drawUI()
	local sw, sh = love.graphics.getWidth(), love.graphics.getHeight()

	love.graphics.setColor(128, 255, 255)
	love.graphics.rectangle('fill', 16, 16, 100*self.water/self.waterMax, 8)
	love.graphics.rectangle('line', 16, 16, 100, 8)
	love.graphics.setColor(255, 255, 255)

	local dx, dy = self.x - sun.x, self.y - sun.y
	local dist = math.sqrt(dx*dx + dy*dy) - sun.r
	if dist > 300 then
		local angle = math.atan2(dy, dx)
		love.graphics.draw(self.indicator, sw/2 - 100*math.cos(angle), sh/2 - 100*math.sin(angle), angle - math.pi/2, 1, 1, 8, 8)
	end
end

function Hydrant:explode()
	self.blast:setPosition(self.x, self.y)
	self.blast:emit(10 + self.water/3)
	self.dead = true
	self.water = 0
	self.explodeSound:play()
	self.respawnTimer.add(2.5, function()
		self:reset()
	end)
end

function Hydrant:reset()
	self.dead = false
	self.water = self.waterMax
	self.w, self.h = 24, 32
	self.x, self.y = 0, -self.h/2
	self.vx, self.vy = 0, 0
	self.speed = 8
	self.angle = 0
end

return Hydrant