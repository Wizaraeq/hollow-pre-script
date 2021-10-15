--機怪獣ダレトン
function c101107033.initial_effect(c)
	-- Gain ATK
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c101107033.atktg)
	e1:SetOperation(c101107033.atkop)
	c:RegisterEffect(e1)
end
function c101107033.atkfilter(c)
	return c:IsFaceup() and not c:IsAttack(c:GetBaseAttack())
end
function c101107033.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101107033.atkfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
end
function c101107033.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c101107033.atkfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if #g<1 then return end
	local sum=0
	for tc in aux.Next(g) do
		sum=sum+(math.abs(tc:GetBaseAttack()-tc:GetAttack()))
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_BASE_ATTACK)
	e1:SetValue(sum)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
	c:RegisterEffect(e1)
end