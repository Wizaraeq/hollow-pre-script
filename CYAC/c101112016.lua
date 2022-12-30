--ネムレリアの夢守り－オレイエ
function c101112016.initial_effect(c)
	-- Special Summon itself from the hand
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,101112016+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c101112016.spcon)
	c:RegisterEffect(e1)
	-- Gains 500 ATK for each of opponent's monster
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101112016,0))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(TIMING_DAMAGE_STEP,TIMING_DAMAGE_STEP+TIMINGS_CHECK_MONSTER)
	e2:SetCountLimit(1,101112016+100)
	e2:SetCondition(c101112016.atkcon)
	e2:SetCost(c101112016.atkcost)
	e2:SetTarget(c101112016.atktg)
	e2:SetOperation(c101112016.atkop)
	c:RegisterEffect(e2)
end
function c101112016.filter(c)
	return c:IsFaceup() and c:IsCode(101112015)
end
function c101112016.spcfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM)
end
function c101112016.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c101112016.spcfilter,tp,LOCATION_EXTRA,0,1,nil)
end
function c101112016.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c101112016.filter,tp,LOCATION_EXTRA,0,1,nil)
		and (Duel.GetCurrentPhase()~=PHASE_DAMAGE or not Duel.IsDamageCalculated())
end
function c101112016.cfilter(c)
	return c:IsFacedown() and c:IsAbleToRemoveAsCost(POS_FACEDOWN)
end
function c101112016.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101112016.cfilter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c101112016.cfilter,tp,LOCATION_EXTRA,0,1,1,nil)
	Duel.Remove(g,POS_FACEDOWN,REASON_COST)
end
function c101112016.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>0 end
end
function c101112016.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not (c:IsFaceup() and c:IsRelateToEffect(e)) then return end
	local ct=Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)
	if ct==0 then return end
	-- Increase ATK
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(ct*500)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
end