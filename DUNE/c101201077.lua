--断絶の落とし穴
function c101201077.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101201077,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(c101201077.target)
	e1:SetOperation(c101201077.activate)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
end
function c101201077.remfilter(c,tp)
	return c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and c:GetAttack()<=1500
		and c:IsSummonPlayer(1-tp) and c:IsAbleToRemove()
end
function c101201077.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=eg:Filter(c101201077.remfilter,nil,tp)
	if chk==0 then return #g>0 end
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,#g,tp,0)
end
function c101201077.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c101201077.remfilter,nil,tp)
	if g:GetCount()>0 then
		Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
	end
end
