--魔界台本「ドラマチック・ストーリー」
function c101111064.initial_effect(c)
	--Special Summon 1 "Abyss Actor" monster from the deck
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101111064,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,101111064,EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c101111064.sptg)
	e1:SetOperation(c101111064.spop)
	c:RegisterEffect(e1)
	--Return up to 2 cards to the hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101111064,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetCondition(c101111064.thcond)
	e2:SetTarget(c101111064.thtg)
	e2:SetOperation(c101111064.thop)
	c:RegisterEffect(e2)
end
function c101111064.cfilter(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0x10ec) and c:IsType(TYPE_PENDULUM)
		and Duel.IsExistingMatchingCard(c101111064.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,c:GetCode())
end
function c101111064.spfilter(c,e,tp,code)
	return c:IsSetCard(0x10ec) and c:IsType(TYPE_PENDULUM) and not c:IsCode(code)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101111064.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c101111064.cfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c101111064.cfilter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c101111064.cfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c101111064.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)==0 then return end
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or tc:IsFacedown() then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sc=Duel.SelectMatchingCard(tp,c101111064.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,tc:GetCode()):GetFirst()
	if sc and Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)>0 then
		local b1=(Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1))
		local b2=true
		if b1 and b2 then
			op=Duel.SelectOption(tp,aux.Stringid(101111064,2),aux.Stringid(101111064,3))
		elseif b1 then
			op=Duel.SelectOption(tp,aux.Stringid(101111064,2))
		else
			op=Duel.SelectOption(tp,aux.Stringid(101111064,3))+1
		end
		if not op then return end
		Duel.BreakEffect()
		if op==0 then
			Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
		else
			Duel.Destroy(tc,REASON_EFFECT)
		end
	end
end
function c101111064.filter(c)
	return c:IsSetCard(0x10ec) and c:IsFaceup() and c:IsType(TYPE_PENDULUM)
end
function c101111064.thcond(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_EFFECT) and rp==1-tp and c:IsPreviousControler(tp)
		and c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousPosition(POS_FACEDOWN)
end
function c101111064.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
		and Duel.IsExistingMatchingCard(c101111064.filter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,PLAYER_EITHER,LOCATION_ONFIELD)
end
function c101111064.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,2,nil)
	if #g>0 then
		Duel.HintSelection(g,true)
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end