--覇王龍の奇跡
function c101202068.initial_effect(c)
	aux.AddCodeList(c,13331639)
	--Activate 1 of these effects
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101202068,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetCondition(c101202068.condition)
	e1:SetTarget(c101202068.target)
	e1:SetOperation(c101202068.activate)
	c:RegisterEffect(e1)
end
function c101202068.chfilter(c)
	return c:IsFaceup() and c:IsCode(13331639)
end
function c101202068.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c101202068.chfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c101202068.desfilter(c,e,tp)
	return c:IsFaceup() and c:IsCode(13331639)
		and Duel.IsExistingMatchingCard(c101202068.spfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil,e,tp,c)
end
function c101202068.spfilter(c,e,tp,ec)
	if not ((c:IsSetCard(0x99) and c:IsType(TYPE_PENDULUM)) or (c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsCode(13331639))) then return false end
	if not c:IsCanBeSpecialSummoned(e,0,tp,true,false) then return false end
	if c:IsLocation(LOCATION_DECK) then
		return Duel.GetMZoneCount(tp,ec)>0
	else
		return Duel.GetLocationCountFromEx(tp,tp,ec,c)>0
	end
end
function c101202068.pcfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function c101202068.setfilter(c)
	return c:IsType(TYPE_QUICKPLAY) and c:IsSSetable()
end
function c101202068.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(c101202068.desfilter,tp,LOCATION_ONFIELD,0,1,nil,e,tp) and Duel.GetFlagEffect(tp,101202068)==0
	local b2=(Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) and Duel.GetFlagEffect(tp,101202068+100)==0
		and Duel.IsExistingMatchingCard(c101202068.pcfilter,tp,LOCATION_EXTRA,0,1,nil)
	local b3=Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c101202068.setfilter,tp,LOCATION_DECK,0,1,nil) and Duel.GetFlagEffect(tp,101202068+200)==0
	if chk==0 then return b1 or b2 or b3 end
	local op=aux.SelectFromOptions(tp,
		{b1,aux.Stringid(101202068,1)},
		{b2,aux.Stringid(101202068,2)},
		{b3,aux.Stringid(101202068,3)})
	e:SetLabel(op)
	if op==1 then
		e:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
		Duel.RegisterFlagEffect(tp,101202068,RESET_PHASE+PHASE_END,0,1)
		local g=Duel.GetMatchingGroup(c101202068.chfilter,tp,LOCATION_ONFIELD,0,nil)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,tp,LOCATION_ONFIELD)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_EXTRA)
	elseif sel==2 then
		e:SetCategory(0)
		Duel.RegisterFlagEffect(tp,101202068+100,RESET_PHASE+PHASE_END,0,1)
	elseif sel==3 then
		e:SetCategory(0)
		Duel.RegisterFlagEffect(tp,101202068+200,RESET_PHASE+PHASE_END,0,1)
	end
end
function c101202068.activate(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	if op==1 then
		--Destroy 1 "Supreme King Z-ARC" you control
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectMatchingCard(tp,c101202068.desfilter,tp,LOCATION_ONFIELD,0,1,1,nil,e,tp)
		if #g>0 and Duel.Destroy(g,REASON_EFFECT)>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=Duel.SelectMatchingCard(tp,c101202068.spfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil,e,tp)
			if #sg>0 then
				Duel.SpecialSummon(sg,0,tp,tp,true,false,POS_FACEUP)
			end
		end
	elseif op==2 then
		--Place 1 face-up Pendulum Monster from your Extra Deck in your Pendulum Zone
		if not (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local sc=Duel.SelectMatchingCard(tp,c101202068.pcfilter,tp,LOCATION_EXTRA,0,1,1,nil):GetFirst()
		if sc then
			Duel.MoveToField(sc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
		end
	elseif op==3 then
		--Set 1 Quick-Play Spell directly from your Deck
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local g=Duel.SelectMatchingCard(tp,c101202068.setfilter,tp,LOCATION_DECK,0,1,1,nil)
		if #g>0 then
			Duel.SSet(tp,g)
		end
	end
end