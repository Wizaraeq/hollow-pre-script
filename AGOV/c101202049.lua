--ＴＧ－ブレイクリミッター
function c101202049.initial_effect(c)
	--Search 2 "T.G." monsters with different names
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101202049,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,101202049)
	e1:SetCost(c101202049.cost)
	e1:SetTarget(c101202049.target)
	e1:SetOperation(c101202049.activate)
	c:RegisterEffect(e1)
	--Shuffle 1 "T.G." monster in your GY into the Deck, or add it to your hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101202049,1))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,101202049)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c101202049.tdtg)
	e2:SetOperation(c101202049.tdop)
	c:RegisterEffect(e2)
end
function c101202049.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c101202049.thfilter(c)
	return c:IsSetCard(0x27) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c101202049.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g=Duel.GetMatchingGroup(c101202049.thfilter,tp,LOCATION_DECK,0,nil)
		return g:GetClassCount(Card.GetCode)>=2
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK)
end
function c101202049.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c101202049.thfilter,tp,LOCATION_DECK,0,nil)
	if #g<2 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tg1=g:SelectSubGroup(tp,aux.dncheck,false,2,2)
	Duel.SendtoHand(tg1,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,tg1)
end
function c101202049.tdfilter(c,check)
	return c:IsSetCard(0x27) and c:IsType(TYPE_MONSTER)
		and (c:IsAbleToDeck() or (check and c:IsAbleToHand()))
end
function c101202049.tohandfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x27) and c:IsRace(RACE_MACHINE)
end
function c101202049.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local check=Duel.IsExistingMatchingCard(c101202049.tohandfilter,tp,LOCATION_MZONE,0,1,nil)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c101202049.tdfilter(chkc,check) end
	if chk==0 then return Duel.IsExistingTarget(c101202049.tdfilter,tp,LOCATION_GRAVE,0,1,nil,check) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c101202049.tdfilter,tp,LOCATION_GRAVE,0,1,1,nil,check)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c101202049.tdop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	if Duel.IsExistingMatchingCard(c101202049.tohandfilter,tp,LOCATION_MZONE,0,1,nil) and tc:IsAbleToHand()
		and (not tc:IsAbleToDeck() or Duel.SelectOption(tp,1190,aux.Stringid(101202049,2))==0) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	else
		Duel.SendtoDeck(tc,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
end
