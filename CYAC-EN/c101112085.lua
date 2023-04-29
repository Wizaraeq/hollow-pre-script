--How Did Dai Get Here?
function c101112085.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101112085,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetCountLimit(1,101112085+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c101112085.condition)
	e1:SetTarget(c101112085.target)
	e1:SetOperation(c101112085.operation)
	c:RegisterEffect(e1)
end
function c101112085.cfilter(c,tp,rp)
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousControler(tp)
		and ((c:IsReason(REASON_EFFECT) and rp==1-tp)
		or (c:IsReason(REASON_BATTLE) and Duel.GetAttacker():IsControler(1-tp)))
end
function c101112085.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c101112085.cfilter,1,nil,tp,rp)
end
function c101112085.ffilter2(c,code)
	return c:IsCode(code) and c:IsFaceup()
end
function c101112085.ffliter1(c,tp)
	return c:IsType(TYPE_FIELD) and not c:IsForbidden() and not Duel.IsExistingMatchingCard(c101112085.ffilter2,tp,LOCATION_FZONE,LOCATION_FZONE,1,nil,c:GetCode())
end
function c101112085.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101112085.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local sg=Duel.GetMatchingGroup(c101112085.spfilter,tp,LOCATION_DECK,0,nil,e,tp)
		return #sg>=5 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsExistingMatchingCard(c101112085.ffliter1,tp,LOCATION_DECK,0,1,nil,tp)
			and sg:CheckSubGroup(aux.dncheck,5,5)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c101112085.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=Duel.SelectMatchingCard(tp,c101112085.ffliter1,tp,LOCATION_DECK,0,1,1,nil,tp):GetFirst()
	if not tc then return end
	local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
	if fc then
		Duel.SendtoGrave(fc,REASON_RULE)
		Duel.BreakEffect()
	end
	if Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		local sg=Duel.GetMatchingGroup(c101112085.spfilter,tp,LOCATION_DECK,0,nil,e,tp)
		if #sg<5 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local g=sg:SelectSubGroup(tp,aux.dncheck,false,5,5)
		Duel.BreakEffect()
		Duel.ConfirmCards(1-tp,g)
		local sc=g:RandomSelect(1-tp,1)
		Duel.ConfirmCards(1-tp,sc)
		Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
		Duel.ShuffleDeck(tp)
	end
end