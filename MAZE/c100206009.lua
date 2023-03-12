--Riryoku Guardian
function c100206009.initial_effect(c)
	aux.AddCodeList(c,25955164,62340868,98434877)
	--Halve the opponent's LP and increase the ATK of a "Gate Guardian" monster
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100206009,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,100206009)
	e1:SetCondition(c100206009.atkecon)
	e1:SetTarget(c100206009.atktg)
	e1:SetOperation(c100206009.atkop)
	c:RegisterEffect(e1)
	--Add 1 "Sanga of the Thunder", "Kazejin", or "Suijin" to the hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100206009,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,100206009+100)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c100206009.thtg)
	e2:SetOperation(c100206009.thop)
	c:RegisterEffect(e2)
end
function c100206009.atkecon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLP(tp)<Duel.GetLP(1-tp)
end
function c100206009.filter(c)
	return c:IsFaceup() and c:IsOriginalSetCard(0x1052)
end
function c100206009.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and chkc:IsFaceup() and chkc:IsOriginalSetCard(0x1052) end
	if chk==0 then return Duel.IsExistingTarget(c100206009.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATKDEF)
	Duel.SelectTarget(tp,c100206009.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c100206009.atkop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetLP(1-tp,Duel.GetLP(1-tp)/2)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.BreakEffect()
		local lp=Duel.GetLP(1-tp)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(lp)
		tc:RegisterEffect(e1)
	end
end
function c100206009.thfilter(c)
	return c:IsCode(25955164,62340868,98434877) and c:IsAbleToHand() and (c:IsLocation(LOCATION_DECK) or c:IsFaceup())
end
function c100206009.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100206009.thfilter,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_REMOVED)
end
function c100206009.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c100206009.thfilter,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end