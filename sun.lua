Sun = Class('Sun')

function Sun:initialize()
	self.sprite = love.graphics.newImage('img/sun.png')
	self.x, self.y = 0, -500
	self.w, self.h = 160, 160

	local part = love.graphics.newImage('img/part.png')
	self.fire = love.graphics.newParticleSystem(part, 5000)
	-- self.fire:setAreaSpread('normal', self.w/2, self.h/2)
	self.fire:setParticleLifetime(0.6, 0.6)
	self.fire:setSpeed(50, 200)
	self.fire:setSpread(math.pi*2)
	self.fire:setColors(255, 255, 0, 255, 255, 128, 0, 255)
	self.fire:setSizes(2, 1)
	self.fire:setEmissionRate(400)
	self.fire:setPosition(self.x, self.y)
end

function Sun:update(dt)
	self.fire:update(dt)
end

function Sun:draw()
	love.graphics.draw(self.sprite, self.x - self.w/2, self.y - self.h/2)

	love.graphics.setBlendMode('additive')
	love.graphics.draw(self.fire)
	love.graphics.setBlendMode('alpha')
end

return Sun