--斬リ番
function c101201080.initial_effect(c)
	--Special Summon this card as an Effect Monster
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101201080,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER_E)
	e1:SetCondition(c101201080.spcon)
	e1:SetTarget(c101201080.sptg)
	e1:SetOperation(c101201080.spop)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(101201080,ACTIVITY_CHAIN,aux.FALSE)
	--Destroy as many cards as possible
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101201080,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c101201080.descon)
	e2:SetTarget(c101201080.destg)
	e2:SetOperation(c101201080.desop)
	c:RegisterEffect(e2)
end
function c101201080.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCustomActivityCount(101201080,0,ACTIVITY_CHAIN)+Duel.GetCustomActivityCount(101201080,1,ACTIVITY_CHAIN)>=10
end
function c101201080.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,101201080,0,TYPES_EFFECT_TRAP_MONSTER,3000,3000,9,RACE_CYBERSE,ATTRIBUTE_DARK) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c101201080.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,101201080,0,TYPES_EFFECT_TRAP_MONSTER,3000,3000,10,RACE_CYBERSE,ATTRIBUTE_DARK) then return end
	c:AddMonsterAttribute(TYPE_EFFECT+TYPE_TRAP)
	Duel.SpecialSummon(c,SUMMON_VALUE_SELF,tp,tp,true,false,POS_FACEUP)
end
function c101201080.descon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp
end
function c101201080.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_ONFIELD,nil)
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
end
function c101201080.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_ONFIELD,nil)
	if Duel.Destroy(g,REASON_EFFECT)>0 and c:IsRelateToEffect(e) and c:IsSSetable(true) then
		Duel.BreakEffect()
		Duel.SSet(tp,c,tp,false)
	end
end