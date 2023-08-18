--ヴァルモニカ・シェルタ
--Valmonica Scelta
function c100421036.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100421036,0))
	e1:SetCategory(CATEGORY_RECOVER+CATEGORY_TODECK+CATEGORY_DRAW+CATEGORY_DAMAGE+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,100421036+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c100421036.target)
	e1:SetOperation(c100421036.activate)
	c:RegisterEffect(e1)
end
function c100421036.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c100421036.thfilter(c)
	return c:IsSetCard(0x2a3) and c:IsType(TYPE_SPELL+TYPE_TRAP) and not c:IsCode(100421036) and c:IsAbleToHand()
end
function c100421036.activate(e,tp,eg,ep,ev,re,r,rp,ex)
	local op=nil
	if ex then
		op=ex
	else
		local sel_player=Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_PZONE,0,1,nil,0x2a3) and tp or 1-tp
		local offset=sel_player==1-tp and 2 or 0
		op=Duel.SelectOption(sel_player,aux.Stringid(100421036,1),aux.Stringid(100421036,2))+1
	end
	if op==1 then
		local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_HAND,0,nil)
		if Duel.Recover(tp,500,REASON_EFFECT)>0 and #g>0 and Duel.IsPlayerCanDraw(tp,2)
			and Duel.SelectYesNo(tp,aux.Stringid(100421036,3)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
			local sc=g:Select(tp,1,1,nil):GetFirst()
			Duel.BreakEffect()
			if not (Duel.SendtoDeck(sc,nil,SEQ_DECKBOTTOM,REASON_EFFECT)>0 and sc:IsLocation(LOCATION_DECK)) then return end
			Duel.Draw(tp,2,REASON_EFFECT)
		end
	elseif op==2 then
		local g=Duel.GetMatchingGroup(c100421036.thfilter,tp,LOCATION_DECK,0,nil)
		if Duel.Damage(tp,500,REASON_EFFECT)>0 and #g>0 and Duel.SelectYesNo(tp,aux.Stringid(100421036,4)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=g:Select(tp,1,1,nil)
			Duel.BreakEffect()
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		end
	end
end
