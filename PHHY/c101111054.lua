--タリホー！スプリガンズ！
function c101111054.initial_effect(c)
	-- Search 1 "Springans" monster
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101111054,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,101111054)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetCost(c101111054.thcost)
	e1:SetTarget(c101111054.thtg)
	e1:SetOperation(c101111054.thop)
	c:RegisterEffect(e1)
	-- Add this card to your hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101111054,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,101111054)
	e2:SetCost(c101111054.gthcost)
	e2:SetTarget(c101111054.gthtg)
	e2:SetOperation(c101111054.gthop)
	c:RegisterEffect(e2)
end
function c101111054.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if Duel.CheckRemoveOverlayCard(tp,1,0,1,REASON_COST)
		and Duel.SelectYesNo(tp,aux.Stringid(101111054,2))
		and Duel.RemoveOverlayCard(tp,1,0,1,3,REASON_COST) then
		Duel.SetTargetParam(#Duel.GetOperatedGroup())
	end
end
function c101111054.thfilter(c)
	return c:IsSetCard(0x155) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c101111054.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101111054.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	local ct=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
end
function c101111054.spfilter(c,e,tp)
	return c:IsSetCard(0x155) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101111054.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c101111054.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g==0 or Duel.SendtoHand(g,nil,REASON_EFFECT)==0 
		or not g:GetFirst():IsLocation(LOCATION_HAND) then return end
	Duel.ConfirmCards(1-tp,g)
	local ct=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if not ct or ct<=0 or ft<ct or (ct>1 and Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT)) then return end
	local sg=Duel.GetMatchingGroup(aux.NecroValleyFilter(c101111054.spfilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,nil,e,tp)
	if #sg<ct or not Duel.SelectYesNo(tp,aux.Stringid(101111054,3)) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local ssg=sg:Select(tp,ct,ct,nil)
	if #ssg==ct then
		Duel.BreakEffect()
		Duel.SpecialSummon(ssg,1,tp,tp,false,false,POS_FACEUP)
	end
end
function c101111054.gthcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckRemoveOverlayCard(tp,1,0,1,REASON_COST) end
	Duel.RemoveOverlayCard(tp,1,0,1,1,REASON_COST)
end
function c101111054.gthtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,c,1,tp,LOCATION_GRAVE)
end
function c101111054.gthop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,c)
	end
end