--魚群探知機
function c100426020.initial_effect(c)
	-- Add to hand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,100426020+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c100426020.thtg)
	e1:SetOperation(c100426020.thop)
	c:RegisterEffect(e1)
end
function c100426020.thfilter(c)
	return c:IsLevelBelow(7) and c:IsAbleToHand()
		and ((c:IsType(TYPE_NORMAL) and c:IsAttribute(ATTRIBUTE_WATER)) or aux.IsCodeListed(c,22702055))
end
function c100426020.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100426020.thfilter,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c100426020.spfilter(c,e,tp)
	return c:IsType(TYPE_NORMAL) and c:IsAttribute(ATTRIBUTE_WATER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c100426020.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c100426020.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g<1 or Duel.SendtoHand(g,nil,REASON_EFFECT)<1 then return end
	Duel.ConfirmCards(1-tp,g)
	if Duel.IsEnvironment(22702055)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c100426020.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp)
		and Duel.SelectYesNo(tp,aux.Stringid(100426020,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,c100426020.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		if #sg<1 then return end
		Duel.BreakEffect()
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
end