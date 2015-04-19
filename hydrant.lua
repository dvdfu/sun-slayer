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
	self.hitSound = love.audio.newSource("aud/hit.wav")
end

function Hydrant:update(dt)
	self.shootTimer.update(dt)
	self.respawnTimer.update(dt)
	for i, bullet in pairs(self.bullets) do
		bullet:update(dt)
		if bullet.dead then
			table.remove(self.bullets, i)
			if bullet.deadTimer < 2 then
				self.blast:setPosition(bullet.x, bullet.y)
				self.blast:emit(4)
				self.hitSound:stop()
				self.hitSound:play()
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

	if love.keyboard.isDown('up') then
		if self.water > 2 then
			self.water = self.water - 2
			self.spout:emit(5)
			self.vx = self.vx + (self.speed*math.cos(self.angle - math.pi/2) - self.vx)*0.1
			self.vy = self.vy + (self.speed*math.sin(self.angle - math.pi/2) - self.vy)*0.1
			self.flySound:play()
			self.onMoon = false
		else
			self.water = 0
			self.vy = self.vy + 0.1
		end
	elseif not self.onMoon then
		self.vy = self.vy + 0.1
	end

	if self.onMoon then
		if self.water + 19 < self.waterMax then
			self.water = self.water + 19
		else
			self.water = self.waterMax
		end
	else
		if love.keyboard.isDown('left') then
			self.angle = self.angle - 0.05
		elseif love.keyboard.isDown('right') then
			self.angle = self.angle + 0.05
		end
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
		if self.water + 19 < self.waterMax then
			self.water = self.water + 19
		else
			self.water = self.waterMax
		end
	end

	if love.keyboard.isDown('a') and not self.dead and self.y < -self.h then
		if self.canShoot then
			if self.water > 9 then
				d = Vector(0, -self.h/2)
				d:rotate_inplace(self.angle)
				local bullet = Bullet:new(self.x + d.x, self.y + d.y, self.angle + (math.random() - 0.5)*0.1)
				table.insert(self.bullets, bullet)
				
				self.water = self.water - 9
				self.shootSound:stop()
				self.shootSound:play()
				self.canShoot = false
				self.shootTimer.add(0.1, function()
					self.canShoot = true
				end)
			else
				self.water = 0
			end
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
	self.onMoon = false
end

return Hydrant