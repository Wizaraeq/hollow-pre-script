--ダブル・フッキング
function c101112079.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCost(c101112079.cost)
	e1:SetTarget(c101112079.target)
	e1:SetOperation(c101112079.operation)
	c:RegisterEffect(e1)
	--Destroy this card when any of the targeted monsters leave the field
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c101112079.descon2)
	e2:SetOperation(c101112079.desop2)
	c:RegisterEffect(e2)
	--Destroy the targeted monsters when this card leaves the field
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCode(EVENT_LEAVE_FIELD_P)
	e3:SetOperation(c101112079.checkop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetCondition(c101112079.descon)
	e4:SetOperation(c101112079.desop)
	e4:SetLabelObject(e3)
	c:RegisterEffect(e4)
end
function c101112079.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c101112079.filter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_ATTACK)
end
function c101112079.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp)
		and chkc:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c101112079.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	local ct=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ct>2 then ct=2 end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ct=1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c101112079.filter,tp,LOCATION_GRAVE,0,1,ct,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c101112079.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ft=Duel.GetLocationCount(1-tp,LOCATION_MZONE)
	if ft<=0 or not c:IsRelateToEffect(e) then return end
	local sg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if sg:GetCount()>1 and Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if sg:GetCount()>ft then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		sg=sg:Select(tp,ft,ft,nil)
	end
	local sc=sg:GetFirst()
	while sc do
		if Duel.SpecialSummonStep(sc,0,tp,tp,false,false,POS_FACEUP) then
			c:SetCardTarget(sc)
		end
		sc=sg:GetNext()
	end
	Duel.SpecialSummonComplete()
end
function c101112079.descon2(e,tp,eg,ep,ev,re,r,rp)
	local tg=e:GetHandler():GetCardTarget()
	return tg and #tg>0 and #(eg&tg)>0
end
function c101112079.checkop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsDisabled() then
		e:SetLabel(1)
	else e:SetLabel(0) end
end
function c101112079.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabelObject():GetLabel()==0
end
function c101112079.desop(e,tp,eg,ep,ev,re,r,rp)
	local tg=e:GetHandler():GetCardTarget():Filter(Card.IsLocation,nil,LOCATION_MZONE)
	if not tg or #tg==0 then return end
	Duel.Destroy(tg,REASON_EFFECT)
end
function c101112079.desop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end
