--鉄獣の死線
function c101110055.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Add to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101110055,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,101110055)
	e2:SetCondition(c101110055.thcond)
	e2:SetTarget(c101110055.thtg)
	e2:SetOperation(c101110055.thop)
	c:RegisterEffect(e2)
	--Return hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(101110055,1))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLED)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,101110055+100)
	e3:SetCondition(c101110055.rthcon)
	e3:SetTarget(c101110055.rthtg)
	e3:SetOperation(c101110055.rthop)
	c:RegisterEffect(e3)
end
function c101110055.cfilter(c,tp)
	return c:IsRace(RACE_BEAST+RACE_BEASTWARRIOR+RACE_WINDBEAST) and c:IsControler(tp) and c:IsFaceup()
end
function c101110055.thcond(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c101110055.cfilter,1,nil,tp)
end
function c101110055.thfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x14d) and c:IsAbleToHand()
end
function c101110055.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_REMOVED) and s.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101110055.thfilter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c101110055.thfilter,tp,LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,tp,LOCATION_REMOVED)
end
function c101110055.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
function c101110055.rthcon(e,tp,eg,ep,ev,re,r,rp)
	local a,b=Duel.GetBattleMonster(tp)
	return a and a:IsSetCard(0x14d) and b and b:IsAbleToHand()
end
function c101110055.rthtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local _,b=Duel.GetBattleMonster(tp)
	Duel.SetTargetCard(b)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,b,1,tp,0)
end
function c101110055.rthop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsControler(1-tp) and tc:IsRelateToBattle() then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end