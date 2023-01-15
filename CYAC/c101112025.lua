--フルアクティブ・デュプレックス
function c101112025.initial_effect(c)
	--Linked monsters can make up to 2 attacks on monsters
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_EXTRA_ATTACK_MONSTER)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsLinkState))
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--Special summon procedure from the hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101112025,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,101112025)
	e2:SetCost(c101112025.spcost)
	e2:SetTarget(c101112025.sptg)
	e2:SetOperation(c101112025.spop)
	c:RegisterEffect(e2)
	--Increase the ATK of a Cyberse monster by 1000
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(101112025,1))
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCountLimit(1,101112025+100)
	e3:SetTarget(c101112025.atktg)
	e3:SetOperation(c101112025.atkop)
	c:RegisterEffect(e3)
end
function c101112025.spcostfilter(c)
	return c:IsType(TYPE_LINK) and c:IsAbleToRemoveAsCost()
end
function c101112025.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101112025.spcostfilter,tp,LOCATION_GRAVE,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg=Duel.SelectMatchingCard(tp,c101112025.spcostfilter,tp,LOCATION_GRAVE,0,2,2,nil)
	Duel.Remove(sg,POS_FACEUP,REASON_COST)
end
function c101112025.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c101112025.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c101112025.filter(c)
	return c:IsFaceup() and c:IsRace(RACE_CYBERSE)
end
function c101112025.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c101112025.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101112025.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c101112025.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c101112025.atkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(1000)
		tc:RegisterEffect(e1)
	end
end
