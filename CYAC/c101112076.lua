--ダイノルフィア・インタクト
function c101112076.initial_effect(c)
	--Negate activation of a monster effect
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101112076,0))
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,101112076,EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c101112076.condition)
	e1:SetCost(c101112076.cost)
	e1:SetTarget(c101112076.target)
	e1:SetOperation(c101112076.activate)
	c:RegisterEffect(e1)
	--Prevent battle damage
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101112076,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c101112076.nodamcon)
	e2:SetCost(aux.bfgcost)
	e2:SetOperation(c101112076.nodamop)
	c:RegisterEffect(e2)
end
function c101112076.cfilter(c)
	return c:IsSetCard(0x173) and c:IsFaceup()
end
function c101112076.condition(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_MONSTER) and Duel.IsChainNegatable(ev)
		and Duel.IsExistingMatchingCard(c101112076.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c101112076.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.PayLPCost(tp,Duel.GetLP(tp)//2)
end
function c101112076.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	local rc=re:GetHandler()
	if rc:IsDestructable() and rc:IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c101112076.activate(e,tp,eg,ep,ev,re,r,rp)
	--Change battle damage
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e1:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE)
	e1:SetTargetRange(1,0)
	e1:SetValue(c101112076.damval)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	--Negate the activation and destroy the monster
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function c101112076.damval(e)
	return Duel.GetLP(e:GetHandlerPlayer())/2
end
function c101112076.nodamcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLP(tp)<=2000 and Duel.GetBattleDamage(tp)>0
end
function c101112076.nodamop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
	Duel.RegisterEffect(e1,tp)
end