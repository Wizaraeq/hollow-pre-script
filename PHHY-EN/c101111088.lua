--Gold Pride - Captain Carrie
function c101111088.initial_effect(c)
	--Special Summon itself from the hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101111088,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,101111088)
	e1:SetCondition(c101111088.spcon)
	e1:SetTarget(c101111088.sptg)
	e1:SetOperation(c101111088.spop)
	c:RegisterEffect(e1)
	--Search 1 "Gold Pride" Trap card
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101111088,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCountLimit(1,101111088+100)
	e2:SetTarget(c101111088.thtg)
	e2:SetOperation(c101111088.thop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--Increase the ATK of a "Gold Pride" monster Summoned from the Extra Deck
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(101111088,1))
	e4:SetCategory(CATEGORY_REMOVE+CATEGORY_ATKCHANGE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCountLimit(1,101111088+200)
	e4:SetTarget(c101111088.atktg)
	e4:SetOperation(c101111088.atkop)
	c:RegisterEffect(e4)
end
function c101111088.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLP(tp)<Duel.GetLP(1-tp)
end
function c101111088.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,tp,0)
end
function c101111088.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c101111088.thfilter(c)
	return c:IsSetCard(0x290) and c:IsType(TYPE_TRAP) and c:IsAbleToHand()
end
function c101111088.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101111088.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c101111088.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c101111088.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c101111088.rmvfilter(c)
	return c:IsSetCard(0x290) and c:IsAbleToRemove()
end
function c101111088.atkfilter(c,g)
	return c:IsSetCard(0x290) and c:IsSummonLocation(LOCATION_EXTRA) and c:IsFaceup()
		and (not g:IsContains(c) or #g>1)
end
function c101111088.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=Duel.GetMatchingGroup(c101111088.rmvfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c101111088.atkfilter(chkc,g) end
	if chk==0 then return #g>0 and Duel.IsExistingTarget(c101111088.atkfilter,tp,LOCATION_MZONE,0,1,nil,g) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local tc=Duel.SelectTarget(tp,c101111088.atkfilter,tp,LOCATION_MZONE,0,1,1,nil,g)
	Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,tc,1,0,500)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_GRAVE)
end
function c101111088.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local g=Duel.GetMatchingGroup(c101111088.rmvfilter,tp,LOCATION_GRAVE,0,tc)
	if #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local rg=g:Select(tp,1,3,nil)
		local ct=Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
		if ct>0 and tc:IsRelateToEffect(e) and tc:IsFaceup() then
			--Increase ATK by 500 per card banished
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(ct*500)
			tc:RegisterEffect(e1)
		end
	end
end