--未来への沈黙
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,101204051)
	--Activate without draw
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.thfilter(c)
	return c:IsType(TYPE_MONSTER) and aux.IsCodeListed(c,101204051) and c:IsAbleToHand()
end
function s.sfilter(c)
	return c:IsFaceup() and c:IsCode(101204051)
end
function s.mfilter(c)
	return c:IsFaceup() and aux.IsCodeListed(c,101204051) and c:IsType(TYPE_MONSTER)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local ct1=6-Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	local ct2=6-Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
	local draw=(Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE)
		and Duel.IsExistingMatchingCard(s.sfilter,tp,LOCATION_ONFIELD,0,1,nil)
		and Duel.IsExistingMatchingCard(s.mfilter,tp,LOCATION_MZONE,0,1,nil)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil)
		and (not draw or (ct1>0 and Duel.IsPlayerCanDraw(tp,ct1)
		and ct2>0 and Duel.IsPlayerCanDraw(1-tp,ct2))) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	if draw then
		e:SetLabel(1)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,ct1)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,1-tp,ct2)
	else
		e:SetLabel(0)
	end
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		if e:GetLabel()==1 then
			local ct1=6-Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
			local ct2=6-Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
			if ct1>0 or ct2>0 then Duel.BreakEffect() end
			if ct1>0 then
				Duel.Draw(tp,ct1,REASON_EFFECT)
			end
			if ct2>0 then
				Duel.Draw(1-tp,ct2,REASON_EFFECT)
			end
		end
	end
end