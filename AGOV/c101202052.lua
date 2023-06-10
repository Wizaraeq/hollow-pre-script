--世壊挽歌
function c101202052.initial_effect(c)
	aux.AddCodeList(c,56099748)
	--Search 1 "Veda" monster
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101202052,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c101202052.thtg)
	e1:SetOperation(c101202052.thop)
	c:RegisterEffect(e1)
	--Add to the hand 1 Tuner monster that was destroyed
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101202052,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetCountLimit(1,101202052)
	e2:SetCondition(c101202052.thcond)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c101202052.thtg2)
	e2:SetOperation(c101202052.thop2)
	c:RegisterEffect(e2)
end
function c101202052.thfilter(c)
	return c:IsSetCard(0x29a) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c101202052.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101202052.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c101202052.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c101202052.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c101202052.actcfilter(c)
	return c:IsFaceup() and c:IsCode(56099748)
end
function c101202052.thcond(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c101202052.actcfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c101202052.thfilter2(c,e,tp)
	return c:IsReason(REASON_BATTLE+REASON_EFFECT) and c:IsPreviousLocation(LOCATION_MZONE)
		and c:IsPreviousControler(tp) and c:IsPreviousPosition(POS_FACEUP) and not c:IsType(TYPE_TOKEN)
		and c:IsType(TYPE_TUNER) and c:IsAbleToHand()
		and c:IsCanBeEffectTarget(e) and not c:IsLocation(LOCATION_EXTRA)
end
function c101202052.thtg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return c101202052.thfilter2(chkc,e,tp) end
	if chk==0 then return eg:IsExists(c101202052.thfilter2,1,nil,e,tp) and not eg:IsContains(e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=eg:FilterSelect(tp,c101202052.thfilter2,1,1,nil,e,tp)
	Duel.SetTargetCard(g:GetFirst())
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,tp,g:GetFirst():GetLocation())
end
function c101202052.thop2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end