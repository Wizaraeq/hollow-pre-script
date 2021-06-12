--クリバビロン*
function c100278005.initial_effect(c)
	aux.AddCodeList(c,40640057)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100278005,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,100278005)
	e1:SetCondition(c100278005.spcon1)
	e1:SetTarget(c100278005.sptg1)
	e1:SetOperation(c100278005.spop1)
	c:RegisterEffect(e1)
	--atkup
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c100278005.val)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
	--return hand SpecialSummon
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,100278005)
	e4:SetTarget(c100278005.sptg2)
	e4:SetOperation(c100278005.spop2)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetHintTiming(0,TIMING_BATTLE_START+TIMING_BATTLE_END)
	e5:SetCondition(c100278005.spcon2)
	c:RegisterEffect(e5)
end
function c100278005.scfilter(c)
	return c:IsType(TYPE_MONSTER)
end
function c100278005.spcon1(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroupCount(Card.IsType,tp,LOCATION_GRAVE,0,nil,TYPE_MONSTER)
	local g2=Duel.GetMatchingGroupCount(Card.IsType,1-tp,LOCATION_GRAVE,0,nil,TYPE_MONSTER)
	return g1>g2
end
function c100278005.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c100278005.spop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
function c100278005.afilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xa4)
end
function c100278005.val(e,c)
	return Duel.GetMatchingGroupCount(c100278005.afilter,c:GetControler(),LOCATION_GRAVE+LOCATION_MZONE,0,nil)*300
end
function c100278005.spcon2(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE)
		and Duel.GetTurnPlayer()==tp and Duel.GetCurrentChain()==0
end
function c100278005.spfilter(c,e,tp)
	return c:IsCode(40640057,100278001,100278002,100278003,100278004) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_ATTACK)
end
function c100278005.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		local g=Duel.GetMatchingGroup(c100278005.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,nil,e,tp)
		return c:IsAbleToHand() and not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>=4
		and g:GetClassCount(Card.GetCode)>4
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,c,1,tp,LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,5,tp,LOCATION_GRAVE+LOCATION_HAND)
end
function c100278005.spop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SendtoHand(c,nil,REASON_EFFECT)>0 then
	local ct=math.min(5,(Duel.GetLocationCount(tp,LOCATION_MZONE)))
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c100278005.spfilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,nil,e,tp)
	if not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and ct>4 and g:GetClassCount(Card.GetCode)>4 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		aux.GCheckAdditional=aux.dncheck
		local g1=g:SelectSubGroup(tp,aux.TRUE,false,5,5)
		aux.GCheckAdditional=nil
		Duel.SpecialSummon(g1,0,tp,tp,false,false,POS_FACEUP_ATTACK)
	end
	end
end
