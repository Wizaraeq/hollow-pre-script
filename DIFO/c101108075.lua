--肆世壊の継承
function c101108075.initial_effect(c)
	--spsummon limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCost(c101108075.limcost)
	e1:SetOperation(c101108075.limop)
	c:RegisterEffect(e1)
	--Damage
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101108075,1))
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,101108075)
	e2:SetCondition(c101108075.damcon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c101108075.damtg)
	e2:SetOperation(c101108075.damop)
	c:RegisterEffect(e2)
end
function c101108075.limcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,Card.IsSetCard,3,nil,0x27b) end
	local g=Duel.SelectReleaseGroup(tp,Card.IsSetCard,3,3,nil,0x27b)
	Duel.Release(g,REASON_COST)
end
function c101108075.limop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--splimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(0,1)
	e1:SetTarget(c101108075.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetOperation(c101108075.splimit0)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function c101108075.splimit(e,c,sump,sumtype,sumpos,targetp)
	return c:IsType(TYPE_LINK)
end
function c101108075.posfilter(c,tp)
	return c:IsAttackPos() and c:IsSummonPlayer(1-tp)
end
function c101108075.splimit0(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c101108075.posfilter,nil,tp)
	Duel.ChangePosition(g,POS_FACEUP_DEFENSE)
end
function c101108075.damcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c101108075.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local dg=Duel.GetMatchingGroup(Card.IsDefensePos,0,LOCATION_MZONE,LOCATION_MZONE,nil)
	if chk==0 then return #dg>0 end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,#dg*100)
end
function c101108075.damop(e,tp,eg,ep,ev,re,r,rp)
	local dg=Duel.GetMatchingGroup(Card.IsDefensePos,0,LOCATION_MZONE,LOCATION_MZONE,nil)
	if #dg==0 then return end
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.Damage(p,#dg*100,REASON_EFFECT)
end