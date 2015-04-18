Hydrant = Class('Hydrant')

function Hydrant:initialize()
	self.x, self.y = 400, 0
	self.vx, self.vy = 0, 0
	self.w, self.h = 24*2, 32*2
	self.angle = 0
	self.sprite = love.graphics.newImage('img/hydrant.png')

	local spoutUp = love.graphics.newImage('img/spout.png')

	self.spoutUp = love.graphics.newParticleSystem(spoutUp, 1000)
	-- self.spoutUp:setAreaSpread('normal', 12, 6)
	self.spoutUp:setParticleLifetime(0.1, 0.3)
	self.spoutUp:setSpread(math.pi / 24)
	self.spoutUp:setSpeed(200, 500)
	-- self.spoutUp:setLinearAcceleration(0, 300, 0, 300)
	-- self.spoutUp:setColors(255, 0, 0, 255, 255, 120, 0, 255, 255, 200, 0, 255)
	-- self.spoutUp:setEmissionRate(400)
	-- self.spoutUp:setSizes(2, 1)
end

function Hydrant:update(dt)
	self.spoutUp:update(dt)

	if love.keyboard.isDown('up') then
		-- self.y = self.y - 2
		-- self.vy = -6

		self.spoutUp:setPosition(self.x, self.y + self.h/2)
		self.spoutUp:setDirection(math.pi / 2 + self.angle)
		self.spoutUp:emit(20)
	elseif love.keyboard.isDown('down') then
		self.y = self.y + 2
	end
	if love.keyboard.isDown('left') then
		self.angle = self.angle + 0.1
		self.spoutUp:setPosition(self.x + self.w/2, self.y + 12*2)
		self.spoutUp:setDirection(0 + self.angle)
		self.spoutUp:emit(20)
	elseif love.keyboard.isDown('right') then
		self.angle = self.angle - 0.1
		self.spoutUp:setPosition(self.x - self.w/2, self.y + 12*2)
		self.spoutUp:setDirection(math.pi + self.angle)
		self.spoutUp:emit(20)
	end

	self.vy = self.vy + 0.3
	self.y = self.y + self.vy

	if self.y + self.h + self.vy > groundLevel then
		self.vy = 0
		self.y = groundLevel - self.h
	end
end

function Hydrant:draw(dt)
	love.graphics.draw(self.sprite, self.x, self.y, self.angle, 2, 2, self.w/4, self.h/4)
	love.graphics.draw(self.spoutUp)
end

return Hydrant