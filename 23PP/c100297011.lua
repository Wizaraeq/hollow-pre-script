--ネコーン
function c100297011.initial_effect(c)
	--Add 1 Field Spell to the hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100297011,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,100297011)
	e1:SetTarget(c100297011.thtg1)
	e1:SetOperation(c100297011.thop1)
	c:RegisterEffect(e1)
	--Add
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100297011,2))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,100297011+100)
	e2:SetCondition(c100297011.thcon)
	e2:SetTarget(c100297011.thtg2)
	e2:SetOperation(c100297011.thop2)
	c:RegisterEffect(e2)
end
function c100297011.thfilter1(c)
	return c:IsType(TYPE_FIELD) and c:IsAbleToHand()
end
function c100297011.thtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not Duel.IsExistingMatchingCard(nil,tp,LOCATION_FZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(c100297011.thfilter1,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c100297011.thop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c100297011.thfilter1,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c100297011.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_DESTROY) and c:IsReason(REASON_BATTLE+REASON_EFFECT)
end
function c100297011.cfilter(c,tp)
	return c:IsType(TYPE_FIELD) and Duel.IsExistingMatchingCard(c100297011.thfilter2,tp,LOCATION_DECK,0,1,nil,c:GetCode())
end
function c100297011.thfilter2(c,code)
	return c:IsType(TYPE_FIELD) and c:IsCode(code) and c:IsAbleToHand()
end
function c100297011.thtg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c100297011.cfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c100297011.cfilter,tp,LOCATION_GRAVE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c100297011.cfilter,tp,LOCATION_GRAVE,0,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,tp,0)
end
function c100297011.thop2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c100297011.thfilter2,tp,LOCATION_DECK,0,1,1,nil,tc:GetCode())
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
