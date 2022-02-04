--Libromancer Magigirl
function c101107086.initial_effect(c)
	-- Special Summon self
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101107086,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,101107086)
	e1:SetCost(c101107086.spcost)
	e1:SetTarget(c101107086.sptg)
	e1:SetOperation(c101107086.spop)
	c:RegisterEffect(e1)
	--ritual summon
	local e2=aux.AddRitualProcGreater2(c,c101107086.filter,nil,nil,c101107086.matfilter,true)
	e2:SetDescription(aux.Stringid(101107086,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e2:SetCountLimit(1,101107086+100)
	e2:SetCondition(c101107086.rscon)
	c:RegisterEffect(e2)
end
function c101107086.spcostfilter(c)
	return bit.band(c:GetType(),0x81)==0x81 and not c:IsPublic()
end
function c101107086.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c101107086.spcostfilter,tp,LOCATION_HAND,0,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c101107086.spcostfilter,tp,LOCATION_HAND,0,1,1,c)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
end
function c101107086.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c101107086.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c101107086.filter(c,e,tp,chk)
	return c:IsSetCard(0x27d) and (not chk or c~=e:GetHandler())
end
function c101107086.matfilter(c,e,tp,chk)
	return not chk or c~=e:GetHandler()
end
function c101107086.rscon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end