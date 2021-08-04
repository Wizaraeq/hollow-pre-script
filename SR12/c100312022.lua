--天空の歌声
function c100312022.initial_effect(c)
	aux.AddCodeList(c,56433456)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c100312022.cost)
	e1:SetTarget(c100312022.target)
	e1:SetOperation(c100312022.activate)
	c:RegisterEffect(e1)
end
function c100312022.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end
function c100312022.filter1(c)
	return c:IsRace(RACE_FAIRY) and c:IsAbleToHand()
end
function c100312022.filter2(c)
	return c:IsFaceup() and (c:IsCode(56433456) or aux.IsCodeListed(c,56433456)) and c:IsAbleToHand()
end
function c100312022.cfilter(c)
	return c:IsCode(56433456) and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE))
end
function c100312022.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetControler()==tp and chkc:GetLocation()==LOCATION_GRAVE and c100312022.filter1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c100312022.filter1,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c100312022.filter1,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c100312022.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 then
		local res=Duel.IsExistingMatchingCard(c100312022.cfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,1,nil)
		local mg=Duel.GetMatchingGroup(c100312022.filter2,tp,LOCATION_REMOVED,0,nil)
		if res and mg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(100312022,0)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=mg:Select(tp,1,1,nil)
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		end
	end
end

