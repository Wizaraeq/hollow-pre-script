--模拘撮星人 エピゴネン
function c101107026.initial_effect(c)
	-- Special Summon self and token
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101107026,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,101107026)
	e1:SetCost(c101107026.spcost)
	e1:SetTarget(c101107026.sptg)
	e1:SetOperation(c101107026.spop)
	c:RegisterEffect(e1)
end
function c101107026.costfilter(c,tp)
	return c:IsType(TYPE_EFFECT) and Duel.GetMZoneCount(tp,c)>1
		and Duel.IsPlayerCanSpecialSummonMonster(tp,101107126,0,TYPES_TOKEN,0,0,1,c:GetOriginalRace(),c:GetOriginalAttribute())
end
function c101107026.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c101107026.costfilter,1,nil,tp) end
	local cc=Duel.SelectReleaseGroup(tp,c101107026.costfilter,1,1,nil,tp):GetFirst()
	e:SetLabel(cc:GetOriginalRace(),cc:GetOriginalAttribute())
	Duel.Release(cc,REASON_COST)
end
function c101107026.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP) and Duel.GetLocationCount(tp,LOCATION_MZONE)>1 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
end
function c101107026.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local race,attribute=e:GetLabel()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,1,tp,tp,false,false,POS_FACEUP)>0
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,101107126,0,TYPES_TOKEN,0,0,1,race,attribute) then
		Duel.BreakEffect()
		local token=Duel.CreateToken(tp,101107126)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
		-- Change Type and Attribute
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_RACE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetValue(race)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
		token:RegisterEffect(e1,true)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e2:SetValue(attribute)
		token:RegisterEffect(e2,true)
		Duel.SpecialSummonComplete()
	end
end 
