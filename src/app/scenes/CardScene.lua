local CardScene=class("CardScene", function ()
     return display.newNode();
end)

function CardScene:ctor()
 self.node = cc.CSLoader:createNode("studio/GameLayer.csb");
    self:addChild(self.node);

    --获取人物
    self.play1 = self.node:getChildByName("Sprite1");
    self.play2 = self.node:getChildByName("Sprite2");
    self.my = self.node:getChildByName("Sprite3");

    --获取数字
    self.number1 = self.node:getChildByName("Text1");
    self.number2 = self.node:getChildByName("Text2");

    --获取按钮
    self.startbtn = self.node:getChildByName("Button1");
    self.sendbtn = self.node:getChildByName("Button2");
    self.notbtn = self.node:getChildByName("Button3");

    --获取牌
    for i=1,18 do
    	local card = self.node:getChildByTag(i);

  --   	local y = string.format("0%d.jpg",cards[i]);
		-- card:loadTexture(y);
    end
end

return CardScene