--恐楽園の死配人 ＜Ａｒｌｅｃｈｉｎｏ＞
function c101112023.initial_effect(c)
	--Special Summon itself from the hand and search 1 "Amazement Family Faces"
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101112023,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,101112023)
	e1:SetCondition(c101112023.spcon)
	e1:SetTarget(c101112023.sptg)
	e1:SetOperation(c101112023.spop)
	c:RegisterEffect(e1)
	--Shuffle itself into the Deck and Special Summon "Amazement Administrator Arlekino"
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101112023,1))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON+CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e2:SetCountLimit(1,101112023+100)
	e2:SetCondition(c101112023.tdcon)
	e2:SetTarget(c101112023.tdtg)
	e2:SetOperation(c101112023.tdop)
	c:RegisterEffect(e2)
end
function c101112023.cfilter(c)
	return c:IsSetCard(0x15b) and c:IsAbleToHand()
end
function c101112023.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c101112023.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c101112023.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c101112023.thfilter(c)
	return c:IsCode(20989253) and c:IsAbleToHand()
end
function c101112023.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c101112023.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)
		if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(101112023,2)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=g:Select(tp,1,1,nil)
			Duel.BreakEffect()
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		end
	end
end
function c101112023.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c101112023.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_EFFECT) and c:GetAttack()>0
end
function c101112023.spfilter(c,e,tp)
	return c:IsCode(94821366) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101112023.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c101112023.cfilter(chkc) and chkc~=c end
	if chk==0 then return c:IsAbleToDeck() and Duel.GetMZoneCount(tp,c)>0
		and Duel.IsExistingMatchingCard(c101112023.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) 
		and Duel.IsExistingTarget(c101112023.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATKDEF)
	local tc=Duel.SelectTarget(tp,c101112023.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,c):GetFirst()
	Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,tc,1,tp,-tc:GetAttack())
	Duel.SetOperationInfo(0,CATEGORY_TODECK,c,1,tp,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c101112023.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SendtoDeck(c,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)>0 and c:IsLocation(LOCATION_DECK+LOCATION_EXTRA)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c101112023.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		if #g>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)>0 then
			local tc=Duel.GetFirstTarget()
			if tc:IsFaceup() and tc:IsRelateToEffect(e) then
				Duel.BreakEffect()
				--Change its ATK to 0
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_SET_ATTACK_FINAL)
				e1:SetValue(0)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e1)
			end
		end
	end
end