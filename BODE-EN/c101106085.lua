--Beetrooper Assault Roller
function c101106085.initial_effect(c)
	--Special Summon procedure
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,101106085+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c101106085.spcon)
	e1:SetOperation(c101106085.spop)
	c:RegisterEffect(e1)
	--Increase ATK
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(c101106085.atkval)
	c:RegisterEffect(e2)
	--Search 1 "Beetroper" monster
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(101106085,1))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLE_DESTROYED)
	e3:SetCountLimit(1,101106085+100)
	e3:SetTarget(c101106085.adtg)
	e3:SetOperation(c101106085.adop)
	c:RegisterEffect(e3)
end
function c101106085.spfilter(c,tp)
	return c:IsRace(RACE_INSECT) and c:IsAbleToRemoveAsCost()
end
function c101106085.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c101106085.spfilter,tp,LOCATION_GRAVE,0,1,nil)
end
function c101106085.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c101106085.spfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c101106085.atkfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_INSECT)
end
function c101106085.atkval(e,c)
	return Duel.GetMatchingGroupCount(c101106085.atkfilter,c:GetControler(),LOCATION_MZONE,0,c)*200
end
function c101106085.adfilter(c)
	return c:IsSetCard(0x170) and c:IsType(TYPE_MONSTER) and not c:IsCode(101106085) and c:IsAbleToHand()
end
function c101106085.adtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101106085.adfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c101106085.adop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c101106085.adfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
