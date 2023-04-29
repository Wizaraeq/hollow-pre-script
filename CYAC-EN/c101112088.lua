--Gold Pride - Chariot Carrie
function c101112088.initial_effect(c)
	aux.AddCodeList(c,96305350)
	--xyz summon
	aux.AddXyzProcedure(c,nil,3,2)
	c:EnableReviveLimit()
	--Search 1 "Gold Pride" Spell
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101112088,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,101112088)
	e1:SetCost(c101112088.thcost)
	e1:SetTarget(c101112088.thtg)
	e1:SetOperation(c101112088.thop)
	c:RegisterEffect(e1)
	--Return itself to the Extra Deck and Special Summon "Gold Pride - Captain Carrie"
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101112088,1))
	e2:SetCategory(CATEGORY_TOEXTRA+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c101112088.spcon)
	e2:SetTarget(c101112088.sptg)
	e2:SetOperation(c101112088.spop)
	c:RegisterEffect(e2)
end
function c101112088.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c101112088.thfilter(c)
	return c:IsSetCard(0x192) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function c101112088.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101112088.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	e:GetHandler():RegisterFlagEffect(101112088,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function c101112088.tgfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x192) and c:IsAbleToGrave()
end
function c101112088.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local thc=Duel.SelectMatchingCard(tp,c101112088.thfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	if not (thc and Duel.SendtoHand(thc,nil,REASON_EFFECT)>0 and thc:IsLocation(LOCATION_HAND)) then return end
	Duel.ConfirmCards(1-tp,thc)
	local g=Duel.GetMatchingGroup(c101112088.tgfilter,tp,LOCATION_DECK,0,nil)
	if Duel.GetLP(tp)<Duel.GetLP(1-tp) and #g>0 and Duel.SelectYesNo(tp,aux.Stringid(101112088,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local gyg=Duel.SelectMatchingCard(tp,c101112088.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
		if #gyg>0 then
			Duel.BreakEffect()
			Duel.SendtoGrave(gyg,REASON_EFFECT)
		end
	end
end
function c101112088.spcon(e)
	return e:GetHandler():GetFlagEffect(101112088)>0
end
function c101112088.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c101112088.spfilter(c,e,tp)
	return c:IsCode(96305350) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101112088.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsAbleToExtra() and Duel.SendtoDeck(c,nil,SEQ_DECKBOTTOM,REASON_EFFECT)>0
		and c:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c101112088.spfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
		if #g>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
