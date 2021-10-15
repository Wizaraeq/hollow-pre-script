--青き眼の幻出
function c101107050.initial_effect(c)
	aux.AddCodeList(c,89631139)
	-- Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,101107050,EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c101107050.acttg)
	c:RegisterEffect(e1)
	-- Special Summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101107050,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c101107050.thtg)
	e2:SetOperation(c101107050.thop)
	c:RegisterEffect(e2)
end
function c101107050.acttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if c101107050.spcost(e,tp,eg,ep,ev,re,r,rp,0) and c101107050.sptg(e,tp,eg,ep,ev,re,r,rp,0)
		and Duel.SelectYesNo(tp,aux.Stringid(101107050,0)) then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		c101107050.spcost(e,tp,eg,ep,ev,re,r,rp,1)
		c101107050.sptg(e,tp,eg,ep,ev,re,r,rp,1)
		e:SetOperation(c101107050.spop)
	else
		e:SetCategory(0)
		e:SetOperation(nil)
	end
end
function c101107050.spcostfilter(c)
	return c:IsCode(89631139) and not c:IsPublic()
end
function c101107050.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101107050.spcostfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c101107050.spcostfilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
end
function c101107050.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(Card.IsCanBeSpecialSummoned,tp,LOCATION_HAND,0,1,nil,e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c101107050.spop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) or Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,Card.IsCanBeSpecialSummoned,tp,LOCATION_HAND,0,1,1,nil,e,0,tp,false,false)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c101107050.thfilter(c)
	return c:IsFaceup() and c:IsAbleToHand()
end
function c101107050.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c101107050.thfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,c101107050.thfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c101107050.thspfilter(c,e,tp,thc)
	return (thc:IsOriginalCodeRule(89631139) or c:IsSetCard(0xdd)) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101107050.thop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	local op=2
	if not tc:IsOriginalCodeRule(89631139) then op=3 end
	if tc:IsRelateToEffect(e) and Duel.SendtoHand(tc,nil,REASON_EFFECT)>0
		and tc:IsLocation(LOCATION_HAND)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c101107050.thspfilter,tp,LOCATION_HAND,0,1,nil,e,tp,tc)
		and Duel.SelectYesNo(tp,aux.Stringid(101107050,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c101107050.thspfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp,tc)
		if #g>0 then
			Duel.BreakEffect()
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
