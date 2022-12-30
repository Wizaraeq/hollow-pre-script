--寝姫の甘い夢
function c101112060.initial_effect(c)
	--Search 1 "Nemurelia" monster and prevent the opponent's effects when a "Nemurelia" is Summoned
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101112060,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,101112060,EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c101112060.thtg)
	e1:SetOperation(c101112060.thop)
	c:RegisterEffect(e1)
	--Place 1 "Dreaming Nemurelia" in the Extra Deck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101112060,1))
	e2:SetCategory(CATEGORY_TOEXTRA)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(c101112060.tedcost)
	e2:SetTarget(c101112060.tedtg)
	e2:SetOperation(c101112060.tedop)
	c:RegisterEffect(e2)
end
function c101112060.thcfilter(c)
	return c:IsFaceup() and c:IsCode(101112015)
end
function c101112060.thfilter(c)
	return c:IsSetCard(0x292) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c101112060.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101112060.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c101112060.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c101112060.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g==0 or Duel.SendtoHand(g,nil,REASON_EFFECT)==0 then return end
	Duel.ConfirmCards(1-tp,g)
	if not Duel.IsExistingMatchingCard(c101112060.thcfilter,tp,LOCATION_EXTRA,0,1,nil) then return end
	Duel.BreakEffect()
	local c=e:GetHandler()

end
function c101112060.sumop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCondition(c101112060.sumcon)
	e1:SetOperation(c101112060.sumsuc)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	Duel.RegisterEffect(e2,tp)
end
function c101112060.sumcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c101112060.filter,1,nil)
end
function c101112060.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetChainLimitTillChainEnd(c101112060.efun)
end
function c101112060.efun(e,ep,tp)
	return ep==tp
end
function c101112060.tedcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToDeck() end
	Duel.SendtoDeck(c,nil,SEQ_DECKBOTTOM,REASON_EFFECT)
end
function c101112060.tedfilter(c)
	return c:IsCode(101112015) and c:IsFaceup() and c:IsAbleToExtra() and not c:IsForbidden()
end
function c101112060.tedtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(tp) and c101112060.tedfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101112060.tedfilter,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c101112060.tedfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,g,1,tp,0)
end
function c101112060.tedop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoExtraP(tc,tp,REASON_EFFECT)
	end
end