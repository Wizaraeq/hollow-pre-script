--ドラスティック・ドロー
function c100207027.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100207027,0))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,100207027,EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c100207027.cost)
	e1:SetTarget(c100207027.target)
	e1:SetOperation(c100207027.activate)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(100207027,ACTIVITY_SUMMON,c100207027.counterfilter)
	Duel.AddCustomActivityCounter(100207027,ACTIVITY_SPSUMMON,c100207027.counterfilter)
end
function c100207027.counterfilter(c)
	return c:IsRace(RACE_CYBERSE)
end
function c100207027.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemoveAsCost,tp,LOCATION_MZONE,0,nil)
	if chk==0 then return ct>1 and #g==ct
		and Duel.GetCustomActivityCount(100207027,tp,ACTIVITY_SUMMON)==0
		and Duel.GetCustomActivityCount(100207027,tp,ACTIVITY_SPSUMMON)==0 end
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c100207027.splimit)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_SUMMON)
	Duel.RegisterEffect(e2,tp)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c100207027.splimit(e,c)
	return not c:IsRace(RACE_CYBERSE)
end
function c100207027.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,3) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(3)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,3)
end
function c100207027.activate(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end