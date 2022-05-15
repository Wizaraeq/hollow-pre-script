--ＢＦ－無頼のヴァータ
function c101110001.initial_effect(c)
	aux.AddCodeList(c,9012916)
	-- Special Summon this card
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,101110001+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c101110001.spcon)
	c:RegisterEffect(e1)
	-- Send this card and "Blackwing" non-tuners to the GY
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101110001,0))
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,101110001+100)
	e2:SetTarget(c101110001.tgtg)
	e2:SetOperation(c101110001.tgop)
	c:RegisterEffect(e2)
end
function c101110001.spconfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x33) and not c:IsCode(101110001)
end
function c101110001.spcon(e,c)
	if c==nil then return true end
	local tp=e:GetHandlerPlayer()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c101110001.spconfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c101110001.spfilter(c,e,tp,ec)
	return c:IsCode(9012916) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.GetLocationCountFromEx(tp,tp,ec,c)>0
end
function c101110001.tgfilter(c)
	return c:IsSetCard(0x33) and c:IsLevelAbove(1) and c:IsAbleToGrave() and not c:IsType(TYPE_TUNER) 
end
function c101110001.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local c=e:GetHandler()
		local rlv=8-c:GetLevel()
		if not c:IsAbleToGrave() or c:IsLevelAbove(8) or rlv<1 then return false end
		local g=Duel.GetMatchingGroup(c101110001.tgfilter,tp,LOCATION_DECK,0,nil)
		return g:CheckWithSumEqual(Card.GetLevel,rlv,1,63) and Duel.IsExistingMatchingCard(c101110001.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,c)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c101110001.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsAbleToGrave() and c:IsLevelBelow(7) then
		local g=Duel.GetMatchingGroup(c101110001.tgfilter,tp,LOCATION_DECK,0,nil)
		local rlv=8-c:GetLevel()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local mg=g:SelectWithSumEqual(tp,Card.GetLevel,rlv,1,63)
		if #mg>0 and Duel.SendtoGrave(c+mg,REASON_EFFECT)>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=Duel.SelectMatchingCard(tp,c101110001.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,c)
			if #sg>0 then
				Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c101110001.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c101110001.splimit(e,c)
	return not c:IsAttribute(ATTRIBUTE_DARK) and c:IsLocation(LOCATION_EXTRA)
end
