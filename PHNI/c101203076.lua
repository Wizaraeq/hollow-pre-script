--粛声なる威光
function c101203076.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_STANDBY_PHASE)
	c:RegisterEffect(e1)
	--Activate 1 of these effects
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101203076,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetHintTiming(0,TIMING_MAIN_END+TIMINGS_CHECK_MONSTER)
	e2:SetCountLimit(1,101203076)
	e2:SetCondition(c101203076.effcon)
	e2:SetTarget(c101203076.efftg)
	e2:SetOperation(c101203076.effop)
	c:RegisterEffect(e2)
end
function c101203076.effcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c101203076.tdfilter(c)
	return c:IsAbleToDeck() and (c:GetType()==TYPE_SPELL+TYPE_RITUAL or
		(c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsRace(RACE_WARRIOR+RACE_DRAGON) and bit.band(c:GetType(),0x81)==0x81))
end
function c101203076.filter(c,e,tp,ft)
	return c:IsSetCard(0x2a6) and c:IsType(TYPE_MONSTER) and (c:IsAbleToHand() or (ft>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)))
end
function c101203076.cfilter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsRace(RACE_WARRIOR+RACE_DRAGON) and bit.band(c:GetType(),0x81)==0x81
end
function c101203076.efftg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) end
	local b1=Duel.IsExistingMatchingCard(c101203076.tdfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil)
		and Duel.IsExistingMatchingCard(c101203076.filter,tp,LOCATION_DECK,0,1,nil,e,tp,Duel.GetLocationCount(tp,LOCATION_MZONE))
	local c=e:GetHandler()
	local ct=Duel.GetMatchingGroupCount(c101203076.cfilter,tp,LOCATION_MZONE,0,nil)
	local b2=ct>0 and Duel.IsExistingTarget(nil,tp,0,LOCATION_ONFIELD,1,nil) and c:IsStatus(STATUS_EFFECT_ENABLED)
	if chk==0 then return b1 or b2 end
		op=aux.SelectFromOptions(tp,
			{b1,aux.Stringid(101203076,1)},
			{b2,aux.Stringid(101203076,2)})
	e:SetLabel(op)
	if op==1 then
		e:SetCategory(CATEGORY_TODECK+CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
		e:SetProperty(0)
		Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
	elseif op==2 then
		e:SetCategory(CATEGORY_DESTROY)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectTarget(tp,nil,tp,0,LOCATION_ONFIELD,1,ct,nil)
		g:AddCard(c)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,tp,0)
	end
end
function c101203076.effop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local tdg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c101203076.tdfilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil)
		if #tdg==0 then return end
		Duel.HintSelection(tdg)
		if Duel.SendtoDeck(tdg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)>0 then
			local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
			local sc=Duel.SelectMatchingCard(tp,c101203076.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp,ft):GetFirst()
			if sc then
				if sc:IsAbleToHand() and (not sc:IsCanBeSpecialSummoned(e,0,tp,false,false) or ft<=0 or Duel.SelectOption(tp,1190,1152)==0) then
					Duel.SendtoHand(sc,nil,REASON_EFFECT)
					Duel.ConfirmCards(1-tp,sc)
				else
					Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
				end
			end
		end
	elseif e:GetLabel()==2 then
		--Destroy both the targets and this card
		local c=e:GetHandler()
		if not c:IsRelateToEffect(e) then return end
		local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
		local g=tg:Filter(Card.IsRelateToEffect,nil,e)
		if #g==0 then return end
		g:AddCard(c)
		if #g>0 then
			Duel.Destroy(g,REASON_EFFECT)
		end
	end
end