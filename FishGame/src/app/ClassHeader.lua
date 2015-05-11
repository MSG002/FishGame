--
-- Author: sxw7
-- Date: 2015-04-28 10:24:48
-- 本类是用来包含文件，同时可以声明全局环境变量

-- modals
Level = require("app.modals.Level")
DataManager = require("app.modals.DataManager").new() --单例模式
AudioManager = require("app.modals.AudioManager").new() -- 单例模式


-- sprites

BaseSprite = require("app.sprites.BaseSprite")
Fish = require("app.sprites.Fish")
Food = require("app.sprites.Food")
Missile = require("app.sprites.Missile") -- 导弹



-- layers

-- gamelayers
MenuLayer = require("app.layers.gamelayers.MenuLayer")
OverLayer = require("app.layers.gamelayers.OverLayer")
PauseLayer = require("app.layers.gamelayers.PauseLayer")

-- shoppinglayers
ReminderLayer = require("app.layers.shoppinglayers.ReminderLayer")

-- startlayers
AboutLayer = require("app.layers.startlayers.AboutLayer")
HelpLayer = require("app.layers.startlayers.HelpLayer")
SettingLayer = require("app.layers.startlayers.SettingLayer")




-- scenes
LoadingScene = require("app.scenes.LoadingScene")
StartScene = require("app.scenes.StartScene")
LevelScene = require("app.scenes.LevelScene")
ShoppingScene = require("app.scenes.ShoppingScene")
GameScene = require("app.scenes.GameScene")











