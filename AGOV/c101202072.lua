--新世廻
function c101202072.initial_effect(c)
	aux.AddCodeList(c,56099748)
	--Shuffle 1 Effect monster into the Deck
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101202072,0))
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetCountLimit(1,101202072)
	e1:SetCondition(c101202072.tdcon)
	e1:SetTarget(c101202072.tdtg)
	e1:SetOperation(c101202072.tdop)
	c:RegisterEffect(e1)
	--Add it to the hand if a "Veda" monster is Special Summoned
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101202072,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,101202072+100)
	e2:SetCondition(c101202072.thcon)
	e2:SetTarget(c101202072.thtg)
	e2:SetOperation(c101202072.thop)
	c:RegisterEffect(e2)
end
function c101202072.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(aux.AND(Card.IsFaceup,Card.IsCode),tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,56099748)
end
function c101202072.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_EFFECT) and c:IsAbleToDeck()
end
function c101202072.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c101202072.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101202072.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c101202072.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c101202072.tdop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and Duel.SendtoDeck(tc,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)>0 then
		local rac=tc:GetRace()
		local val=math.max(tc:GetLevel(),tc:GetRank(),tc:GetLink())
		--The owner can search a monster with different type and lower Level
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(aux.Stringid(101202072,1))
		e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetCondition(c101202072.srchcon)
		e1:SetOperation(c101202072.srchop)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetLabel(rac,val)
		Duel.RegisterEffect(e1,tc:GetOwner())
	end
end
function c101202072.srcfilter(c,rac,lv)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and not c:IsRace(rac) and c:GetLevel()<lv
end
function c101202072.srchcon(e,tp,eg,ep,ev,re,r,rp)
	local rac,lv=e:GetLabel()
	return Duel.IsExistingMatchingCard(c101202072.srcfilter,tp,LOCATION_DECK,0,1,nil,rac,lv)
end
function c101202072.srchop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.SelectYesNo(tp,aux.Stringid(101202072,2)) then return end
	Duel.Hint(HINT_CARD,1-tp,101202072)
	local rac,lv=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c101202072.srcfilter,tp,LOCATION_DECK,0,1,1,nil,rac,lv)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c101202072.thcfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x29a)
end
function c101202072.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c101202072.thcfilter,1,nil)
end
function c101202072.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,tp,0)
end
function c101202072.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,c)
	end
end