--Ghoti Cosmos
function c101110090.initial_effect(c)
	--Apply effects in sequence
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101110090,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_MAIN_END+TIMINGS_CHECK_MONSTER)
	e1:SetCountLimit(1,101110090+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c101110090.target)
	e1:SetOperation(c101110090.activate)
	c:RegisterEffect(e1)
end
function c101110090.filter(c)
	return c:IsFaceup() and c:IsRace(RACE_FISH)
end
function c101110090.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetMatchingGroupCount(c101110090.filter,tp,LOCATION_REMOVED,LOCATION_REMOVED,nil)
	if chk==0 then return ct>0 end
	if ct>=8 then
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	end
end
function c101110090.activate(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(c101110090.filter,tp,LOCATION_REMOVED,LOCATION_REMOVED,nil)
	if ct==0 then return end
	local c=e:GetHandler()
	local breakc=false
	if ct>=1 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e1:SetTargetRange(LOCATION_MZONE,0)
		e1:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_FISH))
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetValue(1)
		Duel.RegisterEffect(e1,tp)
		breakc=true
	end
	if ct>=4 then
		if breakc then Duel.BreakEffect() end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_CANNOT_INACTIVATE)
		e1:SetTargetRange(1,0)
		e1:SetValue(c101110090.effectfilter)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_CANNOT_DISEFFECT)
		Duel.RegisterEffect(e2,tp)
		breakc=true
	end
	if ct>=8 and Duel.IsExistingMatchingCard(c101110090.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sc=Duel.SelectMatchingCard(tp,c101110090.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp):GetFirst()
		if sc then
			if breakc then Duel.BreakEffect() end
			if Duel.SpecialSummon(sc,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)>0 then
				sc:CompleteProcedure()
			end
		end
	end
end
function c101110090.effectfilter(e,ct)
	local p=e:GetHandlerPlayer()
	local tp,loc,race=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_PLAYER,CHAININFO_TRIGGERING_LOCATION,CHAININFO_TRIGGERING_RACE)
	return p==tp and (loc&LOCATION_ONFIELD)~=0 and race&RACE_FISH>0
end
function c101110090.spfilter(c,e,tp)
	return c:IsType(TYPE_SYNCHRO) and c:IsRace(RACE_FISH)
		and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false)
end