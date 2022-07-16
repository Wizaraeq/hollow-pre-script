--天地返し
function c101110080.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetTarget(c101110080.target)
	e1:SetOperation(c101110080.activate)
	c:RegisterEffect(e1)
end
function c101110080.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local sc=Duel.GetMatchingGroup(Card.IsSequence,tp,LOCATION_DECK,0,nil,0):GetFirst()
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=2 and sc and sc:IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c101110080.activate(e,tp,eg,ep,ev,re,r,rp)
	local sc=Duel.GetMatchingGroup(Card.IsSequence,tp,LOCATION_DECK,0,nil,0):GetFirst()
	if sc:IsAbleToHand() and Duel.SendtoHand(sc,nil,REASON_EFFECT)>0 then
		local dg=Duel.GetFieldGroup(tp,LOCATION_DECK,0)
		if #dg<=1 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local bg=dg:Select(tp,1,1,nil):GetFirst()
		Duel.ShuffleDeck(tp)
		Duel.BreakEffect()
		Duel.MoveSequence(bg,SEQ_DECKBOTTOM)
		Duel.ConfirmCards(tp,bg)
	else
		Duel.SendtoGrave(sc,REASON_RULE)
	end
end