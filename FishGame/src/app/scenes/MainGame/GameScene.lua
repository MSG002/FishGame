--
-- Author: sxw7
-- Date: 2015-04-27 11:55:16
--
local TouchLayer = require("app.scenes.TouchLayer")
local scheduler  = require(cc.PACKAGE_NAME..".scheduler")

local GameScene = class("GameScene", function (  )
	return display.newPhysicsScene("GameScene")
end)

local NORMAL_GRIVATY = -1000
local WATER_GRIVATY = -1 

local MISSILE_PNG = "buttlet4.png"
local PAUSE_BUTTON_PNG = "zanting.png"

function GameScene:ctor(  )

	--self.bg = display.newSprite("bg.png",display.cx,display.cy):addTo(self)
	self:initWorld()
	--self.drawnode = display.newDrawNode():align(display.BOTTOM_LEFT, 0,0 ):addTo(self)
	self:load()
	self:initFish()
	--物理碰撞检测
	self:collisionListener()
	--创建触摸层，注册监听
	local touchLayer = TouchLayer.new():align(display.BOTTOM_LEFT, 0, 0):addTo(self)
	touchLayer:addEventListener(TouchLayer.TOUCH_MOVE, handler(self, self.onMyTouchMove))
	touchLayer:addEventListener(TouchLayer.TOUCH_END, handler(self, self.onMyTouchEnd))

 	self:addNodeEventListener(cc.NODE_ENTER_FRAME_EVENT, handler(self, self.update))

end

--加载数据，加载csb文件，得到各种食物、分数标签等
function GameScene:load(  )

	display.addSpriteFrames("Fishall.plist", "Fishall.png")

	self.goldNumber   = 0
	self.zunshiNumber = 0
	self.currentScore = 0
	self.passScore    = 1--得到当前关卡的过关分数
	self.time 		  = 300--time
	self.missileTime  = 5--导弹出现时间间隔
	
	--加载背影
	local bglayer = cc.uiloader:load("BGLayer.csb"):addTo(self)
	self.bg = bglayer:getChildByName("bg_1")

	self.items = {}
	local x = 1
	while x <= 10 do
		self.items[x] = self.bg:getChildByTag(x)
		x = x+1
	end

	--添加气泡
	for i=1,2 do
		cc.ParticleSystemQuad:create("particle_sys_blister.plist")
			:pos(display.cx+50+display.width*(i-1), 0):addTo(self.bg)
	end
	

	--启动时间减少定时器
	self:schedule(handler(self, self.lostTime), 1)

	--启动导弹发射定时间器
	if self.missileTime ~= 0 then
		self:schedule(handler(self, self.launchMissile), self.missileTime)
	end
	--Label层
	local labelLayer = cc.uiloader:load("Layer.csb"):addTo(self)
	self.timeMin = labelLayer:getChildByName("timeMinute"):setString(string.format("%02d", math.floor(self.time/60.0)))
	self.timeSec = labelLayer:getChildByName("timeSecond"):setString(string.format("%02d", self.time%60))
	self.scoreNumber = labelLayer:getChildByName("scoreNumber")
	self.goldLabel = labelLayer:getChildByName("goldNumber"):setString(string.format("%d",self.goldNumber))
	self.zuanshiLabel = labelLayer:getChildByName("zunshiNumber")
	self.pasueBtn = labelLayer:getChildByName("Button_4")

	--self:addNodeEventListener(cc.NODE_ENTER_FRAME_EVENT,handler(self, self.update))
	self.sugHandle = scheduler.scheduleUpdateGlobal(handler(self, self.update))
end

function GameScene:onExit(  )
	scheduler.unscheduleGlobal(self.sugHandle)
end

function GameScene:initWorld(  )
	self.world = self:getPhysicsWorld()
	self.world:setGravity(cc.p(0,NORMAL_GRIVATY))
	--物理盒子
	local wallBody = cc.PhysicsBody:createEdgeBox(cc.size(display.width,display.height*2))
	local ground = display.newNode():pos(display.cx, display.height):addTo(self)
	ground:setPhysicsBody(wallBody)

	self.world:setDebugDrawMask(cc.PhysicsWorld.DEBUGDRAW_ALL)
end

function GameScene:initFish(  )
	self.fish = display.newSprite("#playFish1.png"):pos(display.cx, display.height-50):addTo(self)
	local frames = display.newFrames("playFish%d.png", 1, 24)
	local animation = display.newAnimation(frames, 2/24)
	self.fish:playAnimationForever(animation)

	self.fishBody = cc.PhysicsBody:createBox(self.fish:getContentSize())
	self.fishBody:getShape(0):setFriction(0.1)
	self.fishBody:getShape(0):setRestitution(0.1)
	self.fishBody:getShape(0):setMass(1)
	self.fish:setPhysicsBody(self.fishBody)

	-- local follow = cc.Follow:create(self.fish, cc.rect(-240, -160, 960, 640))
	-- self:runAction(follow)

end

function GameScene:collisionListener(  )
	--碰撞检测
	local function onContactBegin( contact )
		local node1 = contact:getShapeA():getBody():getNode()
		local node2 = contact:getShapeB():getBody():getNode()
	end

	local contactListener = cc.EventListenerPhysicsContact:create()
	contactListener:registerScriptHandler(onContactBegin,cc.Handler.EVENT_PHYSICS_CONTACT_BEGIN)
	local eventDispatcher = self:getEventDispatcher()
	eventDispatcher:addEventListenerWithSceneGraphPriority(contactListener, self)
	
end

function GameScene:update( dt )
	--鱼和其它物品的碰撞检测 self.fish:getCollisionRect()//提供魚的碰撞区域
	local fishX,fishY = self.fish:getPositionX(),self.fish:getPositionY()

	local fishbb = self.fish:getBoundingBox()
	local convertP = self.bg:convertToNodeSpace(cc.p(fishbb.x,fishbb.y))
	fishbb.x,fishbb.y = convertP.x,convertP.y

	--print(self.fishBody:getVelocity().x,self.fishBody:getVelocity().y)

	for i,item in ipairs(self.items) do
		--print(item:getBoundingBox().x)
		if cc.rectIntersectsRect(fishbb,item:getBoundingBox()) then
			print("cc.rectIntersectsRect(fishbb,item:getBoundingBox())")
			--播放音效
			if true then
				--audio.playSound("音效文件")
			end
			self:runAddMoenyAction(cc.p(fishX,fishY) , 100 )
			--self.currentScore = item:getScore() + self.currentScore
			item:removeSelf()
			table.remove(self.items,i)
		end
	end

	--导弹与鱼
	if self.missile and self.missile:isVisible() then
		if cc.rectIntersectsRect(fishbb,self.missile:getBoundingBox()) then
			--game over
			self.missile:setVisible(false)
		end
	end

	--改变水上水下重力
	if fishY > display.cx-80 then
		self.world:setGravity(cc.p(0,NORMAL_GRIVATY))
		self.fishBody:setVelocityLimit(500.0)
		--self.fishBody:resetForces()
		--self.drawnode:drawDot(cc.p(fishX,fishY), 1, display.COLOR_RED)
	else
		self.world:setGravity(cc.p(0,0))
		
		self.fishBody:setVelocityLimit(100.0)
	end
	--减速带
	if self.fishBody:getVelocity().y < 0 and fishY < display.cx - 80 and fishY > display.cx - 85 then
		print("--减速带")
		self.fishBody:setVelocity(cc.pMul(self.fishBody:getVelocity(),0.9))
	end

	if self.fishStartMove then
		self.fishBody:applyImpulse(self.force)
	end

	--出入水动画
	-- local waterLineSta,waterlineEnd = cc.p(display.left,display.height),cc.p(display.width*2,display.height)
	-- local fishLineSta,fishLineEnd   = self.fish:getFishLine()----提供鱼的对角线的两个端点
	-- if cc.pIsSegmentIntersect(waterLineSta,waterlineEnd,fishLineSta,fishLineEnd) then
	-- 	--播放音效
	-- 	if true then
	-- 		audio.playSound("音效文件")
	-- 	end

	-- 	if not self.waterAnimation then
	-- 		--水花动画资源
	-- 		local frams = display.newFrames("动画帧",1,10 )
	-- 		self.waterAnimation = display.newAnimation(frams, 1/10)
	-- 	end
	-- 	local ws = cc.pGetIntersectPoint(waterLineSta,waterlineEnd,fishLineSta,fishLineEnd)
	-- 	local waterSpr = display.newSprite():pos(ws.x,ws.y):addTo(self)
	-- 	waterSpr:playAnimationOnce(self.waterAnimation, true)
	-- end

	--移动背影
	if fishX >= (display.cx-240) and fishX <= (display.cx+240) then
		self.bg:pos( display.cx - (fishX-display.cx), self.bg:getPositionY())
	end
	if fishY >= (display.cy-160) and fishY <= (display.cy+160) then
		self.bg:pos( self.bg:getPositionX() , display.cy - (fishY-display.cy) )
	end

	--改变方向
	local fishV = self.fishBody:getVelocity()
	if self.angle and fishV.y < 0.1 and fishY > display.cy and (not self.isRotate) then
		self.isRotate = true
		print("angle ....")
		transition.rotateTo(self.fish, {time = 0.2,rotate = -self.angle+20,onComplete=function (  )
			transition.rotateTo(self.fish, {time = 1.0,rotate = 0 ,onComplete=function (  )
				self.isRotate = false
			end})
		end})
	end
end

function GameScene:onMyTouchMove( event )
	
	if event.angle > -90 and event.angle < 90 then
		self.fish:setFlippedX(true)
		self.fish:setRotation(-event.angle)
	else
		self.fish:setFlippedX(false)
		self.fish:setRotation(180-event.angle)
	end

	if not event.isAddForce then
		self.fishStartMove = true
		self.force = event.force
	end

end
function GameScene:onMyTouchEnd( event )
	print(event.isAddForce.."aaaaaaaaaaaaaaa")
	self.angle = self.fish:getRotation()
	if event.isAddForce then
		self.fishBody:applyImpulse(event.force)
		--self.fishBody:setVelocity(cc.p(event.force.x*4,event.force.y))
		--self.fishBody:applyForce(cc.p(event.force.x,event.force.y))
		print(event.force.x,event.force.y)
	else
		self.fishStartMove = false
		self.fishBody:setVelocity(cc.p(0,0))
	end
end

function GameScene:launchMissile(  )
	print("launchMissile()")
	if not self.missile then
		self.missile = display.newSprite(MISSILE_PNG):addTo(self.bg)
	end
	self.missile:setVisible(true)
	--默认导弹头向左
	self.missile:setFlippedX(true)

	local mWidth2 = self.missile:getContentSize().width/2
	local bgCon = self.bg:getContentSize()
	local x,y = bgCon.width + mWidth2 , math.random(bgCon.height/2,bgCon.height)
	local tox = -x
	if math.random(0,1) > 0.5 then
		self.missile:setFlippedX(false)
	 	x   = -mWidth2
	 	tox = -tox
	end

	self.missile:setPosition(x,y)
	transition.moveBy(self.missile, { time = self.missileTime-0.5,x = tox ,y = 0 ,onComplete = function (  )
		self.missile:setVisible(false)
	end})
end

function GameScene:lostTime(  )
	self.time = self.time - 1
	self.timeMin:setString(string.format("%02d", math.floor(self.time/60.0)))
	self.timeSec:setString(string.format("%02d", self.time%60))
	if self.time == 0 then
		if self.currentScore >= self.passScore then
			--过关
		else
			--失败
		end
	end
end

function GameScene:runAddMoenyAction( position , gold )

	--local goldx = display.newTTFLabel({text = "X1"})
	self.goldNumber = self.goldNumber + gold

	local money = display.newSprite("Cn19.png", position.x, position.y):addTo(self)
	money:setName("money")
	money:setScale(0.5)
	local jbSpawn = cca.spawn(cca.jumpBy(0.5, 0, 0, 20, 1),cca.blink(0.5, 5))
	local moveto = cca.moveTo(0.5, self.goldLabel:getPositionX(),self.goldLabel:getPositionY())
	local callback = cca.callFunc(handler(self, self.onAddMoney))
	money:runAction(cc.Sequence:create(jbSpawn,moveto,callback))
end

function GameScene:onAddMoney( target )
	target:removeSelf()
	self.goldLabel:setString(string.format("%d",self.goldNumber))
end

function GameScene:onPauseBtnClick( )
	print("pause")
end


return GameScene