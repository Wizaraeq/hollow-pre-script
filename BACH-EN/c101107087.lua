--Libromancer Agent
function c101107087.initial_effect(c)
	-- Special Summon self
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101107087,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,101107087)
	e1:SetCost(c101107087.spcost)
	e1:SetTarget(c101107087.sptg)
	e1:SetOperation(c101107087.spop)
	c:RegisterEffect(e1)
	-- Add 1 "Libromancer" card from the GY to the hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101107087,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,101107087+100)
	e2:SetTarget(c101107087.thtg)
	e2:SetOperation(c101107087.thop)
	c:RegisterEffect(e2)
end
function c101107087.spcostfilter(c)
	return bit.band(c:GetType(),0x81)==0x81 and not c:IsPublic()
end
function c101107087.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c101107087.spcostfilter,tp,LOCATION_HAND,0,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c101107087.spcostfilter,tp,LOCATION_HAND,0,1,1,c)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
end
function c101107087.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c101107087.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c101107087.thfilter(c)
	return c:IsSetCard(0x27d) and not c:IsCode(101107087) and c:IsAbleToHand()
end
function c101107087.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c101107087.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101107087.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c101107087.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,LOCATION_GRAVE)
	if g:GetFirst():IsType(TYPE_SPELL+TYPE_TRAP) then
		Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,0,LOCATION_HAND)
	end
end
function c101107087.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoHand(tc,nil,REASON_EFFECT)>0
		and tc:IsLocation(LOCATION_HAND) and tc:IsType(TYPE_SPELL+TYPE_TRAP) then
		Duel.ShuffleHand(tp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,1,nil)
		if #g>0 then
			Duel.BreakEffect()
			Duel.SendtoDeck(g,nil,SEQ_DECKBOTTOM,REASON_EFFECT)
		end
	end
end