--
-- Author: sxw7
-- Date: 2015-04-27 12:03:38
--
--module("DataManager", package.seeall)



local DataManager = class("DataManager")

-- _levels 用于对数据的操作
DataManager._levels = {}
-- 用户选择的关卡
--DataManager._currentLevel =

function DataManager:ctor(  )
	self:init()
end

function DataManager:init(  )
	print("DataManager:init succeed")
	-- _dataTb 用于数据存储，私有
	self._dataTb =  self:readData()
	--print(self._dataTb)
	
	for k,v in pairs(self._dataTb) do
		--print(k,v)
		--local ltb = {}

		local alevel = Level:new()
		    alevel:setLevelName(k)
		  	alevel:setLevelNumber(v.LevelNumber)
	      	alevel:setUnlock(v.Unlock)
			alevel:setStarNumber(v.StarNumber)
			alevel:setHighScore(v.HighScore)
			alevel:setTargetScore(v.TargetScore)
			alevel:setWatermelon(v.Watermelon.Score, v.Watermelon.Count)
			alevel:setApple(v.Apple.Score, v.Apple.Count)
			alevel:setStrawberry(v.Strawberry.Score, v.Strawberry.Count)
			alevel:setCandy(v.Candy.Score, v.Candy.Count)
			alevel:setMushroom(v.Mushroom.Score, v.Mushroom.Count)

		DataManager._levels[v.LevelNumber] = alevel
	    --table.insert(self._levels, alevel)

	end

	-- test
	self:setLevelStarNumber(1, 3)
	self:setLevelUnlock(2, 1)

end

-- 关卡设置接口，当选择了一个关卡后，需要设置_currentLevel
function DataManager:setCurrentLevel(levelNumber )
	DataManager._currentLevel = DataManager._levels[levelNumber]
end
-- 获取当前关卡， 当进入游戏界面后，需要根据根据_currentLevel设置界面
function DataManager:getCurrentLevel(  )
	return DataManager._currentLevel
end

-- 根据LevelNumber获取Level对象
function DataManager:getLevel( levelNumber )
	return DataManager._levels[levelNumber]
end


-- 设置某个关卡获得的星星个数,
function DataManager:setLevelStarNumber( level, stars )
	-- 设置_levels数组里面的stars
	local alevel = DataManager._levels[level]
	      alevel:setStarNumber(stars)
	-- 设置 _dataTb 表里面的 StarNumber
	self._dataTb[alevel:getLevelName()]["StarNumber"] = stars
end

-- 设置某个关卡是否解锁， 1为解锁，0为未解锁
function DataManager:setLevelUnlock( level, unlock )
	local alevel = DataManager._levels[level]
	      alevel:setUnlock(unlock)
	self._dataTb[alevel:getLevelName()].Unlock = unlock
end


-- 从文件读取数据，私有
function DataManager:readData(  )
	print("readData()")
	local fileUtils = cc.FileUtils:getInstance()
	local path = fileUtils:getWritablePath() .. "Levels.json"
	print("path" .. path)

	local dataTb
	local fStr 
	if fileUtils:isFileExist(path) == false then
		local fullPath = fileUtils:fullPathForFilename("res/files/Level_1.json")
		fStr = fileUtils:getStringFromFile(fullPath)
		local f = assert(io.open(path, 'w'))
		f:write(fStr)
		f:close()
		dataTb = json.decode(fStr)
	else
		fStr = fileUtils:getStringFromFile(path)
		dataTb = json.decode(fStr)
		
	end
	--print(fStr)
	return dataTb
end

-- 归档，数据存入文件，用于程序退出时调用
function DataManager:writeData(  )
	local fileUtils = cc.FileUtils:getInstance()
	local path = fileUtils:getWritablePath() .. "Levels.json"
	local str = json.encode(self._dataTb)
	local f = assert(io.open(path, 'w'))
	f:write(str)
	f:close()
end


return DataManager


