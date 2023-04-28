--強欲なポッド
function c101201029.initial_effect(c)
	--Aply two effects in sequence when it is flipped
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101201029,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP)
	e1:SetCountLimit(1,101201029)
	e1:SetTarget(c101201029.target)
	e1:SetOperation(c101201029.operation)
	c:RegisterEffect(e1)
end
function c101201029.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK+LOCATION_EXTRA)
end
function c101201029.tgfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c101201029.operation(e,tp,eg,ep,ev,re,r,rp)
	local ct1=math.min(Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD),Duel.GetFieldGroupCount(tp,LOCATION_DECK,0))
	local break_chk=false
	--Excavate cards from your Deck, add 1 to the hand and send the others to the GY
	if ct1>0 then
		break_chk=true
		if ct1==0 then return end
		local t={}
		for i=1,ct1 do
			t[i]=i
		end
		local ac=Duel.AnnounceNumber(tp,table.unpack(t))
		Duel.ConfirmDecktop(tp,ac)
		local g=Duel.GetDecktopGroup(tp,ac)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:FilterSelect(tp,Card.IsAbleToHand,1,1,nil)
		if #sg>0 then
			Duel.DisableShuffleCheck(true)
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
			g:RemoveCard(sg:GetFirst())
		end
		if #g>0 then
			Duel.SendtoGrave(g,REASON_EFFECT+REASON_REVEAL)
		end
	end
	--Send monsters from your Extra Deck to the GY
	local ct2=Duel.GetMatchingGroupCount(Card.IsSummonLocation,tp,0,LOCATION_MZONE,nil,LOCATION_EXTRA)
	if ct2>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local tg=Duel.SelectMatchingCard(tp,c101201029.tgfilter,tp,LOCATION_EXTRA,0,1,ct2,nil)
		if #tg>0 then
			if break_chk then Duel.BreakEffect() end
			Duel.SendtoGrave(tg,REASON_EFFECT)
		end
	end
end
