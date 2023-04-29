--Gold Pride - It's Neck and Neck!
function c101112092.initial_effect(c)
	-- Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101112092,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetCountLimit(1,101112092)
	e1:SetTarget(c101112092.thtg)
	e1:SetOperation(c101112092.thop)
	c:RegisterEffect(e1)
	-- Special Summon 1 "Gold Pride" monster from your Extra Deck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101112092,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetHintTiming(0,TIMING_MAIN_END+TIMINGS_CHECK_MONSTER)
	e2:SetCountLimit(1,101112092+100)
	e2:SetCondition(c101112092.spcon)
	e2:SetCost(c101112092.spcost)
	e2:SetTarget(c101112092.sptg)
	e2:SetOperation(c101112092.spop)
	c:RegisterEffect(e2)
end
function c101112092.thfilter(c)
	return c:IsSetCard(0x192) and c:IsFaceup() and not c:IsCode(101112092) and c:IsAbleToHand()
end
function c101112092.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE+LOCATION_GRAVE) and c101112092.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101112092.thfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,c101112092.thfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c101112092.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
function c101112092.spcfilter(c,lp)
	return c:IsFaceup() and c:GetAttack()>lp
end
function c101112092.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c101112092.spcfilter,tp,0,LOCATION_MZONE,1,nil,Duel.GetLP(tp))
end
function c101112092.rmfilter(c,e,tp)
	return c:IsSetCard(0x192) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
		and Duel.IsExistingMatchingCard(c101112092.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,c:GetCode())
end
function c101112092.spfilter(c,e,tp,code)
	return c:IsSetCard(0x192) and aux.IsCodeListed(c,code) and not c:IsCode(code)
		and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101112092.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemoveAsCost()
		and Duel.IsExistingMatchingCard(c101112092.rmfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sc=Duel.SelectMatchingCard(tp,c101112092.rmfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp):GetFirst()
	local rg=Group.FromCards(sc,c)
	Duel.Remove(rg,POS_FACEUP,REASON_COST)
	Duel.SetTargetCard(sc)
end
function c101112092.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c101112092.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or tc:IsFacedown() then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c101112092.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc:GetCode())
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end