--時を裂く魔瞳
function c101112067.initial_effect(c)
	--Apply effects for the rest of the Duel
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101112067,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c101112067.target)
	e1:SetOperation(c101112067.activate)
	c:RegisterEffect(e1)
	--Prevent activations when you Normal Summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101112067,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(c101112067.gycost)
	e2:SetTarget(c101112067.gytg)
	e2:SetOperation(c101112067.gyop)
	c:RegisterEffect(e2)
end
function c101112067.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,101112067)==0 end
end
function c101112067.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,101112067,0,0,1)
	local c=e:GetHandler()
	--Cannot activate monsters effects from the hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101112067,1))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(1,0)
	e1:SetValue(c101112067.aclimit)
	Duel.RegisterEffect(e1,tp)
	--Can Normal Summon/Set twice per turn
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SET_SUMMON_COUNT_LIMIT)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	e2:SetValue(2)
	Duel.RegisterEffect(e2,tp)
	--Draw 2 cards during the Draw Phase
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_DRAW_COUNT)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(1,0)
	e3:SetValue(2)
	Duel.RegisterEffect(e3,tp)
end
function c101112067.aclimit(e,re,tp)
	local rc=re:GetHandler()
	return rc and rc:IsLocation(LOCATION_HAND) and re:IsActiveType(TYPE_MONSTER)
end
function c101112067.cfilter(c)
	return c:IsCode(101112067) and c:IsDiscardable()
end
function c101112067.gycost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemoveAsCost() and Duel.IsExistingMatchingCard(c101112067.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Remove(c,POS_FACEUP,REASON_COST)
	Duel.DiscardHand(tp,c101112067.cfilter,1,1,REASON_COST+REASON_DISCARD)
end
function c101112067.gytg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,101112067+100)==0 end
end
function c101112067.gyop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,101112067+100,RESET_PHASE+PHASE_END,0,1)
	--Prevent activations when you Normal Summon
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c101112067.limcon)
	e1:SetOperation(c101112067.limop)
	Duel.RegisterEffect(e1,tp)
end
function c101112067.limcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsSummonPlayer,1,nil,tp)
end
function c101112067.limop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetChainLimitTillChainEnd(c101112067.chainlm)
end
function c101112067.chainlm(re,rp,tp)
	return tp==rp or not re:IsActiveType(TYPE_MONSTER)
end