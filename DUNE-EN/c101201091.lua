--Breath of the Tistina
function c101201091.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Additional Normal Summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101201091,0))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x2a2))
	c:RegisterEffect(e2)
	--Flip 1 monster face-down
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(101201091,1))
	e3:SetCategory(CATEGORY_POSITION+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,101201091)
	e3:SetTarget(c101201091.postg)
	e3:SetOperation(c101201091.posop)
	c:RegisterEffect(e3)
end
function c101201091.tisfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x2a2) and c:IsAttribute(ATTRIBUTE_LIGHT)
end
function c101201091.thfilter(c)
	return c:IsSetCard(0x2a2) and c:IsAbleToHand() and not c:IsCode(101201091)
end
function c101201091.postg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local opp_loc=Duel.IsExistingMatchingCard(c101201091.tisfilter,tp,LOCATION_MZONE,0,1,nil) and LOCATION_MZONE or 0
	if chkc then return (opp_loc>0 or chkc:IsControler(tp)) and chkc:IsLocation(LOCATION_MZONE) and c:IsCanTurnSet() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsCanTurnSet,tp,LOCATION_MZONE,opp_loc,1,nil)
		and Duel.IsExistingMatchingCard(c101201091.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g=Duel.SelectTarget(tp,Card.IsCanTurnSet,tp,LOCATION_MZONE,opp_loc,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c101201091.posop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c101201091.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.BreakEffect()
		Duel.SendtoHand(g,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end