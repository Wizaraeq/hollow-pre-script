--メメント・ボーン・パーティー
function c100421009.initial_effect(c)
	-- Add or Special Summon 1 "Memento" monster from your Deck
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100421009,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetCountLimit(1,100421009)
	e1:SetTarget(c100421009.target)
	e1:SetOperation(c100421009.activate)
	c:RegisterEffect(e1)
	-- Targeted "Memento" inflicts piercing damage
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100421009,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,100421009+100)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c100421009.pdtg)
	e2:SetOperation(c100421009.pdop)
	c:RegisterEffect(e2)
end
function c100421009.spfilter(c,e,tp,dc)
	return c:IsSetCard(0x2a1) and c:IsType(TYPE_MONSTER) and not c:IsCode(dc:GetCode())
		and (c:IsAbleToHand() or (Duel.GetMZoneCount(tp,dc)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)))
end
function c100421009.desfilter(c,e,tp)
	return c:IsSetCard(0x2a1) and c:IsType(TYPE_MONSTER) and c:IsDestructable()
		and (c:IsLocation(LOCATION_HAND) or c:IsFaceup()) and Duel.IsExistingMatchingCard(c100421009.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,c)
end
function c100421009.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100421009.desfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_HAND+LOCATION_MZONE)
end
function c100421009.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local tc=Duel.SelectMatchingCard(tp,c100421009.desfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil,e,tp):GetFirst()
	if tc and Duel.Destroy(tc,REASON_EFFECT)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
		local g=Duel.SelectMatchingCard(tp,c100421009.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,tc)
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		local tc=g:GetFirst()
		if tc then
			if tc:IsAbleToHand() and (not tc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE) or ft<=0 or Duel.SelectOption(tp,1190,1152)==0) then
				Duel.SendtoHand(tc,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,tc)
			else
				Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
			end
		end
	end
end
function c100421009.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x2a1) and not c:IsHasEffect(EFFECT_PIERCE)
end
function c100421009.pdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c100421009.cfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c100421009.cfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c100421009.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c100421009.pdop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		-- Inflicts piercing damage
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_PIERCE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end