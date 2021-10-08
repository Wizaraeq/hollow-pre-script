--暗岩の海竜神
function c100426022.initial_effect(c)
	-- Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,100426022+EFFECT_COUNT_CODE_OATH)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetCost(c100426022.spcost)
	e1:SetTarget(c100426022.sptg)
	e1:SetOperation(c100426022.spop)
	c:RegisterEffect(e1)
end
function c100426022.spcostfilter(c)
	return c:IsFaceup() and c:IsCode(22702055) and c:IsAbleToGraveAsCost()
end
function c100426022.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100426022.spcostfilter,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c100426022.spcostfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c100426022.spfilter1(c,e,tp)
	return ((c:IsType(TYPE_NORMAL) and c:IsAttribute(ATTRIBUTE_WATER)) or aux.IsCodeListed(c,22702055))
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function c100426022.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100426022.spfilter1,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,LOCATION_HAND+LOCATION_DECK)
end
function c100426022.spfilter2(c,e,tp)
	return c:IsLevelBelow(6) and c:IsType(TYPE_NORMAL) and c:IsAttribute(ATTRIBUTE_WATER)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c100426022.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=Duel.GetMatchingGroup(c100426022.spfilter1,tp,LOCATION_HAND+LOCATION_DECK,0,nil,e,tp)
	if ft<1 or g:GetCount()==0 then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:SelectSubGroup(tp,aux.dncheck,false,1,math.min(ft,2))
	if Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP_DEFENSE)>0 and Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>0 then
		-- Special Summon (any number)
		local ng=Duel.GetMatchingGroup(c100426022.spfilter2,tp,LOCATION_HAND+LOCATION_DECK,0,nil,e,tp)
		local nct=Duel.GetLocationCount(tp,LOCATION_MZONE)
		if #ng>0 and nct>0 and Duel.SelectYesNo(tp,aux.Stringid(100426022,0)) then
		if Duel.IsPlayerAffectedByEffect(tp,59822133) then nct=1 end
		local nsg=ng:Select(tp,1,nct,nil)
		if #nsg>0 then
			Duel.BreakEffect()
			Duel.SpecialSummon(nsg,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,0)
		e1:SetTarget(c100426022.splimit)
		if Duel.GetTurnPlayer()==tp then
			e1:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,2)
		else
			e1:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,1)
		end
		Duel.RegisterEffect(e1,tp)
	end
end
function c100426022.splimit(e,c)
	return not c:IsAttribute(ATTRIBUTE_WATER)
end