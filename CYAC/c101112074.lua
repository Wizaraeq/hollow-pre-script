--識無辺世壊
function c101112074.initial_effect(c)
	aux.AddCodeList(c,56099748)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101112074,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON+CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER_E)
	e1:SetCondition(c101112074.condition)
	e1:SetTarget(c101112074.target)
	e1:SetOperation(c101112074.activate)
	c:RegisterEffect(e1)
end
function c101112074.cfilter(c)
	return c:IsFaceup() and c:IsCode(101112036)
end
function c101112074.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c101112074.cfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
end
function c101112074.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsOnField() and chkc~=c end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,c)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,tp,0)
end
function c101112074.spfilter(c,e,tp)
	return c:IsCode(56099748) and c:IsFaceup() and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101112074.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not (tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)>0) then return end
	if tc:IsOriginalCodeRule(101112036) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c101112074.spfilter,tp,LOCATION_REMOVED,0,1,nil,e,tp)
		and Duel.SelectYesNo(tp,aux.Stringid(101112074,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c101112074.spfilter,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
		if #g>0 then
			Duel.BreakEffect()
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	elseif not tc:IsOriginalCodeRule(101112036) and Duel.IsExistingMatchingCard(c101112074.cfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(101112074,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATKDEF)
		local sc=Duel.SelectMatchingCard(tp,c101112074.cfilter,tp,LOCATION_MZONE,0,1,1,nil)
		if sc:GetCount()>0 then
		Duel.HintSelection(sc)
		Duel.BreakEffect()
		--Increase ATK
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(1500)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		sc:GetFirst():RegisterEffect(e1)
		end
	end
end