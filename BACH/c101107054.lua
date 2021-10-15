--凶導の葬列
function c101107054.initial_effect(c)
	aux.AddCodeList(c,40352445,101107035)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,101107054+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c101107054.target)
	e1:SetOperation(c101107054.operation)
	c:RegisterEffect(e1)
end
function c101107054.exfilter0(c)
	return c:IsType(TYPE_FUSION+TYPE_SYNCHRO) and c:IsLevelAbove(1) and c:IsAbleToRemove()
end
function c101107054.filter(c,e,tp)
	return c:IsSetCard(0x145)
end
function c101107054.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetRitualMaterial(tp)
		local sg=Duel.GetMatchingGroup(c101107054.exfilter0,tp,LOCATION_GRAVE,0,nil)
		return Duel.IsExistingMatchingCard(aux.RitualUltimateFilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,c101107054.filter,e,tp,mg,sg,Card.GetLevel,"Greater")
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c101107054.cfilter(c,code)
	return c:IsFaceup() and c:IsCode(code)
end
function c101107054.operation(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetRitualMaterial(tp)
	local sg=Duel.GetMatchingGroup(c101107054.exfilter0,tp,LOCATION_GRAVE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(aux.RitualUltimateFilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,c101107054.filter,e,tp,mg,sg,Card.GetLevel,"Greater")
	local tc=tg:GetFirst()
	if tc then
		mg=mg:Filter(Card.IsCanBeRitualMaterial,tc,tc)
		if sg then
			mg:Merge(sg)
		end
		if tc.mat_filter then
			mg=mg:Filter(tc.mat_filter,tc,tp)
		else
			mg:RemoveCard(tc)
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		aux.GCheckAdditional=aux.RitualCheckAdditional(tc,tc:GetLevel(),"Greater")
		local mat=mg:SelectSubGroup(tp,aux.RitualCheck,false,1,tc:GetLevel(),tp,tc,tc:GetLevel(),"Greater")
		aux.GCheckAdditional=nil
		if not mat or mat:GetCount()==0 then return end
		tc:SetMaterial(mat)
		local mat2=mat:Filter(Card.IsLocation,nil,LOCATION_GRAVE)
		mat:Sub(mat2)
		Duel.ReleaseRitualMaterial(mat)
		Duel.Remove(mat2,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
		if not (Duel.IsExistingMatchingCard(c101107054.cfilter,tp,LOCATION_ONFIELD,0,1,nil,40352445) and Duel.IsExistingMatchingCard(c101107054.cfilter,tp,LOCATION_ONFIELD,0,1,nil,101107035)) then return end
		local g1=Duel.GetFieldGroup(tp,LOCATION_EXTRA,0)
		local g2=Duel.GetFieldGroup(tp,0,LOCATION_EXTRA)
		if (#g1<1 and #g2<1) or not Duel.SelectYesNo(tp,aux.Stringid(101107054,0)) then return end
		local op=0
		if #g1>0 and #g2>0 then
			op=Duel.SelectOption(tp,aux.Stringid(101107054,1),aux.Stringid(101107054,2))
		elseif #g1>0 then
			op=Duel.SelectOption(tp,aux.Stringid(101107054,1))
		else
			op=Duel.SelectOption(tp,aux.Stringid(101107054,2))+1
		end
		local g=(op==0) and g1 or g2
		Duel.ConfirmCards(tp,g)
		local tcg=g:Filter(Card.IsAbleToGrave,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local st=tcg:Select(tp,1,1,nil):GetFirst()
		if st then
			Duel.SendtoGrave(st,REASON_EFFECT)
		end
		if op==1 then Duel.ShuffleExtra(1-tp) end
	end
end