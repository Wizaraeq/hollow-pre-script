--綱引犬会
function c100298004.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Draw 2 cards
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100298004,0))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_EVENT_PLAYER)
	e2:SetCode(EVENT_DRAW)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCondition(c100298004.drcon)
	e2:SetCost(c100298004.drcost)
	e2:SetTarget(c100298004.drtg)
	e2:SetOperation(c100298004.drop)
	c:RegisterEffect(e2)
	--Lose 2000 LP and send this card to the GY
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(100298004,1))
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_CUSTOM+100298004)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTarget(c100298004.gytg)
	e3:SetOperation(c100298004.gyop)
	c:RegisterEffect(e3)
end
function c100298004.cfilter(c)
	return c:IsType(TYPE_TUNER) and not c:IsPublic()
end
function c100298004.drcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_RULE and eg:IsExists(c100298004.cfilter,1,nil)
end
function c100298004.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local tg=eg:Filter(c100298004.cfilter,nil)
	if #tg>1 then
		tg=tg:Select(tp,1,1,nil)
	end
	Duel.ConfirmCards(1-tp,tg)
	Duel.ShuffleHand(tp)
end
function c100298004.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c100298004.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
	local c=e:GetHandler()
	if p~=c:GetControler() then
		Duel.RaiseSingleEvent(c,EVENT_CUSTOM+100298004,e,0,tp,tp,0)
	end
end
function c100298004.gytg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,e:GetHandler(),1,0,0)
end
function c100298004.gyop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetLP(tp,Duel.GetLP(tp)-2000)
	Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT)
end