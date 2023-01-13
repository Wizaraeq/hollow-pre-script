--氷水帝エジル・ラーン
function c101112010.initial_effect(c)
	--Special Summon itself from the hand then Special Summon 1 "Icejade Token"
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101112010,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,101112010)
	e1:SetCost(c101112010.spcost)
	e1:SetTarget(c101112010.sptg)
	e1:SetOperation(c101112010.spop)
	c:RegisterEffect(e1)
	--Change name to "Icejade Cenote Enion Cradle" while equipped
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_CHANGE_CODE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(7142724)
	e2:SetCondition(c101112010.eqcon)
	c:RegisterEffect(e2)
end
function c101112010.cfilter(c)
	return c:IsDiscardable() and (c:IsSetCard(0x16c) or (c:IsType(TYPE_MONSTER) and c:IsAttribute(ATTRIBUTE_WATER)))
end
function c101112010.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c101112010.cfilter,tp,LOCATION_HAND,0,1,c) end
	Duel.DiscardHand(tp,c101112010.cfilter,1,1,REASON_COST+REASON_DISCARD,c)
end
function c101112010.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c101112010.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,1,tp,tp,false,false,POS_FACEUP)>0
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,101112110,0x16c,TYPES_TOKEN_MONSTER,0,0,3,RACE_AQUA,ATTRIBUTE_WATER)
		and Duel.SelectYesNo(tp,aux.Stringid(101112010,1)) then
		Duel.BreakEffect()
		local token=Duel.CreateToken(tp,101112110)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetRange(LOCATION_MZONE)
		e1:SetAbsoluteRange(tp,1,0)
		e1:SetTarget(c101112010.splimit)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		token:RegisterEffect(e1,true)
		Duel.SpecialSummonComplete()
	end
end
function c101112010.splimit(e,c)
	return not c:IsAttribute(ATTRIBUTE_WATER) and c:IsLocation(LOCATION_EXTRA)
end
function c101112010.eqcon(e)
	return e:GetHandler():GetEquipCount()>0
end
