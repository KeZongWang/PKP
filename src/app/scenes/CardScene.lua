-- local CardCreate=require("app.scenes.CardCreate")
local CardScene=class("CardScene", function ()
     return display.newNode();
end)

function CardScene:ctor()
	-- self.cardcreate = CardCreate.new():addTo(self);
    self.node1 = cc.CSLoader:createNode("studio/StartLayer.csb");
    self:addChild(self.node1);

    self.node = cc.CSLoader:createNode("studio/GameLayer.csb");
    self:addChild(self.node);
    self.node:setVisible(false);

    --获取人物
    self.play1 = self.node:getChildByName("Sprite1");
    self.play2 = self.node:getChildByName("Sprite2");
    self.my = self.node:getChildByName("Sprite3");

    --获取数字
    self.number1 = self.node:getChildByName("Text1");
    self.number2 = self.node:getChildByName("Text2");

    --获取按钮
    self.startbtn = self.node1:getChildByName("Button1");
    self.sendbtn = self.node:getChildByName("Button2");
    self.notbtn = self.node:getChildByName("Button3");

    self.mycards={}
    --开始按钮
    self.startbtn:addClickEventListener(function(sender)
    	self.node1:setVisible(false);
    	self.node:setVisible(true);

	end)
    --ID值
    self.card = {}
    for i=1,54 do
      local ID = i;
      table.insert(self.card,ID);
    end

    self.luancard = self:shuffle(self.card)--打乱分4份
    self.mycard = {}
    self.play2 = {}
    self.play3 = {}
    self.play4 = {}
    for i=1,54 do
        if i<=17 then
           table.insert(self.mycard,self.luancard[i])
        elseif i<=34 then
            table.insert(self.play2,self.luancard[i])
        elseif i<=51 then
            table.insert(self.play3,self.luancard[i])  
        else
            table.insert(self.play4,self.luancard[i])
        end
    end

-- 排序
    table.sort(self.mycard,function (a,b)
     
        return (a-1)%13+1 < (b-1)%13+1
    end)
    
    --获取牌
    -- self.mycard={1,2,5,4,3,6,7,8,9,10,11,12,13,14,15,16,17};
    for i=1,#self.mycard do
    	local card = self.node:getChildByTag(i);
    	print(self.mycard[i]);
		card:loadTexture(string.format("0%d.jpg",self.mycard[i]));
		table.insert(self.mycards,i,card);
    end

    --存储选中牌的容器
    self.sendcards={};
    --存储扔出牌的容器
    self.storecards={};
    self:addTouch();
end



function CardScene:shuffle(t)
    if type(t)~="table" then
        return
    end
    local tab={}
    local index=1
    math.randomseed(tostring(os.time()):reverse():sub(1, 7))
    while #t~=0 do
        local n=math.random(0,#t)
        if t[n]~=nil then
            tab[index]=t[n]
            table.remove(t,n)
            index=index+1
        end
    end
    return tab
end




--摸牌
function CardScene:addTouch()
    --开始触摸
    local function touchbegan(location,event)
        return true;
    end

    --触摸结束
    local function touchended(location,event)
        
        local p = location:getLocation();
        -- for i=#self.mycards,1,-1 do
        for i=#self.mycards,1,-1 do
           	-- local card = self.node:getChildByTag(i);
           	local rect=self.mycards[i]:getBoundingBox();
   	        if cc.rectContainsPoint(rect,p) then
              	local x,y=self.mycards[i]:getPosition();
                    if y==130 then
                	    self.mycards[i]:setPosition(x,y+20); 
                	    table.insert(self.sendcards,1,self.mycards[i]); 
                	else
                	    self.mycards[i]:setPosition(x,y-20); 
                	    table.remove(self.sendcards,1,self.mycards[i]);
                	end
                print(#self.sendcards)
                    
                break;
            end
        end   
    end
   
    --出牌按钮
    self.sendbtn:addClickEventListener(function(sender)
    	self.storecards={}
    	if #self.storecards~=0 then
    		for i=1,#self.storecards do
    			self.storecards[i]:removeSelf();
    		end
    		self.storecards={};
    	end

		for j=1,#self.sendcards  do
			self.sendcards[j]:setPosition(480+(j-1)*20,320);

			--将选出来的牌出牌之后从原来数组移除
			-- table.remove(self.mycards,1,self.sendcards[i]);

            local new = {}  
			for i ,v in ipairs(self.mycards) do  
                if v~=self.sendcards[j] then  
                   table.insert(new,i,v)  
                end  
            end  
        
            self.mycards=new
			print("mycards剩"..#self.mycards.."张")

			table.insert(self.storecards,1,self.sendcards[j]); 
			print("发出"..#self.storecards.."张牌");
		end
		
		self.sendcards={};
	end)

    
    local listener = cc.EventListenerTouchOneByOne:create();
    local dis = cc.Director:getInstance():getEventDispatcher();

    listener:registerScriptHandler(touchbegan,cc.Handler.EVENT_TOUCH_BEGAN);
    listener:registerScriptHandler(touchended,cc.Handler.EVENT_TOUCH_ENDED);
    dis:addEventListenerWithSceneGraphPriority(listener, self);
end

return CardScene