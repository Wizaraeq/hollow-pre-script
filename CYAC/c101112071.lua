--烙印の即凶劇
function c101112071.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Synchro Summon using a Dragon monster
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101112071,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e2:SetCountLimit(1,101112071)
	e2:SetTarget(c101112071.sctg)
	e2:SetOperation(c101112071.scop)
	c:RegisterEffect(e2)
	--Banished instead
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(0,0xff)
	e3:SetCondition(c101112071.rmcon)
	e3:SetTarget(c101112071.rmtg)
	e3:SetValue(LOCATION_REMOVED)
	c:RegisterEffect(e3)
end
function c101112071.mfilter(c)
	return c:IsRace(RACE_DRAGON) and c:IsType(TYPE_MONSTER)
end
function c101112071.cfilter(c,syn)
	return syn:IsSynchroSummonable(c)
end
function c101112071.scfilter(c,mg)
	return mg:IsExists(c101112071.cfilter,1,nil,c)
end
function c101112071.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetMatchingGroup(c101112071.mfilter,tp,LOCATION_MZONE,0,nil)
		return Duel.IsExistingMatchingCard(c101112071.scfilter,tp,LOCATION_EXTRA,0,1,nil,mg)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c101112071.scop(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetMatchingGroup(c101112071.mfilter,tp,LOCATION_MZONE,0,nil)
	local g=Duel.GetMatchingGroup(c101112071.scfilter,tp,LOCATION_EXTRA,0,nil,mg)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local tg=mg:FilterSelect(tp,c101112071.cfilter,1,1,nil,sg:GetFirst())
		Duel.SynchroSummon(tp,sg:GetFirst(),tg:GetFirst())
	end
end
function c101112071.rcfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x188)
end
function c101112071.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c101112071.rcfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c101112071.rmtg(e,c)
	local tp=e:GetHandlerPlayer()
	return c:GetOwner()==1-tp and Duel.IsPlayerCanRemove(tp,c) 
		and (c:GetReason()&(REASON_RELEASE+REASON_RITUAL)==(REASON_RELEASE+REASON_RITUAL)
		or c:IsReason(REASON_FUSION+REASON_SYNCHRO+REASON_LINK))
end