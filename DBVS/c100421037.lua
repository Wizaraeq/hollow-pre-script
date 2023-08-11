--ヴァルモニカ・ヴェルサーレ
function c100421037.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100421037,0))
	e1:SetCategory(CATEGORY_RECOVER+CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DAMAGE+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,100421037+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c100421037.target)
	e1:SetOperation(c100421037.activate)
	c:RegisterEffect(e1)
end
function c100421037.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c100421037.tgfilter(c)
	return c:IsSetCard(0x2a3) and c:IsAbleToGrave() and not c:IsCode(100421037) 
end
function c100421037.activate(e,tp,eg,ep,ev,re,r,rp,ex)
	local op=nil
	if ex then
		op=ex
	else
		local sel_player=Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_PZONE,0,1,nil,0x2a3) and tp or 1-tp
		op=Duel.SelectOption(sel_player,aux.Stringid(100421037,1),aux.Stringid(100421037,2))+1
	end
	if op==1 then
		local g1=Duel.GetMatchingGroup(Card.IsSetCard,tp,LOCATION_DECK,0,nil,0x2a3)
		if Duel.Recover(tp,500,REASON_EFFECT)>0 and #g1>0 and Duel.SelectYesNo(tp,aux.Stringid(100421037,3)) then
			local spcard,seq=g1:GetMaxGroup(Card.GetSequence)
			spcard=spcard:GetFirst()
			if not spcard then return end
			Duel.BreakEffect()
			Duel.ConfirmDecktop(tp,Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)-seq)
			if spcard:IsAbleToHand() then
				Duel.SendtoHand(spcard,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,spcard)
			else
				Duel.SendtoGrave(spcard,REASON_RULE)
			end
		end
	elseif op==2 then
		local g2=Duel.GetMatchingGroup(c100421037.tgfilter,tp,LOCATION_DECK,0,nil)
		if Duel.Damage(tp,500,REASON_EFFECT)>0 and #g2>0 and Duel.SelectYesNo(tp,aux.Stringid(100421037,4)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local sg=g2:Select(tp,1,1,nil)
			Duel.BreakEffect()
			Duel.SendtoGrave(sg,REASON_EFFECT)
		end
	end
end