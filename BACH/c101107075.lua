--ＤＤＤヘッドハント
function c101107075.initial_effect(c)
	--Take control of an opponent's monster until end phase
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101107075,0))
	e1:SetCategory(CATEGORY_CONTROL)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetCountLimit(1,101107075+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c101107075.condition)
	e1:SetTarget(c101107075.target)
	e1:SetOperation(c101107075.activate)
	c:RegisterEffect(e1)
end
function c101107075.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x10af)
end
function c101107075.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c101107075.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c101107075.filter(c)
	return c:IsFaceup() and c:IsControlerCanBeChanged()
end
function c101107075.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return c101107075.filter(chkc) and chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(c101107075.filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectTarget(tp,c101107075.filter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
end
function c101107075.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and Duel.GetControl(tc,tp,PHASE_END,2) then
		--Negate its effects
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		tc:RegisterEffect(e2)
		--Cannot declare an attack
		local e3=e1:Clone()
		e3:SetCode(EFFECT_CANNOT_ATTACK)
		tc:RegisterEffect(e3)
		if tc:IsSummonType(SUMMON_TYPE_SPECIAL) and tc:IsSummonLocation(LOCATION_EXTRA) then
			--Treated as a "D/D/D" monster
			local e4=Effect.CreateEffect(c)
			e4:SetDescription(aux.Stringid(101107075,1))
			e4:SetProperty(EFFECT_FLAG_CLIENT_HINT)
			e4:SetType(EFFECT_TYPE_SINGLE)
			e4:SetCode(EFFECT_ADD_SETCODE)
			e4:SetValue(0x10af)
			e4:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e4)
		end
	end
end