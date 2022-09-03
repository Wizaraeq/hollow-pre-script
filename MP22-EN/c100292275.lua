--The True Sun God
function c100292275.initial_effect(c)
	aux.AddCodeList(c,10000010)
	--Search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100292275,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,100292275,EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c100292275.thtg)
	e1:SetOperation(c100292275.thop)
	c:RegisterEffect(e1)
	--attack limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_ATTACK)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(c100292275.atktg)
	c:RegisterEffect(e2)
	--Send GY
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(100292275,1))
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c100292275.tgtg)
	e3:SetOperation(c100292275.tgop)
	c:RegisterEffect(e3)
end
function c100292275.atktg(e,c)
	return not c:IsCode(10000010) and c:IsStatus(STATUS_SPSUMMON_TURN)
end
function c100292275.thfilter(c)
	return (c:IsCode(10000010) or aux.IsCodeListed(c,10000010)) and not c:IsCode(100292275) and c:IsAbleToHand()
end
function c100292275.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100292275.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c100292275.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c100292275.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c100292275.cfilter(c)
	return c:IsCode(10000090) and c:IsAbleToGrave()
end
function c100292275.tgfilter(c)
	return c:IsCode(10000010) and c:IsAbleToGrave() and c:IsFaceup()
end
function c100292275.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (e:GetHandler():IsAbleToGrave() or Duel.IsExistingMatchingCard(c100292275.cfilter,tp,LOCATION_DECK,0,1,nil))
		and Duel.IsExistingMatchingCard(c100292275.tgfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,2,tp,LOCATION_DECK+LOCATION_ONFIELD)
end
function c100292275.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tg=Duel.GetMatchingGroup(c100292275.cfilter,tp,LOCATION_DECK,0,nil)
	if c:IsRelateToEffect(e) and c:IsAbleToGrave() then tg:AddCard(c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tc=tg:Select(tp,1,1,nil):GetFirst()
	if tc and Duel.SendtoGrave(tc,REASON_EFFECT)>0 and tc:IsLocation(LOCATION_GRAVE) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg=Duel.SelectMatchingCard(tp,c100292275.tgfilter,tp,LOCATION_MZONE,0,1,1,nil)
		if #sg>0 then
			Duel.BreakEffect()
			Duel.SendtoGrave(sg,REASON_EFFECT)
		end
	end
end
