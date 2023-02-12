--Gold Pride - Nytro Head
function c101111087.initial_effect(c)
	--Special Summon itself from the hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101111087,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,101111087)
	e1:SetCondition(c101111087.spcon)
	e1:SetTarget(c101111087.sptg)
	e1:SetOperation(c101111087.spop)
	c:RegisterEffect(e1)
	--Special Summon 1 "Nytro Token" to the opponent's field
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101111087,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,101111087+100)
	e2:SetCondition(c101111087.tkncon)
	e2:SetTarget(c101111087.tkntg)
	e2:SetOperation(c101111087.tknop)
	c:RegisterEffect(e2)
	--Destroy 1 "Nytro Token" and cards adjacent to it
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(101111087,2))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e3:SetCountLimit(1,101111087+200)
	e3:SetCondition(c101111087.descon)
	e3:SetTarget(c101111087.destg)
	e3:SetOperation(c101111087.desop)
	c:RegisterEffect(e3)
end
function c101111087.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLP(tp)<Duel.GetLP(1-tp)
end
function c101111087.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,tp,0)
end
function c101111087.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c101111087.tkncon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c101111087.tkntg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(1-tp,LOCATION_MZONE,tp)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,101111187,0,TYPES_TOKEN_MONSTER,0,0,8,RACE_PYRO,ATTRIBUTE_FIRE,POS_FACEUP,1-tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
end
function c101111087.tknop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 
		and Duel.IsPlayerCanSpecialSummonMonster(tp,101111187,0,TYPES_TOKEN_MONSTER,0,0,8,RACE_PYRO,ATTRIBUTE_FIRE,POS_FACEUP,1-tp) then
		local token=Duel.CreateToken(tp,101111187)
		if Duel.SpecialSummonStep(token,0,tp,1-tp,false,false,POS_FACEUP) then
			--Cannot be used as Link Material
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
			e1:SetValue(1)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			token:RegisterEffect(e1)
		end
		Duel.SpecialSummonComplete()
	end
end
function c101111087.cfilter(c,tp,seq)
	local sseq=c:GetSequence()
	if c:IsControler(tp) then
		return sseq==5 and seq==3 or sseq==6 and seq==1
	end
	if c:IsLocation(LOCATION_SZONE) then
		return sseq<5 and sseq==seq
	end
	if sseq<5 then
		return math.abs(sseq-seq)==1
	end
	if sseq>=5 then
		return sseq==5 and seq==1 or sseq==6 and seq==3
	end
end
function c101111087.descon(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2) and Duel.GetTurnPlayer()==1-tp
end
function c101111087.desfilter(c,tp)
	local seq=c:GetSequence()
	return c:IsFaceup() and c:IsCode(101111187) and Duel.IsExistingMatchingCard(c101111087.cfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,tp,seq)
end
function c101111087.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c101111087.cfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c101111087.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local gg=Duel.SelectTarget(tp,c101111087.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,tp)
	local g=Duel.GetMatchingGroup(c101111087.cfilter,tp,0,LOCATION_ONFIELD,nil,tp,gg:GetFirst():GetSequence())
	g:Merge(gg)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
end
function c101111087.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsType(TYPE_TOKEN) then
		local g=Duel.GetMatchingGroup(c101111087.cfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,tp,tc:GetSequence())
		Duel.Destroy(g+tc,REASON_EFFECT)
	end
end