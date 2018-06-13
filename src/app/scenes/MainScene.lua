local CardScene=require("app.scenes.CardScene")
local MainScene = class("MainScene", function()
    return display.newScene("MainScene")
end)

function MainScene:ctor()
    
self.cardscene = CardScene.new():addTo(self);
    
end

function MainScene:onEnter()
end

function MainScene:onExit()
end

return MainScene
