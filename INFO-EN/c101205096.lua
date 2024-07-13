--Mimighoul Room
local s,id,o=GetID()
function s.initial_effect(c)
	--Special Summon 1 "Mimighoul" monster
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	--Return any number of "Mimighoul" cards to the hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,id)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
end
function s.spfilter(c,e,tp,f1,f2)
	if not c:IsSetCard(0x2be) then return false end
	return (f1 and c:IsCanBeSpecialSummoned(e,0,tp,false,false))
		or (f2 and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE,1-tp))
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local f1=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		local f2=Duel.GetLocationCount(1-tp,LOCATION_MZONE,tp)>0
		return Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp,f1,f2)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_HAND+LOCATION_DECK)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local f1=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	local f2=Duel.GetLocationCount(1-tp,LOCATION_MZONE,tp)>0
	if not f1 and not f2 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp,f1,f2):GetFirst()
	if not tc then return end
	local b1=f1 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false)
	local b2=f2 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE,1-tp)
		op=aux.SelectFromOptions(tp,
			{b1,aux.Stringid(id,2)},
			{b2,aux.Stringid(id,3)})
	if op==1 then
		if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)==0 then return end
	elseif op==2 then
		if Duel.SpecialSummon(tc,0,tp,1-tp,false,false,POS_FACEDOWN_DEFENSE)==0 then return end
	end
	local g=Duel.GetMatchingGroup(aux.AND(Card.IsFaceup,Card.IsCanTurnSet),tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if #g==0 or not Duel.SelectYesNo(tp,aux.Stringid(id,4)) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local pc=g:Select(tp,1,1,nil):GetFirst()
	if pc then
		Duel.BreakEffect()
		Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)
	end
end
function s.thfilter(c,e)
	return c:IsFaceup() and c:IsSetCard(0x2be) and c:IsAbleToHand() and c:IsCanBeEffectTarget(e)
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_ONFIELD) and s.thfilter(chkc,e) end
	if chk==0 then return Duel.IsExistingTarget(s.thfilter,tp,LOCATION_ONFIELD,0,1,nil,e) end
	local g=Duel.GetMatchingGroup(s.thfilter,tp,LOCATION_ONFIELD,0,nil,e)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local tg=g:Select(tp,1,#g,nil)
	Duel.SetTargetCard(tg)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,tg,#tg,0,0)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if #tg>0 then
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
	end
end