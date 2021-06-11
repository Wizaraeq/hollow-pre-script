--トイ・パレード
function c100278037.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,100278037)
	e1:SetTarget(c100278037.target)
	e1:SetOperation(c100278037.activate)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,100278037)
	e2:SetCondition(c100278037.thcon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c100278037.thtg)
	e2:SetOperation(c100278037.thop)
	c:RegisterEffect(e2)
end
function c100278037.filter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_DARK) and c:GetSummonLocation()==LOCATION_EXTRA
end
function c100278037.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c100278037.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c100278037.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c100278037.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c100278037.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local ae=Effect.CreateEffect(c)
		ae:SetType(EFFECT_TYPE_FIELD)
		ae:SetCode(EFFECT_CANNOT_ATTACK)
		ae:SetTargetRange(LOCATION_MZONE,0)
		ae:SetTarget(c100278037.ftarget)
		ae:SetLabel(tc:GetFieldID())
		ae:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(ae,tp)
		--chain attack
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_BATTLE_DESTROYING)
		e1:SetCondition(c100278037.atcon)
		e1:SetOperation(c100278037.atop)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
function c100278037.ftarget(e,c)
	return e:GetLabel()~=c:GetFieldID()
end
function c100278037.atcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return c:IsRelateToBattle() and bc:IsLocation(LOCATION_GRAVE) and bc:IsReason(REASON_BATTLE) and bc:IsType(TYPE_MONSTER) and aux.bdcon(e,tp,eg,ep,ev,re,r,rp) and c:IsChainAttackable(0)
end
function c100278037.atop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChainAttack()
end
function c100278037.cfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_FAIRY)
end
function c100278037.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c100278037.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c100278037.thfilter(c)
	return c:IsLevelBelow(4) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsAbleToHand()
end
function c100278037.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100278037.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c100278037.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c100278037.thfilter),tp,LOCATION_GRAVE,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
