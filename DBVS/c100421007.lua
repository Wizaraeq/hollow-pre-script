--メメント・ゴブリン
function c100421007.initial_effect(c)
	-- Make your opponent cannot target "Memento" monsters
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100421007,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,100421007)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetCondition(c100421007.intgcon)
	e1:SetCost(c100421007.intgcost)
	e1:SetOperation(c100421007.intgop)
	c:RegisterEffect(e1)
	-- Send up to 2 "Memento" cards with different names from your Deck to the GY
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100421007,1))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,100421007+100)
	e2:SetTarget(c100421007.tgtg)
	e2:SetOperation(c100421007.tgop)
	c:RegisterEffect(e2)
end
function c100421007.cfilter(c)
	return c:IsCode(100421001) and c:IsFaceup()
end
function c100421007.intgcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return (ph==PHASE_MAIN1 or ph==PHASE_MAIN2) and Duel.IsExistingMatchingCard(c100421007.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c100421007.intgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c100421007.intgop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x2a1))
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetValue(aux.tgoval)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c100421007.tgfilter(c)
	return c:IsSetCard(0x2a1) and c:IsAbleToGrave() and not c:IsCode(100421001)
end
function c100421007.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x2a1)
end
function c100421007.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g=Duel.GetMatchingGroup(c100421007.tgfilter,tp,LOCATION_DECK,0,nil)
		return Duel.IsExistingMatchingCard(c100421007.filter,tp,LOCATION_MZONE,0,1,nil)
			and g:CheckSubGroup(aux.dncheck,1,2) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c100421007.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,c100421007.filter,tp,LOCATION_MZONE,0,1,1,nil)
	if #g>0 and Duel.Destroy(g,REASON_EFFECT)>0 then
		local tg=Duel.GetMatchingGroup(c100421007.tgfilter,tp,LOCATION_DECK,0,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg=tg:SelectSubGroup(tp,aux.dncheck,false,1,2)
		if #sg>0 then
			Duel.SendtoGrave(sg,REASON_EFFECT)
		end
	end
end