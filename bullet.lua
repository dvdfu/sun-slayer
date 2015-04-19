Bullet = Class('Bullet')

Bullet.static.sprite = love.graphics.newImage('img/water.png')

function Bullet:initialize(x, y, angle)
	self.x, self.y = x, y
	self.w, self.h = 16, 16
	self.angle = angle
	self.speed = 16
end

function Bullet:update(dt)
	self.x = self.x + self.speed*math.cos(self.angle - math.pi/2)
	self.y = self.y + self.speed*math.sin(self.angle - math.pi/2)
end

function Bullet:draw()
	love.graphics.draw(Bullet.static.sprite, self.x, self.y, self.angle, 1, 1, self.w/2, self.h/2)
end

return Bullet