--Psychic Arsenal
local s,id,o=GetID()
function s.initial_effect(c)
	--Add 1 Machine monster with the from your Deck to your hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
	--Return 1 banished LIGHT/DARK monster to deck, draw 1
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_TOGRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,id+o)
	e2:SetCondition(aux.exccon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(s.tdtg)
	e2:SetOperation(s.tdop)
	c:RegisterEffect(e2)
end
function s.cfilter(c,tp)
	return c:IsFaceup() and c:IsRace(RACE_PSYCHO) and c:IsLevelAbove(1) and Duel.CheckLPCost(tp,c:GetLevel()*200)
		and Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil,c:GetAttribute(),c:GetLevel())
end
function s.thfilter(c,att,lv)
	return c:IsRace(RACE_MACHINE) and c:IsAttribute(att) and c:GetLevel()>lv and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and s.cfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(s.cfilter,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local tc=Duel.SelectTarget(tp,s.cfilter,tp,LOCATION_MZONE,0,1,1,nil,tp):GetFirst()
	e:SetLabel(tc:GetAttribute(),tc:GetLevel())
	Duel.PayLPCost(tp,tc:GetLevel()*200)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local att,lv=e:GetLabel()
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil,att,lv)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function s.tdhndfilter(c,e)
	return c:IsFaceup() and c:IsRace(RACE_PSYCHO+RACE_MACHINE)
		and (c:IsAbleToDeck() or c:IsAbleToHand()) and c:IsCanBeEffectTarget(e)
end
function s.spcchk(c,sg)
	return c:IsAbleToDeck() and sg:IsExists(Card.IsAbleToHand,1,c)
end
function s.rescon(sg,e,tp,mg)
	return sg:GetClassCount(Card.GetRace)==#sg and sg:IsExists(s.spcchk,1,nil,sg)
end
function s.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local g=Duel.GetMatchingGroup(s.tdhndfilter,tp,LOCATION_REMOVED,0,nil,e)
	if chk==0 then return #g>=2 and g:CheckSubGroup(s.rescon,2,2,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local sg=g:SelectSubGroup(tp,s.rescon,false,2,2,e,tp)
	Duel.SetTargetCard(sg)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,sg,1,tp,LOCATION_REMOVED)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,sg,1,tp,LOCATION_REMOVED)
end
function s.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if #g~=2 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local tdg=g:FilterSelect(tp,Card.IsAbleToDeck,1,1,nil):GetFirst()
	if Duel.SendtoDeck(tdg,nil,SEQ_DECKBOTTOM,REASON_EFFECT)>0 then
		g:RemoveCard(tdg)
		if g:GetFirst():IsAbleToHand() then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end