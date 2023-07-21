--白銀の城の執事 アリアス
function c101202017.initial_effect(c)
	--Special Summon 1 "Labrynth" monster, or Set 1 Normal Trap, from your hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101202017,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e1:SetHintTiming(0,TIMING_MAIN_END)
	e1:SetCountLimit(1,101202017)
	e1:SetCondition(c101202017.spsetcon1)
	e1:SetCost(c101202017.spsetcost)
	e1:SetTarget(c101202017.spsettarget)
	e1:SetOperation(c101202017.spsetop)
	c:RegisterEffect(e1)
	--Special Summon this card
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101202017,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,101202017+100)
	e2:SetCondition(c101202017.selfspcon)
	e2:SetTarget(c101202017.selfsptg)
	e2:SetOperation(c101202017.selfspop)
	c:RegisterEffect(e2)
end
function c101202017.spsetcon1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c101202017.spsetcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() end
	Duel.SendtoGrave(c,REASON_COST)
end
function c101202017.spsetfilter(c,e,tp,ft)
	return (ft>0 and c:IsSetCard(0x17e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false))
		or (c:GetType()==TYPE_TRAP and c:IsSSetable())
end
function c101202017.spsettarget(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ft=Duel.GetMZoneCount(tp,c)
	if chk==0 then return Duel.IsExistingMatchingCard(c101202017.spsetfilter,tp,LOCATION_HAND,0,1,c,e,tp,ft) end
end
function c101202017.spsetop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(101202017,2))
	local sc=Duel.SelectMatchingCard(tp,c101202017.spsetfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp,ft):GetFirst()
	if not sc then return end
	if sc:IsType(TYPE_MONSTER) and sc:IsCanBeSpecialSummoned(e,0,tp,false,false) then
		Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
	elseif sc:IsType(TYPE_TRAP) and Duel.SSet(tp,sc)>0 then
		--It can be activated this turn
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		sc:RegisterEffect(e1)
	end
end
function c101202017.selfspcon(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetCurrentChain()
	if ct<2 then return end
	local te,p=Duel.GetChainInfo(ct-1,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
	local tc=te:GetHandler()
	return te and ((tc:IsSetCard(0x17e) and not tc:IsCode(101202017)) or (tc:GetOriginalType()==TYPE_TRAP and te:IsActiveType(TYPE_TRAP))) and p==tp and rp==1-tp
end
function c101202017.selfsptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,LOCATION_GRAVE)
end
function c101202017.selfspop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end