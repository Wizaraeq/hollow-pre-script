--円喚師フェアリ
function c101111025.initial_effect(c)
	-- Special Summon itself from the hand
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,101111025+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c101111025.spcon)
	c:RegisterEffect(e1)
	-- Can be used as a non-Tuner
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_NONTUNER)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c101111025.ntval)
	c:RegisterEffect(e2)
end
function c101111025.spcon(e,c)
	if c==nil then return true end
	return Duel.IsExistingMatchingCard(Card.IsRace,0,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,RACE_PLANT+RACE_INSECT)
		and Duel.GetLocationCount(e:GetHandlerPlayer(),LOCATION_MZONE)>0
end
function c101111025.ntval(e,c)
	return e:GetHandler():IsControler(c:GetControler()) and c:IsRace(RACE_PLANT+RACE_INSECT)
end