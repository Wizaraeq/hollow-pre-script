--トライブ・ドライブ
function c101107078.initial_effect(c)
	-- Add to hand or Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetCountLimit(1,101107078+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c101107078.condition)
	e1:SetTarget(c101107078.target)
	e1:SetOperation(c101107078.activate)
	c:RegisterEffect(e1)
end
function c101107078.filter(c,e,tp,ft)
	return c:IsType(TYPE_MONSTER) and (c:IsAbleToHand() or (ft>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false))) and Duel.IsExistingMatchingCard(c101107078.ffilter,tp,LOCATION_MZONE,0,1,nil,c:GetRace())
end
function c101107078.ffilter(c,race)
	return c:IsFaceup() and c:IsRace(race)
end
function c101107078.condition(e,tp,eg,ep,ev,re,r,rp,chk)
	return Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil):GetClassCount(Card.GetRace)>=3
end
function c101107078.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=Duel.GetMatchingGroup(c101107078.filter,tp,LOCATION_DECK,0,nil,e,tp,ft)
	if chk==0 then return g:CheckSubGroup(aux.drccheck,3,3) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c101107078.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.DisableShuffleCheck()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=Duel.GetMatchingGroup(c101107078.filter,tp,LOCATION_DECK,0,nil,e,tp,ft)
	local sg=g:SelectSubGroup(tp,aux.drccheck,false,3,3)
	if #sg~=3 then return end
	Duel.ConfirmCards(1-tp,sg)
	Duel.ShuffleDeck(tp)
	local tg=sg:RandomSelect(1-tp,1)
	local sc=tg:GetFirst()
	Duel.Hint(HINT_CARD,0,sc:GetCode())
	if sc then
		if sc:IsAbleToHand() and (not sc:IsCanBeSpecialSummoned(e,0,tp,false,false) or ft<=0 or Duel.SelectOption(tp,1190,1152)==0) then
			Duel.SendtoHand(sc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sc)
		else
			Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
		end
	end
	sg=sg-sc
	for tc in aux.Next(sg) do
		Duel.MoveSequence(tc,0)
	end
	local ct=sg:GetCount()
	if ct>0 then
		Duel.SortDecktop(tp,tp,ct)
		for i=1,ct do
			local mg=Duel.GetDecktopGroup(tp,1)
			Duel.MoveSequence(mg:GetFirst(),1)
		end
	end
end