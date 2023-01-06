--鉄獣の咆哮
function c101112053.initial_effect(c)
	--Send 1 "Tri-Brigade" card to the GY and apply a matching effect
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101112053,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_DAMAGE_STEP,TIMING_DAMAGE_STEP+TIMINGS_CHECK_MONSTER)
	e1:SetCountLimit(1,101112053,EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c101112053.condition)
	e1:SetTarget(c101112053.target)
	e1:SetOperation(c101112053.activate)
	c:RegisterEffect(e1)
end
function c101112053.filter(c)
	return c:IsType(TYPE_LINK)
end
function c101112053.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c101112053.filter,tp,LOCATION_MZONE,0,1,nil)
end
function c101112053.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_EFFECT) 
end
function c101112053.cfilter1(c)
	return c101112053.cfilter(c) and c:GetAttack()>0
end
function c101112053.cfilter2(c)
	return c101112053.cfilter(c) and aux.NegateMonsterFilter(c)
end
function c101112053.cfilter3(c)
	return c101112053.cfilter(c) and c:IsAbleToHand()
end
function c101112053.costfilter(c,op1,op2,op3)
	return c:IsSetCard(0x14d) and c:IsAbleToGraveAsCost() and
		((c:IsType(TYPE_MONSTER) and op1) or (c:IsType(TYPE_SPELL) and op2) or (c:IsType(TYPE_TRAP) and op3))
end
function c101112053.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local phase=Duel.GetCurrentPhase()
	local op1=Duel.IsExistingTarget(c101112053.cfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) and (phase~=PHASE_DAMAGE or not Duel.IsDamageCalculated())
	local op2=Duel.IsExistingTarget(c101112053.cfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) and phase~=PHASE_DAMAGE
	local op3=Duel.IsExistingTarget(c101112053.cfilter3,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) and phase~=PHASE_DAMAGE
	if chk==0 then return (op1 or op2 or op3) and Duel.IsExistingMatchingCard(c101112053.costfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil,op1,op2,op3) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sc=Duel.SelectMatchingCard(tp,c101112053.costfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil,op1,op2,op3):GetFirst()
	Duel.SendtoGrave(sc,REASON_COST)
	if sc:IsType(TYPE_MONSTER) then
		e:SetLabel(1)
		e:SetCategory(CATEGORY_ATKCHANGE)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATKDEF)
		local tc=Duel.SelectTarget(tp,c101112053.cfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil):GetFirst()
		Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,tc,1,tp,-tc:GetAttack())
	elseif sc:IsType(TYPE_SPELL) then
		e:SetLabel(2)
		e:SetCategory(CATEGORY_DISABLE)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_NEGATE)
		local g=Duel.SelectTarget(tp,c101112053.cfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
		Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
	elseif sc:IsType(TYPE_TRAP) then
		e:SetLabel(3)
		e:SetCategory(CATEGORY_TOHAND)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local g=Duel.SelectTarget(tp,c101112053.cfilter3,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	end
end
function c101112053.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	if e:GetLabel()==1 and tc:IsFaceup() then
		--Change its ATK to 0 until the end of this turn
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(0)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	elseif e:GetLabel()==2 and tc:IsFaceup() then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		--Negate its effects until the end of this turn
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		tc:RegisterEffect(e2)
	elseif e:GetLabel()==3 then
		--Return it to the hand
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end