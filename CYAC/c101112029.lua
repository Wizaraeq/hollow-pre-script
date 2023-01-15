--百檎龍－リンゴブルム
function c101112029.initial_effect(c)
	--Special Summon from hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101112029,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,101112029)
	e1:SetCondition(c101112029.spcon)
	e1:SetTarget(c101112029.sptg)
	e1:SetOperation(c101112029.spop)
	c:RegisterEffect(e1)
	--Special Summon Token
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101112029,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,101112029+100)
	e2:SetCondition(c101112029.tkcon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c101112029.tktg)
	e2:SetOperation(c101112029.tkop)
	c:RegisterEffect(e2)
	Duel.AddCustomActivityCounter(101112029,ACTIVITY_SPSUMMON,c101112029.counterfilter)
end
function c101112029.counterfilter(c)
	return not (c:IsType(TYPE_SYNCHRO) and c:IsSummonType(SUMMON_TYPE_SYNCHRO))
end
function c101112029.spcfilter(c)
	return not c:IsType(TYPE_EFFECT) and c:IsFaceup()
end
function c101112029.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c101112029.spcfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c101112029.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c101112029.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c101112029.tkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCustomActivityCount(101112029,tp,ACTIVITY_SPSUMMON)>0
end
function c101112029.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,101112129,0,TYPES_TOKEN_MONSTER,100,100,2,RACE_WYRM,ATTRIBUTE_LIGHT) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
end
function c101112029.tkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,101112129,0,TYPES_TOKEN_MONSTER,100,100,2,RACE_WYRM,ATTRIBUTE_LIGHT) then
		local token=Duel.CreateToken(tp,101112129)
		if Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e1:SetCode(EFFECT_ADD_TYPE)
		e1:SetValue(TYPE_TUNER)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
		token:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e2:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
		e2:SetValue(c101112029.linklimit)
		e2:SetReset(RESET_EVENT+0xff0000)
		token:RegisterEffect(e2)
		end
		Duel.SpecialSummonComplete()
	end
end
function c101112029.linklimit(e,c)
	if not c then return false end
	return c:IsCode(50588353)
end