--Ghoti Chain
function c101109091.initial_effect(c)
	-- Special Summon 1 "Ghoti" monster
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101109091,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,101109091+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c101109091.spcost)
	e1:SetTarget(c101109091.sptg)
	e1:SetOperation(c101109091.spop)
	c:RegisterEffect(e1)
end
function c101109091.spcostfilter(c,e,tp)
	return c:IsFaceup() and c:IsRace(RACE_FISH) and c:IsAbleToRemoveAsCost() and Duel.GetMZoneCount(tp,c)>0
		and Duel.IsExistingMatchingCard(c101109091.spfilter,tp,LOCATION_REMOVED+LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp,c:GetOriginalCode())
end
function c101109091.spfilter(c,e,tp,code)
	return c:IsSetCard(0x28b) and (c:IsFaceup() or not c:IsLocation(LOCATION_REMOVED))
		and not c:IsOriginalCodeRule(code) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101109091.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101109091.spcostfilter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c101109091.spcostfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	e:SetLabel(g:GetFirst():GetOriginalCode())
end
function c101109091.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_REMOVED+LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
end
function c101109091.spop(e,tp,eg,ep,ev,re,r,rp)
	local code=e:GetLabel()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c101109091.spfilter),tp,LOCATION_REMOVED+LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp,code):GetFirst()
	if tc and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)>0 then
		-- Banish it if it leaves the field
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetValue(LOCATION_REMOVED)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		tc:RegisterEffect(e1,true)
	end
end