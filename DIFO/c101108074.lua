--肆世壊の牙掌突
function c101108074.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--Target can attack while in Defense Position
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101108074,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c101108074.atktg)
	e1:SetOperation(c101108074.atkop)
	c:RegisterEffect(e1)
	--Negate that effect
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101108074,1))
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,101108074)
	e2:SetCondition(c101108074.discon)
	e2:SetCost(c101108074.discost)
	e2:SetTarget(c101108074.distg)
	e2:SetOperation(c101108074.disop)
	c:RegisterEffect(e2)
end
function c101108074.atkfilter(c)
	return c:IsFaceup() and (c:IsSetCard(0x27b) or c:IsCode(101108008)) and not c:IsHasEffect(EFFECT_CANNOT_ATTACK)
end
function c101108074.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c6430659.atkfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101108074.atkfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.SelectTarget(tp,c101108074.atkfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c101108074.atkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not (tc:IsRelateToEffect(e) and tc:IsFaceup()) then return end
	--Can attack while in Defense Position
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DEFENSE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c101108074.atkval)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	tc:RegisterEffect(e1)
end
function c101108074.atkval(e,c)
	if c:GetAttack()>c:GetDefense() then
		return 0
	else
		return 1
	end
end
function c101108074.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x27b) and c:GetSequence()>=5
end
function c101108074.discon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and Duel.IsChainDisablable(ev) and Duel.IsExistingMatchingCard(c101108074.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c101108074.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() and c:IsStatus(STATUS_EFFECT_ENABLED) end
	Duel.SendtoGrave(c,REASON_COST)
end
function c101108074.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not re:GetHandler():IsDisabled() end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function c101108074.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end 