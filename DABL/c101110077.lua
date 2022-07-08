--忍法 落葉舞
function c101110077.initial_effect(c)
	--Tribute a monster and Special Summon 1 "Ninja" monster from the Deck
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101110077,0))
	e1:SetCategory(CATEGORY_RELEASE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetCountLimit(1,101110077)
	e1:SetTarget(c101110077.sptg)
	e1:SetOperation(c101110077.spop)
	c:RegisterEffect(e1)
	--Send the summoned monster to the GY
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetOperation(c101110077.tgop)
	c:RegisterEffect(e2)
	--Return 1 "Ninjitsu Art" Continuous Spell/Trap to the hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(101110077,1))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_SZONE)
	e3:SetHintTiming(0,TIMING_END_PHASE)
	e3:SetCountLimit(1,101110077)
	e3:SetTarget(c101110077.thtg)
	e3:SetOperation(c101110077.thop)
	c:RegisterEffect(e3)
end
function c101110077.releasefilter(c,tp)
	return ((c:IsFaceup() and c:IsSetCard(0x2b)) or c:IsPosition(POS_FACEDOWN_DEFENSE)) and c:IsReleasableByEffect()
		and Duel.GetMZoneCount(tp,c)>0
end
function c101110077.spfilter(c,e,tp)
	return c:IsSetCard(0x2b) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101110077.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c101110077.releasefilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c101110077.releasefilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,tp)
		and Duel.IsExistingMatchingCard(c101110077.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c101110077.releasefilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c101110077.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Release(tc,REASON_EFFECT)>0 and Duel.GetMZoneCount(tp)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sc=Duel.SelectMatchingCard(tp,c101110077.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp):GetFirst()
		if sc and Duel.SpecialSummonStep(sc,0,tp,tp,false,false,POS_FACEUP) then
			e:GetHandler():SetCardTarget(sc)
		end
		Duel.SpecialSummonComplete()
	end
end
function c101110077.tgop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetFirstCardTarget()
	if tc and tc:IsLocation(LOCATION_MZONE) then
		Duel.SendtoGrave(tc,REASON_EFFECT)
	end
end
function c101110077.thfilter(c)
	return c:IsSetCard(0x61) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsType(TYPE_CONTINUOUS) and c:IsFaceup() and c:IsAbleToHand()
end
function c101110077.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_SZONE) and chkc:IsControler(tp) and c101110077.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101110077.thfilter,tp,LOCATION_SZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,c101110077.thfilter,tp,LOCATION_SZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,tp,LOCATION_SZONE)
end
function c101110077.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end