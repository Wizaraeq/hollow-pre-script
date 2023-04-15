--トーテムポール
function c100207011.initial_effect(c)
	Duel.EnableGlobalFlag(GLOBALFLAG_SELF_TOGRAVE)
	c:EnableCounterPermit(0x165)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetHintTiming(0,TIMING_ATTACK)
	c:RegisterEffect(e0)
	--Opponent cannot target monsters with 0 original ATK with card effects
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(aux.TargetBoolFunction(c100207011.filter))
	e1:SetValue(aux.tgoval)
	c:RegisterEffect(e1)
	--Negate attack
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100207011,0))
	e2:SetCategory(CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c100207011.btcon)
	e2:SetCost(c100207011.btcost)
	e2:SetOperation(c100207011.btop)
	c:RegisterEffect(e2)
	--Send this card to the GY
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_SELF_TOGRAVE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(c100207011.tgcon)
	c:RegisterEffect(e3)
	--Double any effect damage the opponent takes this turn
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(100207011,1))
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCondition(c100207011.damcon)
	e4:SetCost(aux.bfgcost)
	e4:SetOperation(c100207011.damop)
	c:RegisterEffect(e4)
end
function c100207011.btcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker():IsControler(1-tp)
end
function c100207011.filter(c)
	return c:IsRace(RACE_ROCK) and c:GetBaseAttack()==0
end
function c100207011.btcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(100207011)==0 and c:IsCanAddCounter(0x165,1) end
	c:RegisterFlagEffect(100207011,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE,0,1)
end
function c100207011.btop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.NegateAttack() and c:IsRelateToEffect(e) and c:IsCanAddCounter(0x165,1) then
		Duel.BreakEffect()
		c:AddCounter(0x165,1)
	end
end
function c100207011.tgcon(e)
	return e:GetHandler():GetCounter(0x165)>=3
end
function c100207011.damcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetMatchingGroup(c100207011.filter,tp,LOCATION_GRAVE,0,nil):GetClassCount(Card.GetCode)>=3
end
function c100207011.damop(e,tp,eg,ep,ev,re,r,rp)
	--Double effect damage
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetTargetRange(0,1)
	e1:SetValue(c100207011.damval)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c100207011.damval(e,re,val)
	return val*2
end