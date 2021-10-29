--Heritage of the Light
function c101106000.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Draw 1 card
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,101106000)
	e2:SetCondition(c101106000.drcon)
	e2:SetTarget(c101106000.drtg)
	e2:SetOperation(c101106000.drop)
	c:RegisterEffect(e2)
end
function c101106000.filter(c,ct)
	return c:IsFaceup() and c:IsType(ct)
end
function c101106000.typecheck(sc,ct)
	return Duel.IsExistingMatchingCard(c101106000.filter,0,LOCATION_MZONE,LOCATION_MZONE,1,sc,ct)
end
function c101106000.drcfilter(c)
	if c:IsSummonType(SUMMON_TYPE_RITUAL) then
		return c101106000.typecheck(c,TYPE_RITUAL)
	elseif c:IsSummonType(SUMMON_TYPE_FUSION) then
		return c101106000.typecheck(c,TYPE_FUSION)
	elseif c:IsSummonType(SUMMON_TYPE_SYNCHRO) then
		return c101106000.typecheck(c,TYPE_SYNCHRO)
	elseif c:IsSummonType(SUMMON_TYPE_XYZ) then
		return c101106000.typecheck(c,TYPE_XYZ)
	else
		return false
	end
end
function c101106000.drcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c101106000.drcfilter,1,nil)
end
function c101106000.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c101106000.drop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
