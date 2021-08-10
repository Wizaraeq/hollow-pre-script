--運命の旅路
-- Journey of Destiny
function c100417029.initial_effect(c)
	aux.AddCodeList(c,100417125)
	-- Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	-- Prevent battle destruction once
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100417029,0))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetCountLimit(1)
	e2:SetValue(1)
	e2:SetTarget(c100417029.indtg)
	c:RegisterEffect(e2)
	-- Search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(100417029,1))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_HANDES)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,100417029)
	e3:SetTarget(c100417029.mthtg)
	e3:SetOperation(c100417029.mthop)
	c:RegisterEffect(e3)
	--Equip
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(100417029,2))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1,100417029+100)
	e4:SetTarget(c100417029.sthtg)
	e4:SetOperation(c100417029.sthop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e5)
end
function c100417029.indtg(e,c)
	return c:GetEquipCount()>0
end
function c100417029.mthfilter(c)
	return c:IsType(TYPE_MONSTER) and aux.IsCodeListed(c,100417125) and c:IsAbleToHand()
end
function c100417029.mthtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100417029.mthfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,1,tp,1)
end
function c100417029.mthop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c100417029.mthfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)>0 then
		Duel.ConfirmCards(1-tp,g)
		Duel.ShuffleHand(tp)
		Duel.BreakEffect()
		Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT)
	end
end
function c100417029.bravefilter(c,ec)
	return c:IsFaceup() and c:IsCode(100417125) and ec:CheckEquipTarget(c)
end
function c100417029.eqfilter(c,tp)
	return c:CheckUniqueOnField(tp) and not c:IsForbidden()
		and Duel.IsExistingTarget(c100417029.bravefilter,tp,LOCATION_MZONE,0,1,nil,c)
end
function c100417029.sthfilter(c,tp)
	return c:IsType(TYPE_EQUIP) and aux.IsCodeListed(c,100417125)
		and (c:IsAbleToHand() or c100417029.eqfilter(c,tp))
end
function c100417029.sthtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100417029.sthfilter,tp,LOCATION_DECK,0,1,nil,tp) end
end
function c100417029.sthop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c100417029.sthfilter,tp,LOCATION_DECK,0,1,1,nil,tp)
	local tc=g:GetFirst()
	if tc then
		local b1=tc:IsAbleToHand()
		local b2=c100417029.eqfilter(tc,tp) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		if b1 and (not b2 or Duel.SelectOption(tp,1190,aux.Stringid(100417029,3))==0) then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
			local et=Duel.SelectMatchingCard(tp,c100417029.bravefilter,tp,LOCATION_MZONE,0,1,1,nil,tc):GetFirst()
			if et and Duel.Equip(tp,tc,et) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(c100417029.eqlimit)
			e1:SetLabelObject(et)
			tc:RegisterEffect(e1)
			end
		end
	end
end
function c100417029.eqlimit(e,c)
	return c==e:GetLabelObject()
end