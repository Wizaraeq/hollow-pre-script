--テセア聖霊器
function c101110028.initial_effect(c)
	aux.AddCodeList(c,3285552)
	--Special Summon this card
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101110028,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,101110028)
	e1:SetCondition(c101110028.spcon)
	e1:SetTarget(c101110028.sptg)
	e1:SetOperation(c101110028.spop)
	c:RegisterEffect(e1)
	--Search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101110028,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,101110028+100)
	e2:SetCost(c101110028.thcost)
	e2:SetTarget(c101110028.thtg)
	e2:SetOperation(c101110028.thop)
	c:RegisterEffect(e2)
	Duel.AddCustomActivityCounter(101110028,ACTIVITY_SPSUMMON,c101110028.counterfilter)
end
function c101110028.counterfilter(c)
	return c:IsCode(3285552) or (aux.IsCodeListed(c,3285552) and c:IsType(TYPE_MONSTER))
end
function c101110028.scfilter(c)
	return c:IsCode(3285552) and c:IsFaceup()
end
function c101110028.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c101110028.scfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c101110028.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,tp,0)
end
function c101110028.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c101110028.cfilter(c)
	return not c:IsPublic() and aux.IsCodeListed(c,3285552)
end
function c101110028.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(101110028,tp,ACTIVITY_SPSUMMON)==0
		and Duel.IsExistingMatchingCard(c101110028.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c101110028.cfilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
	--Cannot Special Summon
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c101110028.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c101110028.splimit(e,c)
	return not (c:IsCode(3285552) or (aux.IsCodeListed(c,3285552) and c:IsType(TYPE_MONSTER)))
end
function c101110028.thfilter(c)
	return c:IsType(TYPE_SPELL) and c:GetType()~=TYPE_SPELL and aux.IsCodeListed(c,3285552) and c:IsAbleToHand()
end
function c101110028.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101110028.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c101110028.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c101110028.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end