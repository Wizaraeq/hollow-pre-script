--Kuebiko
local s,id,o=GetID()
function s.initial_effect(c)
	--Special Summon this card
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,id,0,TYPES_EFFECT_TRAP_MONSTER,0,0,2,RACE_FAIRY,ATTRIBUTE_EARTH,POS_FACEUP,tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,tp,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and s.sptg(e,tp,eg,ep,ev,re,r,rp,0) then
		c:AddMonsterAttribute(TYPE_EFFECT+TYPE_TRAP)
		Duel.SpecialSummonStep(c,SUMMON_VALUE_SELF,tp,tp,true,false,POS_FACEUP)
		--Set this card in the Spell/Trap Zone and negate activated monster effect
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(id,1))
		e1:SetCategory(CATEGORY_DISABLE+CATEGORY_TOHAND)
		e1:SetType(EFFECT_TYPE_QUICK_O)
		e1:SetCode(EVENT_CHAINING)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCountLimit(1)
		e1:SetCondition(s.setcon)
		e1:SetTarget(s.settg)
		e1:SetOperation(s.setop)
		e1:SetReset(RESET_EVENT|RESETS_STANDARD)
		c:RegisterEffect(e1,true)
	end
	Duel.SpecialSummonComplete()
end
function s.setconfilter(c,tp)
	return c:IsOnField() and c:IsControler(tp)
end
function s.setcon(e,tp,eg,ep,ev,re,r,rp)
	if not (rp==1-tp and re:IsActiveType(TYPE_MONSTER) and re:IsHasProperty(EFFECT_FLAG_CARD_TARGET)) then return false end
	local tg,trig_loc=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS,CHAININFO_TRIGGERING_LOCATION)
	return trig_loc==LOCATION_MZONE and tg and tg:IsExists(s.setconfilter,1,nil,tp) and Duel.IsChainDisablable(ev)
end
function s.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsSSetable(true) end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function s.filter(c,atk)
	return c:GetAttack()>atk and c:IsFaceup()
end
function s.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	if c:IsRelateToEffect(e) and c:IsLocation(LOCATION_MZONE) and c:IsSSetable(true) and Duel.SSet(tp,c,tp,false)>0
		and Duel.NegateEffect(ev) and rc:IsRelateToEffect(re) and rc:IsControler(1-tp)
		and not Duel.IsExistingMatchingCard(s.filter,tp,0,LOCATION_MZONE,1,nil,rc:GetAttack()) then
		Duel.BreakEffect()
		Duel.SendtoHand(rc,nil,REASON_EFFECT)
	end
end