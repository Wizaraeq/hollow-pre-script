--Prey of the Jirai Gumo
function c100206010.initial_effect(c)
	aux.AddCodeList(c,25955164,62340868,98434877)
	--Special Summon itself
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100206010,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_LIMIT_ZONE)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetCountLimit(1,100206010)
	e1:SetTarget(c100206010.sptg)
	e1:SetOperation(c100206010.spop)
	e1:SetValue(c100206010.zones)
	c:RegisterEffect(e1)
	--Add 1 "Sanga of the Thunder", "Kazejin", or "Suijin" to the hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100206010,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetCountLimit(1,100206010+100)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c100206010.thtg)
	e2:SetOperation(c100206010.thop)
	c:RegisterEffect(e2)
end
function c100206010.zones(e,tp,eg,ep,ev,re,r,rp)
	local zone=0
	local lg=Duel.GetMatchingGroup(nil,tp,LOCATION_MZONE,0,nil)
	for tc in aux.Next(lg) do
		zone=bit.bor(zone,1<<tc:GetSequence())
	end
	return bit.bnot(zone)
end
function c100206010.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local zone=1<<c:GetSequence()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)>0 and e:IsHasType(EFFECT_TYPE_ACTIVATE) 
		and Duel.IsPlayerCanSpecialSummonMonster(tp,100206010,0,TYPE_MONSTER+TYPE_NORMAL,2100,100,5,RACE_INSECT,ATTRIBUTE_EARTH) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,tp,0)
end
function c100206010.desfilter(c,tp)
	return c:IsControler(1-tp) and c:IsType(TYPE_MONSTER)
end
function c100206010.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	local zone=1<<c:GetSequence()
	if not (c:IsRelateToEffect(e) and zone>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,100206010,0,TYPE_MONSTER+TYPE_NORMAL,2100,100,5,RACE_INSECT,ATTRIBUTE_EARTH)) then return end
	c:AddMonsterAttribute(TYPE_NORMAL+TYPE_TRAP)
	Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP,zone)
	local dg=c:GetColumnGroup():Filter(c100206010.desfilter,nil,tp)
	if #dg>0 and Duel.SelectYesNo(tp,aux.Stringid(100206010,2)) then
		if #dg>1 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			dg=dg:Select(tp,1,1,nil)
		end
		Duel.BreakEffect()
		Duel.Destroy(dg,REASON_EFFECT)
	end
end
function c100206010.thfilter(c)
	return c:IsCode(25955164,62340868,98434877) and c:IsAbleToHand() and (c:IsLocation(LOCATION_DECK) or c:IsFaceup())
end
function c100206010.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100206010.thfilter,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_REMOVED)
end
function c100206010.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c100206010.thfilter,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end