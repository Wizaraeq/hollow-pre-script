--無尽機関アルギロ・システム
function c101108054.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,101108054)
	e1:SetTarget(c101108054.target)
	e1:SetOperation(c101108054.activate)
	c:RegisterEffect(e1)
	--to hand/deck
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,101108054)
	e2:SetTarget(c101108054.thtg)
	e2:SetOperation(c101108054.thop)
	c:RegisterEffect(e2)
end
function c101108054.tgfilter(c)
	return c:IsSetCard(0x27a) and c:IsAbleToGrave()
end
function c101108054.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101108054.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c101108054.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c101108054.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function c101108054.thfilter(c,hc)
	if not c:IsSetCard(0x27a) then return false end
	return (c:IsAbleToHand() and hc:IsAbleToDeck()) or (c:IsAbleToDeck() and hc:IsAbleToHand())
end
function c101108054.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c101108054.thfilter(chkc,c) end
	if chk==0 then return Duel.IsExistingTarget(c101108054.thfilter,tp,LOCATION_GRAVE,0,1,nil,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c101108054.thfilter,tp,LOCATION_GRAVE,0,1,1,nil,c)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_GRAVE)
end
function c101108054.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not (c:IsRelateToEffect(e) and tc:IsRelateToEffect(e)) then return end
	local g=Group.FromCards(c,tc)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local hg=g:FilterSelect(tp,Card.IsAbleToHand,1,1,nil)
	if #hg>0 and Duel.SendtoHand(hg,nil,REASON_EFFECT)>0 and hg:GetFirst():IsLocation(LOCATION_HAND) then
		Duel.ConfirmCards(1-tp,hg)
		Duel.SendtoDeck(g-hg,nil,LOCATION_DECKBOT,REASON_EFFECT)
	end
end
