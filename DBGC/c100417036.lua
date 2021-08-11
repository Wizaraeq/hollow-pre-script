--リザレクション・ブレス
function c100417036.initial_effect(c)
	aux.AddCodeList(c,100417125)
	--SS + Equip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100417036,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,100417036+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c100417036.condition)
	e1:SetTarget(c100417036.target)
	e1:SetOperation(c100417036.operation)
	c:RegisterEffect(e1)
end
function c100417036.eqfilter(c,tp)
	return c:IsType(TYPE_EQUIP) and aux.IsCodeListed(c,100417125) and Duel.IsExistingMatchingCard(c100417036.eqfilter2,tp,LOCATION_MZONE,0,1,nil,c)
end
function c100417036.eqfilter2(c,tc)
	return c:IsFaceup() and tc:CheckEquipTarget(c)
end
function c100417036.cfilter(c)
	return c:IsFaceup() and c:IsCode(100417125)
end
function c100417036.condition(e,tp,eg,ep,ev,re,r,rp) 
	return Duel.IsExistingMatchingCard(c100417036.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c100417036.filter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c100417036.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c100417036.filter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c100417036.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c100417036.filter),tp,LOCATION_HAND+LOCATION_GRAVE,0,nil,e,tp)
	if g:GetCount()>0 and ft>0 then
		if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
		local ct=math.min(ft,2)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:SelectSubGroup(tp,aux.dncheck,false,1,ct)
		if #sg>0 and Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)>0 then
		local tc=sg:GetFirst()
		while tc do
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
				e1:SetValue(LOCATION_REMOVED)
				tc:RegisterEffect(e1,true)
			tc=sg:GetNext()
		end
		if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(c100417036.eqfilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,tp) and Duel.SelectYesNo(tp,aux.Stringid(100417036,1)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
			local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c100417036.eqfilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,tp):GetFirst()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
			local tc2=Duel.SelectMatchingCard(tp,c100417036.eqfilter2,tp,LOCATION_MZONE,0,1,1,nil,tc):GetFirst()
			Duel.Equip(tp,tc,tc2)
			end
		end
	end
end