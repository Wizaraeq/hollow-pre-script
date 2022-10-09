--完全態・グレート・インセクト
function c101111035.initial_effect(c)
	c:SetSPSummonOnce(101111035)
	--fusion material
	aux.AddFusionProcFun2(c,c101111035.mfilter1,c101111035.mfilter2,true)
	c:EnableReviveLimit()
	-- Special Summon limitation
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(c101111035.splimit)
	c:RegisterEffect(e0)
	-- Alternate summon procedure
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c101111035.hspcon)
	e1:SetOperation(c101111035.hspop)
	c:RegisterEffect(e1)
	-- Cannot be destroyed by battle
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	-- Destroy all opponent monsters
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(101111035,0))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetHintTiming(0,TIMING_BATTLE_START+TIMING_BATTLE_END)
	e3:SetCondition(c101111035.descon)
	e3:SetTarget(c101111035.destg)
	e3:SetOperation(c101111035.desop)
	c:RegisterEffect(e3)
end
function c101111035.mfilter1(c)
	return c:IsRace(RACE_INSECT) and c:IsLevel(8)
end
function c101111035.mfilter2(c)
	return c:IsRace(RACE_INSECT) and c:IsLevel(7)
end
function c101111035.splimit(e,se,sp,st)
	return aux.fuslimit(e,se,sp,st) or not e:GetHandler():IsLocation(LOCATION_EXTRA)
end
function c101111035.sprfilter(c,tp,sc)
	return c:IsRace(RACE_INSECT) and c:IsDefenseAbove(2000) and c:GetEquipCount()>0
		and Duel.GetLocationCountFromEx(tp,tp,c,sc)>0 and Duel.GetLocationCountFromEx(tp,tp,c,sc)>0 and c:IsCanBeFusionMaterial(sc,SUMMON_TYPE_SPECIAL)
end
function c101111035.hspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.CheckReleaseGroup(tp,c101111035.sprfilter,1,nil,tp,c)
end
function c101111035.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectReleaseGroup(tp,c101111035.sprfilter,1,1,nil,tp,c)
	c:SetMaterial(g)
	Duel.Release(g,REASON_COST)
end
function c101111035.descon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE) and Duel.IsExistingMatchingCard(Card.IsFaceup,0,LOCATION_FZONE,LOCATION_FZONE,1,nil)
end
function c101111035.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_MZONE)
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
end
function c101111035.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_MZONE)
	if #g>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end 