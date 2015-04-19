Vector = require 'lib.vector'

Fireball = Class('Fireball')

function Fireball:initialize(x, y)
	self.sprite = love.graphics.newImage('img/sun.png')
	self.x, self.y = x, y
	self.speed = 3
	self.r = 80
	self.dead = false
end

function Fireball:update(dt)
	local delta = Vector(hydrant.x - self.x, hydrant.y - self.y)
	if delta:len() - self.r < 0 and not hydrant.dead then
		hydrant:explode()
		self.dead = true
	end
	delta = delta:normalized() * self.speed
	self.x, self.y = self.x + delta.x, self.y + delta.y
end

function Fireball:draw()
	love.graphics.draw(self.sprite, self.x, self.y, 0, 1, 1, self.r/2, self.r/2)
end

return Fireball