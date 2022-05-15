--Ｄ・コンバートユニット
function c100427006.initial_effect(c)
	--Apply effect depending on the target's position
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK+CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,100427006+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c100427006.target)
	e1:SetOperation(c100427006.operation)
	c:RegisterEffect(e1)
end
function c100427006.spfilter1(c,e,tp,code)
	return c:IsSetCard(0x26) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsCode(code)
end
function c100427006.spfilter2(c,e,tp)
	return c:IsRace(RACE_MACHINE) and c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c100427006.filter(c,e,tp)
	return c:IsFaceup() and c:IsRace(RACE_MACHINE) and
		((c:IsAttackPos() and c:IsAbleToDeck() and Duel.IsExistingMatchingCard(c100427006.spfilter1,tp,LOCATION_DECK,0,1,nil,e,tp,c:GetCode())) or
		(c:IsDefensePos() and c:IsCanChangePosition() and Duel.IsExistingMatchingCard(c100427006.spfilter2,tp,LOCATION_HAND,0,1,nil,e,tp)))
end
function c100427006.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c100427006.filter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingTarget(c100427006.filter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	local tc=Duel.SelectTarget(tp,c100427006.filter,tp,LOCATION_MZONE,0,1,1,nil,e,tp):GetFirst()
	if tc:IsAttackPos() then
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
		Duel.SetOperationInfo(0,CATEGORY_TODECK,tc,1,tp,0)
	else
		Duel.SetOperationInfo(0,CATEGORY_POSITION,tc,1,tp,0)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
	end 
end
function c100427006.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or not tc:IsFaceup() then return end
	if tc:IsAttackPos() and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c100427006.spfilter1,tp,LOCATION_DECK,0,1,1,nil,e,tp,tc:GetCode())
		if #g==0 then return end
		if Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP) then
			Duel.BreakEffect()
			Duel.ShuffleDeck(tp)
			Duel.SendtoDeck(tc,nil,SEQ_DECKTOP,REASON_EFFECT)
		end
	elseif Duel.ChangePosition(tc,0,0,POS_FACEUP_ATTACK,0)>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c100427006.spfilter2,tp,LOCATION_HAND,0,1,nil,e,tp) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c100427006.spfilter2,tp,LOCATION_HAND,0,1,1,nil,e,tp)
		if #g>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
