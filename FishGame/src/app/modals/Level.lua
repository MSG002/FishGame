--
-- Author: sxw7
-- Date: 2015-04-27 12:03:45
--

local Level = class("Level")

function Level:ctor(  )
	self._watermelon = {} -- 西瓜
	self._apple = {}    -- 苹果
	self._strawberry = {} -- 草莓
	self._candy = {}  -- 糖果
	self._mushroom = {} -- 蘑菇

	self:init()
end

function Level:init(  )
	print("Level:init succeed...")
end

function Level:setLevelName( name )
	self._levelName = name
end
function Level:getLevelName(  )
	return self._levelName
end

function Level:setLevelNumber(num)
	self._levelNumber = num
	--print("setLevelNumber" .. num)
end
function Level:getLevelNumber(  )
	return self._levelNumber
end

function Level:setUnlock(unlock)
	self._unlock = unlock
	--print("setUnlock" .. unlock)
end
function Level:getUnlock(  )
	return self._unlock
end

function Level:setTime( time )
	self._time = time
end
function Level:getTime(  )
	return self._time
end

function Level:setStarNumber( starNumber )
	self._starNumber = starNumber
	--print("setStarNumber >> " .. starNumber)
end
function Level:getStarNumber(  )
	return self._starNumber
end

function Level:setTargetScore( targetScore )
	self._targetScore = targetScore
end
function Level:getTargetScore(  )
	return self._targetScore
end

function Level:setHighScore( hscore )
	self._highScore = hscore
end
function Level:getHighScore(  )
	return self._highScore
end

function Level:setWatermelon( score, num )
	self._watermelon.score = score
	self._watermelon.number = num
end
function Level:getWatermelon( )
	return self._watermelon
end

function Level:setApple( score, num )
	self._apple.score = score
	self._apple.number = num
end
function Level:getApple(  )
	return self._apple
end

function Level:setStrawberry( score, num )
	self._strawberry.score = score;
	self._strawberry.number = num
end
function Level:getStrawberry(  )
	return self._strawberry
end

function Level:setCandy( score, num )
	self._candy.score = score
	self._candy.number = num
end
function Level:getCandy(  )
	return self._candy
end

function Level:setMushroom( score, num )	
	self._mushroom.score = score
	self._mushroom.number = num
end
function Level:getMushroom( )
	return self._mushroom
end

function Level:description(  ) -- 输出关卡信息函数
	print("关卡信息：" .. '\n'
		.. "levelName:" .. self._levelName .. '\n'
		.. "level:" .. self:getLevelNumber() .. '\n'
        .. "unlock:" .. self:getUnlock() .. '\n'
		.. "starNumber:" .. self:getStarNumber() .. '\n'
		.. "highScore:" .. self._highScore .. '\n'
		.. "stargetScore:" .. self:getTargetScore() .. '\n'
		.. "watermelon:" .. self:getWatermelon().score .. "  " .. self:getWatermelon().number .. '\n'
		.. "apple:" .. self:getApple().score .. " " .. self:getApple().number .. '\n'
		.. "strawberry:" .. self:getStrawberry().score .. " " .. self:getStrawberry().number .. '\n'
		.. "candy:" .. self:getCandy().score .. " " .. self:getCandy().number .. '\n'
		.. "mushroom:" .. self:getMushroom().score .. " " .. self:getMushroom().number)	
end

return Level
