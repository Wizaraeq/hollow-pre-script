--マルチャミー・プルリア
local s,id,o=GetID()
function s.initial_effect(c)
	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(s.cost)
	e1:SetCondition(s.condition)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(id,ACTIVITY_CHAIN,s.counterfilter)
end
function s.counterfilter(re,tp,cid)
	return not (re:GetHandler():IsSetCard(0x1b2) and re:IsActiveType(TYPE_MONSTER))
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0)==0
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() and Duel.GetCustomActivityCount(id,tp,ACTIVITY_CHAIN)<2 end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
	local c=e:GetHandler()
	--activate check
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetCode(EVENT_CHAINING)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetOperation(s.aclimit)
	Duel.RegisterEffect(e1,tp)
	--activate limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	e2:SetReset(RESET_PHASE+PHASE_END)
	e2:SetCondition(s.econ)
	e2:SetValue(s.elimit)
	Duel.RegisterEffect(e2,tp)
end
function s.aclimit(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if ep~=tp or not (re:IsActiveType(TYPE_MONSTER) and rc and rc:IsSetCard(0x1b2) and not rc:IsCode(id)) then return end
	Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
end
function s.econ(e)
	return Duel.GetFlagEffect(e:GetHandlerPlayer(),id)~=0
end
function s.elimit(e,te,tp)
	local tc=te:GetHandler()
	return te:IsActiveType(TYPE_MONSTER) and tc:IsSetCard(0x1b2) and not tc:IsCode(id)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(s.reccon)
	e2:SetOperation(s.recop)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	Duel.RegisterEffect(e3,tp)
	--shuffle
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_PHASE+PHASE_END)
	e6:SetCountLimit(1)
	e6:SetOperation(s.tdop)
	e6:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e6,tp)
end
function s.cfilter(c,tp)
	return c:IsSummonPlayer(tp) and c:IsPreviousLocation(LOCATION_HAND)
end
function s.reccon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter,1,nil,1-tp)
end
function s.recop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,id)
	Duel.Draw(tp,1,REASON_EFFECT)
end
function s.tdop(e,tp,eg,ep,ev,re,r,rp)
	local dif=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)-(Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)+6)
	if dif>0 then
		local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0):Filter(Card.IsAbleToDeck,nil):RandomSelect(tp,dif)
		if #g==0 then return end
		Duel.Hint(HINT_CARD,1-tp,id)
		Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
end