--Ｖｏｉｃｉ ｌａ Ｃａｒｔｅ～メニューはこちら～
function c100420036.initial_effect(c)
	--Take 2 "Nouvellez" monsters and make the opponent select 1 of them to add to your hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100420036,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_GRAVE_ACTION)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,100420036,EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c100420036.target)
	e1:SetOperation(c100420036.activate)
	c:RegisterEffect(e1)
end
function c100420036.thfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x293) and c:IsAbleToHand() and not c:IsPublic()
end
function c100420036.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c100420036.thfilter,tp,LOCATION_DECK,0,nil)
	if chk==0 then return #g>=2 and g:GetClassCount(Card.GetCode)>=2 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c100420036.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c100420036.thfilter,tp,LOCATION_DECK,0,nil)
	if #g<2 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local sg=g:SelectSubGroup(tp,aux.dncheck,false,2,2)
	Duel.ConfirmCards(1-tp,sg)
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_ATOHAND) --maybe a custom string because this is "Select the card(s) to add to your hand"
	local g=sg:Select(1-tp,1,1,nil)
	if #g>0 then
		local rac=g:GetFirst():GetRace()
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		if Duel.IsExistingMatchingCard(aux.NecroValleyFilter(c100420036.cfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,rac) and Duel.SelectYesNo(tp,aux.Stringid(100420036,1)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c100420036.cfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,rac)
			if #tc>0 then
				Duel.BreakEffect()
				Duel.SendtoHand(tc,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,tc)
			end
		end
	end
end
function c100420036.cfilter(c,rac)
	return c:IsAbleToHand() and ((rac==RACE_BEASTWARRIOR and c:IsCode(100420037))
		or (rac==RACE_WARRIOR and c:IsCode(100420038)))
end