--地縛解放
function c100207012.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100207012,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCost(c100207012.cost)
	e1:SetTarget(c100207012.target)
	e1:SetOperation(c100207012.operation)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
end
function c100207012.costfilter(c)
	return c:IsSetCard(0x21) and c:IsLevel(10)
end
function c100207012.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c100207012.costfilter,1,nil) end
	local g=Duel.SelectReleaseGroup(tp,c100207012.costfilter,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function c100207012.filter(c,tp)
	return c:IsFaceup() and c:IsLevelAbove(6) and c:IsSummonPlayer(1-tp)
end
function c100207012.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c100207012.filter,1,nil,tp) end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	local dam=g:GetSum(Card.GetBaseAttack)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam)
end
function c100207012.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	if Duel.Destroy(g,REASON_EFFECT)>0 then
		local dam=Duel.GetOperatedGroup():GetSum(Card.GetBaseAttack)
		Duel.Damage(1-tp,dam,REASON_EFFECT)
	end
end