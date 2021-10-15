--ＤＤグリフォン
function c101107013.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	-- Gain ATK
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101107013,0))
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,101107013)
	e1:SetTarget(c101107013.atktg)
	e1:SetOperation(c101107013.atkop)
	c:RegisterEffect(e1)
	-- Special Summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101107013,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,101107013+100)
	e2:SetCondition(c101107013.spcon)
	e2:SetTarget(c101107013.sptg)
	e2:SetOperation(c101107013.spop)
	c:RegisterEffect(e2)
	-- Draw
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(101107013,2))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,101107013+200)
	e3:SetCondition(c101107013.drcon)
	e3:SetCost(c101107013.drcost)
	e3:SetTarget(c101107013.drtg)
	e3:SetOperation(c101107013.drop)
	c:RegisterEffect(e3)
	-- Search
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(101107013,3))
	e4:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetCountLimit(1,101107013+300)
	e4:SetCondition(c101107013.thcon)
	e4:SetTarget(c101107013.thtg)
	e4:SetOperation(c101107013.thop)
	c:RegisterEffect(e4)
end
function c101107013.atkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xae) and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c101107013.filter(c)
	return c:IsFaceup() and c:IsRace(RACE_FIEND)
end
function c101107013.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c101107013.filter(chkc) end
	if chk==0 then return Duel.IsExistingMatchingCard(c101107013.atkfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil)
		and Duel.IsExistingTarget(c101107013.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c101107013.filter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end
function c101107013.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsFaceup() and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		local g=Duel.GetMatchingGroup(c101107013.atkfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,nil)
		if #g<1 then return end
		-- Update ATK
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(g:GetClassCount(Card.GetCode)*500)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		Duel.BreakEffect()
		Duel.Destroy(c,REASON_EFFECT)
	end
end
function c101107013.spcfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xaf)
end
function c101107013.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c101107013.spcfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c101107013.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c101107013.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end
function c101107013.drcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_PENDULUM)
end
function c101107013.drcostfilter(c)
	return (c:IsSetCard(0xaf) or c:IsSetCard(0xae)) and c:IsDiscardable()
end
function c101107013.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101107013.drcostfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c101107013.drcostfilter,1,1,REASON_DISCARD+REASON_COST)
end
function c101107013.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c101107013.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c101107013.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonLocation(LOCATION_GRAVE)
end
function c101107013.thfilter(c)
	return c:IsSetCard(0xaf) and not c:IsCode(101107013) and c:IsAbleToHand()
end
function c101107013.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101107013.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c101107013.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c101107013.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end