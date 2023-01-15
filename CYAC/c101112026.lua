--死天使ハーヴェスト
function c101112026.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--Destroy itself and search 1 "Black Horn of Heaven"
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101112026,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,101112026)
	e1:SetTarget(c101112026.destg)
	e1:SetOperation(c101112026.desop)
	c:RegisterEffect(e1)
	--If it is Normal or Pendulum Summoned, search 1 "Horn of Heaven"
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101112026,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,101112026+100)
	e2:SetTarget(c101112026.thtg)
	e2:SetOperation(c101112026.thop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(c101112026.thcon)
	c:RegisterEffect(e3)
	-- Place itself in Pendulum Zone if it is tributed
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(101112026,2))
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_RELEASE)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCountLimit(1,101112026+200)
	e4:SetTarget(c101112026.pzntg)
	e4:SetOperation(c101112026.pnzop)
	c:RegisterEffect(e4)
end
function c101112026.thfilter(c,code)
	return c:IsCode(code) and c:IsAbleToHand()
end
function c101112026.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDestructable() and Duel.IsExistingMatchingCard(c101112026.thfilter,tp,LOCATION_DECK,0,1,nil,50323155) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c101112026.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.Destroy(c,REASON_EFFECT)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c101112026.thfilter,tp,LOCATION_DECK,0,1,1,nil,50323155)
		if #g>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
function c101112026.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_PENDULUM)
end
function c101112026.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101112026.thfilter,tp,LOCATION_DECK,0,1,nil,98069388) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c101112026.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c101112026.thfilter,tp,LOCATION_DECK,0,1,1,nil,98069388)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c101112026.pzntg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function c101112026.pnzop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end
