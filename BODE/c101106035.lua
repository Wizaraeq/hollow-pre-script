--迷犬メリー
function c101106035.initial_effect(c)
	-- Place to bottom or search and place to top
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101106035,0))
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCountLimit(1,101106035)
	e1:SetTarget(c101106035.tdtg)
	e1:SetOperation(c101106035.tdop)
	c:RegisterEffect(e1)
end
function c101106035.thfilter(c)
	return c:IsCode(11548522) and c:IsAbleToHand()
end
function c101106035.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeck() end
	local op=-1
	if Duel.IsExistingMatchingCard(c101106035.thfilter,tp,LOCATION_DECK,0,1,nil) then
		op=Duel.SelectOption(tp,aux.Stringid(101106035,0),aux.Stringid(101106035,1))
	else
		op=Duel.SelectOption(tp,aux.Stringid(101106035,0))
	end
	e:SetLabel(op)
	if op==1 then
		e:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_TODECK)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,c,1,tp,LOCATION_GRAVE)
end
function c101106035.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local op=e:GetLabel()
	if op==0 and c:IsRelateToEffect(e) then
		Duel.SendtoDeck(c,nil,1,REASON_EFFECT)
	elseif op==1 then
		Duel.DisableShuffleCheck(true)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c101106035.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if #g>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)>0 then
			Duel.ConfirmCards(1-tp,g)
			Duel.ShuffleDeck(tp)
			if c:IsRelateToEffect(e) then
				Duel.SendtoDeck(c,nil,0,REASON_EFFECT)
			end
		end
	end
end