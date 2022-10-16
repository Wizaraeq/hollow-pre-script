--流星連打－シロクロイド
function c101111029.initial_effect(c)
	--Special Summon itself from the hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101111029,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetHintTiming(0,TIMING_ATTACK+TIMING_BATTLE_END)
	e1:SetCountLimit(1,101111029)
	e1:SetCondition(c101111029.spcon)
	e1:SetTarget(c101111029.sptg)
	e1:SetOperation(c101111029.spop)
	c:RegisterEffect(e1)
	--Increase its ATK by 1000 per attack declared
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c101111029.atkcon)
	e2:SetValue(c101111029.atkval)
	c:RegisterEffect(e2)
	if not c101111029.global_check then
		c101111029.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_ATTACK_ANNOUNCE)
		ge1:SetOperation(c101111029.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c101111029.checkop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(ep,101111029,RESET_PHASE+PHASE_END,0,1)
end
function c101111029.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,101111029)+Duel.GetFlagEffect(1-tp,101111029)>=5
		and (Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE)
end
function c101111029.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,tp,0)
end
function c101111029.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c101111029.atkcon(e)
	local ph=Duel.GetCurrentPhase()
	return (ph==PHASE_DAMAGE or ph==PHASE_DAMAGE_CAL) and e:GetHandler():IsRelateToBattle()
end
function c101111029.atkval(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(Duel.GetTurnPlayer(),101111029)*1000
end