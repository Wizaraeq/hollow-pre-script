--ヴァルモニカ・ディサルモニア
local s,id,o=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_COUNTER+CATEGORY_RECOVER+CATEGORY_DAMAGE+CATEGORY_TOHAND+CATEGORY_GRAVE_ACTION)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.filter(c)
	return c:IsFaceup() and c:IsCanAddCounter(0x6a,1)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_PZONE,0,nil)
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,g,1,0x6a,1)
end
function s.thfilter1(c)
	return c:IsFaceup() and c:IsSetCard(0x1a3) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand() and not c:IsCode(id)
end
function s.thfilter2(c)
	return c:IsSetCard(0x1a3) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand() and not c:IsCode(id)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp,op)
	if op==nil then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_COUNTER)
		local tc=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_PZONE,0,1,1,nil):GetFirst()
		if tc then
			tc:AddCounter(0x6a,1)
		end
		op=aux.SelectFromOptions(tp,{true,aux.Stringid(id,1)},{true,aux.Stringid(id,2)})
	end
	if op==1 then
		if Duel.Recover(tp,500,REASON_EFFECT)<1 then return end
		local g1=Duel.GetMatchingGroup(s.thfilter1,tp,LOCATION_REMOVED,0,nil)
		if #g1>0 and Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg1=g1:Select(tp,1,1,nil)
			Duel.BreakEffect()
			Duel.SendtoHand(sg1,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg1)
		end
	elseif Duel.Damage(tp,500,REASON_EFFECT)>0 then
		local g2=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.thfilter2),tp,LOCATION_GRAVE,0,nil)
		if #g2>0 and Duel.SelectYesNo(tp,aux.Stringid(id,4)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg2=g2:Select(tp,1,1,nil)
			Duel.BreakEffect()
			Duel.SendtoHand(sg2,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg2)
		end
	end
end
