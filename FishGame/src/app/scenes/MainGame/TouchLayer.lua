--
-- Author: Student
-- Date: 2015-04-29 10:22:34
--
local TouchLayer = class("TouchLayer", function (  )
	return display.newLayer()
end)

TouchLayer.TOUCH_MOVE= "TOUCH_MOVE"
TouchLayer.TOUCH_END = "TOUCH_END"

local TOUTCH_POINT_TAG = 100
local MAX_XULI_TIME    = 2
local DEFAULT_FORCE    = 10
local ADD_DEFAULT_FORCE= 200

function TouchLayer:ctor(  )
    cc.GameObject.extend(self):addComponent("components.behavior.EventProtocol"):exportMethods()

	--触摸时显示的虚拟按钮的图片
	self:initTouchNode()
	self:setContentSize(display.width*2,display.height)
	self:setTouchEnabled(true)
	self:addNodeEventListener(cc.NODE_TOUCH_EVENT,function ( event )
		return self:onTouch( event )
	end)
end



function TouchLayer:onTouch( event )
	local name = event.name
	local x = event.x
	local y = event.y
	
	if name == "began" then
		--水面以上不让点
		local convertTP = self:getParent().bg:convertToNodeSpace(cc.p(x,y))
		if convertTP.y > display.height then
			return false
		end
		--开始计算蓄力时间
		self.bTime = os.time()
		self.touchNode:setPosition(x,y)
		self.touchNode:setVisible(true)

		self.startPosition = cc.p(x,y)
		self.fisrtMove = true
		self.isAddForce = false
		return true

	elseif name == "moved" then
		--第一次移动之后，不再计算蓄力时间
		if self.fisrtMove then
			local eTime = os.difftime(os.time(), self.bTime)
			print(eTime)
			if eTime > MAX_XULI_TIME then
				eTime = MAX_XULI_TIME
			end
			if eTime < 0.3 then
				eTime = 0
				self.addForce = DEFAULT_FORCE
			else
				self.isAddForce = true
				self.addForce = ADD_DEFAULT_FORCE*(eTime+0.7)
			end
			self.fisrtMove = false
		end


		local subPoint = cc.pSub(cc.p(x,y), self.startPosition)	
		--计算旋转角度
		self.radian = cc.pToAngleSelf(subPoint)
		local rotationAngle = math.radian2angle(self.radian)
		--分发旋转移动事件
		self.eventFocre = cc.p(self.addForce*math.cos(self.radian),self.addForce*math.sin(self.radian))
		self:dispatchEvent({name = TouchLayer.TOUCH_MOVE,isAddForce = self.isAddForce,angle = rotationAngle,force = self.eventFocre})

		--修改触摸点的图片位置
		local touchPoint = self.touchNode:getChildByTag(TOUTCH_POINT_TAG)
		if cc.pGetLength(subPoint) < 20 then
			touchPoint:setPosition(self.touchNode:convertToNodeSpace(cc.p(x,y)))
		else
			local point = cc.pAdd(self.startPosition, cc.p(20*math.cos(self.radian),20*math.sin(self.radian))) 
			local cPoint = self.touchNode:convertToNodeSpace(point)
			touchPoint:setPosition(cPoint)
		end
		
	elseif name == "ended" then
		self.touchNode:getChildByTag(TOUTCH_POINT_TAG):pos(0, 0)
		self.touchNode:setVisible(false)

		--停止移动
		self:dispatchEvent({name = TouchLayer.TOUCH_END,isAddForce = self.isAddForce,force = self.eventFocre})
		
	elseif name == "cancelled" then

	end
end

function TouchLayer:initTouchNode(  )
	display.addSpriteFrames("UI.plist", "UI.png")

	self.touchNode = display.newNode():addTo(self)
	self.touchNode:setVisible(false)

	local nodeBG = display.newSprite("#JoyStick-base.png")
	self.touchNode:addChild(nodeBG)

	local point  = display.newSprite("#JoyStick-thumb.png")
	point:setTag(TOUTCH_POINT_TAG)
	self.touchNode:addChild(point)

end
-- function TouchLayer:(  )
	
-- end
-- function TouchLayer:(  )
	
-- end
-- function TouchLayer:(  )
	
-- end
-- function TouchLayer:(  )
	
-- end


return TouchLayer