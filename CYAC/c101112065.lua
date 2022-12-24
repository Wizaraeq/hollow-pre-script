--ドレミコード・シンフォニア
function c101112065.initial_effect(c)
	--Apply effects in sequence
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101112065,0))
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DESTROY+CATEGORY_DRAW+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_DAMAGE_STEP)
	e1:SetCountLimit(1,101112065,EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c101112065.actcon)
	e1:SetTarget(c101112065.acttg)
	e1:SetOperation(c101112065.actop)
	c:RegisterEffect(e1)
end
function c101112065.actcon(e)
	return Duel.GetCurrentPhase()~=PHASE_DAMAGE or not Duel.IsDamageCalculated()
end
function c101112065.solfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x162) and c:IsType(TYPE_PENDULUM)
end
function c101112065.acfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x162)
end
function c101112065.acttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101112065.acfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.GetMatchingGroup(c101112065.solfilter,tp,LOCATION_EXTRA,0,nil):GetClassCount(Card.GetCode)>2 end
	local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_ONFIELD,nil)
end
function c101112065.spfilter(c,e,tp)
	return c:IsSetCard(0x1162) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101112065.scfilter(c)
	return c:GetCurrentScale()%2~=0
end
function c101112065.actop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroup(c101112065.solfilter,tp,LOCATION_EXTRA,0,nil):GetClassCount(Card.GetCode)
	if ct<3 then return end
	local atkg=Duel.GetMatchingGroup(c101112065.solfilter,tp,LOCATION_MZONE,0,nil)
	local c=e:GetHandler()
	local breakeff=#atkg>0
	local tc=atkg:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(tc:GetLeftScale()*300)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		tc=atkg:GetNext()
	end
	if ct<5 then return end
	--Destroy 1 card
	local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_ONFIELD,nil)
	if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(101112065,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local pg=g:Select(tp,1,1,nil)
		if #pg>0 then
			if breakeff then Duel.BreakEffect() end
			breakeff=true
			if Duel.Destroy(pg,REASON_EFFECT)>0
				and Duel.IsExistingMatchingCard(c101112065.scfilter,tp,LOCATION_PZONE,0,1,nil) then
				Duel.BreakEffect()
				Duel.Draw(tp,1,REASON_EFFECT)
			end
		end
	end
	if ct<7 then return end
	--Special Summon 1 "GranSolfachord" monster
	local sg=Duel.GetMatchingGroup(c101112065.spfilter,tp,LOCATION_EXTRA,0,nil,e,tp)
	if #sg>0 and Duel.SelectYesNo(tp,aux.Stringid(101112065,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local ssg=sg:Select(tp,1,1,nil)
		if #ssg==0 then return end
		if breakeff then Duel.BreakEffect() end
		Duel.SpecialSummon(ssg,0,tp,tp,false,false,POS_FACEUP)
	end
end
