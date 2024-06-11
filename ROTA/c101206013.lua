--原石竜インペリアル・ドラゴン
local s,id,o=GetID()
function s.initial_effect(c)
	--summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_LIMIT_SUMMON_PROC)
	e1:SetCondition(s.sumcon1)
	e1:SetOperation(s.sumop1)
	e1:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e1)
	--normal summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_HAND)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e2:SetCountLimit(1,id)
	e2:SetCondition(s.sumcon2)
	e2:SetCost(s.sumcost2)
	e2:SetTarget(s.sumtg2)
	e2:SetOperation(s.sumop2)
	c:RegisterEffect(e2)
	--effect
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_DISABLE+CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCondition(s.effcon)
	e3:SetTarget(s.efftg)
	e3:SetOperation(s.effop)
	c:RegisterEffect(e3)
end
function s.mfilter(c,tp)
	return c:IsType(TYPE_NORMAL) and (c:IsControler(tp) or c:IsFaceup())
end
function s.sumcon1(e,c,minc)
	if c==nil then return true end
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(s.mfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,tp)
	return minc<=1 and Duel.CheckTribute(c,1,1,mg)
end
function s.sumop1(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=Duel.GetMatchingGroup(s.mfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,tp)
	local sg=Duel.SelectTribute(tp,c,1,1,mg)
	c:SetMaterial(sg)
	Duel.Release(sg,REASON_SUMMON+REASON_MATERIAL)
end
function s.sumcon2(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2) and Duel.GetTurnPlayer()==1-tp
end
function s.sumcost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
end
function s.filter(c)
	return c:IsSetCard(0x2b9) and c:IsSummonable(true,nil)
end
function s.sumtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function s.sumop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_HAND,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.Summon(tp,g:GetFirst(),true,nil)
	end
end
function s.effcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_ADVANCE)
end
function s.rmfilter1(c,tp)
	return c:IsAbleToRemove() and Duel.IsExistingMatchingCard(s.rmfilter2,tp,LOCATION_GRAVE,0,1,nil,c:GetRace(),c:GetAttribute())
end
function s.rmfilter2(c,race,att)
	return c:IsType(TYPE_NORMAL) and (c:IsRace(race) or c:IsAttribute(att)) 
end
function s.efftg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g1=Duel.GetMatchingGroup(aux.NegateMonsterFilter,tp,0,LOCATION_MZONE,nil)
	local g2=Duel.GetMatchingGroup(s.rmfilter1,tp,0,LOCATION_MZONE,nil,tp)
	if chk==0 then return #g1>0 or Duel.IsExistingMatchingCard(s.rmfilter1,tp,0,LOCATION_MZONE,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g1,g1:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g2,g2:GetCount(),0,0)
end
function s.effop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.NegateMonsterFilter,tp,0,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	while tc do
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
		tc=g:GetNext()
	end
	local g=Duel.GetMatchingGroup(s.rmfilter1,tp,0,LOCATION_MZONE,nil,tp)
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
end
function s.disable(e,c)
	return c:IsType(TYPE_EFFECT) or c:GetOriginalType()&TYPE_EFFECT~=0
end