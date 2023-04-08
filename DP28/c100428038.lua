--バーニングナックル・クロスカウンター
function c100428038.initial_effect(c)
	--Negate the activation of a monster effect
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100428038,0))
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,100428038,EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c100428038.condition)
	e1:SetTarget(c100428038.target)
	e1:SetOperation(c100428038.activate)
	c:RegisterEffect(e1)
end
function c100428038.condition(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainNegatable(ev)
end
function c100428038.desfilter(c,e)
	return c:IsFaceup() and (c:IsSetCard(0x1084) or c:IsSetCard(0x48)) and c:IsType(TYPE_XYZ) and c:IsDestructable(e)
end
function c100428038.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100428038.desfilter,tp,LOCATION_MZONE,0,1,nil,e) end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c100428038.spfilter(c,e,tp,code)
	return c:IsSetCard(0x1084) and c:IsType(TYPE_XYZ) and not c:IsCode(code)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c100428038.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local dc=Duel.SelectMatchingCard(tp,c100428038.desfilter,tp,LOCATION_MZONE,0,1,1,nil,e):GetFirst()
	if dc and Duel.Destroy(dc,REASON_EFFECT)>0 and Duel.NegateActivation(ev)
		and re:GetHandler():IsRelateToEffect(re) and Duel.Destroy(eg,REASON_EFFECT)>0 then
		local code=dc:GetCode()
		if Duel.IsExistingMatchingCard(c100428038.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,code) and Duel.SelectYesNo(tp,aux.Stringid(100428038,1)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sc=Duel.SelectMatchingCard(tp,c100428038.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,code):GetFirst()
			if not sc then return end
			Duel.BreakEffect()
			local c=e:GetHandler()
			if Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)>0 and c:IsRelateToEffect(e) then
				c:CancelToGrave()
				Duel.Overlay(sc,c)
			end
		end
	end
end