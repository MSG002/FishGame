--
-- Author: sxw7
-- Date: 2015-04-27 11:54:29
--

local LoadingScene = class("LoadingScene", function (  )
	return display.newScene("LoadingScene");
end)

function LoadingScene:ctor(  )

	self:init()
end

function LoadingScene:init( )
	print("LoadingScene:init succeed...")



end

return LoadingScene
