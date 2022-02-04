--Libromancer Intervention
function c101107091.initial_effect(c)
	-- Return 1 "Libromancer" Ritual monster to hand and negate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101107091,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_DISABLE+CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_SPSUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,101107091,EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c101107091.thcon)
	e1:SetTarget(c101107091.thtg)
	e1:SetOperation(c101107091.thop)
	c:RegisterEffect(e1)
end
function c101107091.thcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==1-tp and Duel.IsChainDisablable(ev)
end
function c101107091.thfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x27d) and bit.band(c:GetType(),0x81)==0x81 and c:IsAbleToHand()
end
function c101107091.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c101107091.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101107091.thfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,c101107091.thfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,#g,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function c101107091.spfilter(c,e,tp)
	return c:IsSetCard(0x27d) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101107091.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoHand(tc,nil,REASON_EFFECT)>0
		and tc:IsLocation(LOCATION_HAND) and Duel.NegateEffect(ev)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(c101107091.spfilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp)
		and Duel.SelectYesNo(tp,aux.Stringid(101107091,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c101107091.spfilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
		if #sg>0 then
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end