--ピースリア
function c101107032.initial_effect(c)
	c:EnableCounterPermit(0x61)
	c:SetCounterLimit(0x61,4)
	--battle indestructable
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--place counter
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101107032,0))
	e2:SetCategory(CATEGORY_COUNTER+CATEGORY_DRAW+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DAMAGE_STEP_END)
	e2:SetTarget(c101107032.cttg)
	e2:SetOperation(c101107032.ctop)
	c:RegisterEffect(e2)
end
function c101107032.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	if chk==0 then return bc and c:IsLocation(LOCATION_MZONE) and c:IsRelateToBattle() 
		and c:IsCanAddCounter(0x61,1) end
end
function c101107032.thfilter1(c)
	return c:IsAbleToHand() and c:IsType(TYPE_MONSTER)
end
function c101107032.thfilter2(c)
	return c:IsAbleToHand()
end
function c101107032.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:AddCounter(0x61,1) then
		local ct=c:GetCounter(0x61)
		if ct==1 and Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_DECK,0,1,nil,TYPE_MONSTER) and Duel.SelectYesNo(tp,aux.Stringid(101107032,1)) then
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(101107032,2))
			local g=Duel.SelectMatchingCard(tp,Card.IsType,tp,LOCATION_DECK,0,1,1,nil,TYPE_MONSTER)
			local tc=g:GetFirst()
			if tc then
				Duel.ShuffleDeck(tp)
				Duel.MoveSequence(tc,0)
				Duel.ConfirmDecktop(tp,1)
			end
		end
		if ct==2 and Duel.IsPlayerCanDraw(tp,1) and Duel.SelectYesNo(tp,aux.Stringid(101107032,1)) then
			Duel.Draw(tp,1,REASON_EFFECT)
		end
		if ct==3 and Duel.IsExistingMatchingCard(c101107032.thfilter1,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(101107032,1)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local g=Duel.SelectMatchingCard(tp,c101107032.thfilter1,tp,LOCATION_DECK,0,1,1,nil)
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
		if ct==4 and Duel.IsExistingMatchingCard(c101107032.thfilter2,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(101107032,1)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local g=Duel.SelectMatchingCard(tp,c101107032.thfilter2,tp,LOCATION_DECK,0,1,1,nil)
			Duel.SendtoHand(g,nil,REASON_EFFECT)
		end
	end
end