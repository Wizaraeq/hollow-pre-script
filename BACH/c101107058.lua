--溟界の大蛟
function c101107058.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Special Summon a Reptile from GY
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101107058,0))
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,101107058)
	e2:SetCost(c101107058.spcost)
	e2:SetTarget(c101107058.sptg)
	e2:SetOperation(c101107058.spop)
	c:RegisterEffect(e2)
	--Send a Reptile from Deck to GY
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(101107058,1))
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,101107058+100)
	e3:SetCondition(c101107058.tgcon)
	e3:SetTarget(c101107058.tgtg)
	e3:SetOperation(c101107058.tgop)
	c:RegisterEffect(e3)
end
function c101107058.tgfilter(c,e,tp,ft)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost() and Duel.GetMZoneCount(tp,c)>0
		and Duel.IsExistingTarget(c101107058.spfilter,tp,LOCATION_GRAVE,0,1,nil,c:GetOriginalAttribute(),e,tp)
end
function c101107058.spfilter(c,att,e,tp)
	return c:IsRace(RACE_REPTILE) and c:GetOriginalAttribute()~=att and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101107058.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function c101107058.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c101107058.spfilter(chkc,e:GetLabel(),e,tp) end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then
		if e:GetLabel()~=1 then return false end
		e:SetLabel(0)
		return ft>-1 and Duel.IsExistingMatchingCard(c101107058.tgfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,1,nil,e,tp,ft)
	end
	local g=Duel.SelectMatchingCard(tp,c101107058.tgfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,1,1,nil,e,tp,ft)
	local att=g:GetFirst():GetOriginalAttribute()
	e:SetLabel(att)
	Duel.SendtoGrave(g,REASON_COST)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectTarget(tp,c101107058.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,att,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,sg,1,0,0)
end
function c101107058.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c101107058.filter(c,tp)
	return c:IsControler(1-tp) and c:IsType(TYPE_MONSTER) and c:IsLocation(LOCATION_GRAVE)
end
function c101107058.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2) and eg:IsExists(c101107058.filter,1,nil,tp)
end
function c101107058.tgfilter2(c)
	return c:IsType(TYPE_MONSTER) and c:IsRace(RACE_REPTILE) and c:IsAbleToGrave()
end
function c101107058.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101107058.tgfilter2,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c101107058.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c101107058.tgfilter2,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end