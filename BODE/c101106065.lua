--聖蔓の播種
function c101106065.initial_effect(c)
	--Special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101106065,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,101106065+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c101106065.sptg)
	e1:SetOperation(c101106065.spop)
	c:RegisterEffect(e1)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetTarget(c101106065.reptg)
	e2:SetValue(c101106065.repval)
	e2:SetOperation(c101106065.repop)
	c:RegisterEffect(e2)
end
function c101106065.lcfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_LINK) and c:IsSetCard(0x2158)
end
function c101106065.spfilter(c,e,tp,check)
	return c:IsSetCard(0x4158) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
		and (check or c:IsCode(27520594))
end
function c101106065.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		local chk1=Duel.IsExistingMatchingCard(c101106065.lcfilter,tp,LOCATION_MZONE,0,1,nil)
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsExistingMatchingCard(c101106065.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,chk1)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,1000)
end
function c101106065.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local chk1=Duel.IsExistingMatchingCard(c101106065.lcfilter,tp,LOCATION_MZONE,0,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c101106065.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,chk1)
	local tc=g:GetFirst()
	if #g>0 and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
		Duel.Damage(tp,1000,REASON_EFFECT)
	end
	Duel.SpecialSummonComplete()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c101106065.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c101106065.splimit(e,c)
	return not c:IsRace(RACE_PLANT) and c:IsLocation(LOCATION_EXTRA)
end
function c101106065.repfilter(c,tp)
	return c:IsFaceup() and c:IsLocation(LOCATION_MZONE) and c:IsControler(tp) and c:IsRace(RACE_PLANT) and c:IsType(TYPE_LINK)
		and (c:IsReason(REASON_BATTLE) or (c:IsReason(REASON_EFFECT) and c:GetReasonPlayer()==1-tp)) and not c:IsReason(REASON_REPLACE)
end
function c101106065.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemove() and eg:IsExists(c101106065.repfilter,1,nil,tp) end
	return Duel.SelectEffectYesNo(tp,c,96)
end
function c101106065.repval(e,c)
	return c101106065.repfilter(c,e:GetHandlerPlayer())
end
function c101106065.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end
