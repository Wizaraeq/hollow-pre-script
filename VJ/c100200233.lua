--ローズ・パピヨン
function c100200233.initial_effect(c)
	--Additional Tribute Summon of a Level 7 or higher monster
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100200233,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_HAND,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsLevelAbove,7))
	e1:SetValue(0x1)
	c:RegisterEffect(e1)
	--Can attack directly while you control another Insect monster
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DIRECT_ATTACK)
	e2:SetCondition(c100200233.atkcond)
	c:RegisterEffect(e2)
end
function c100200233.atkfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_INSECT)
end
function c100200233.atkcond(e)
	return Duel.IsExistingMatchingCard(c100200233.atkfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,e:GetHandler())
end 