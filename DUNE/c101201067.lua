--アクアの輪唱
function c101201067.initial_effect(c)
	--Banish 1 card from the hand and search 2 with the same name during your next Standby Phase
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101201067,0))
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c101201067.target)
	e1:SetOperation(c101201067.activate)
	c:RegisterEffect(e1)
end
function c101201067.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	e:SetLabel(Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD))
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_HAND)
end
function c101201067.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local tc=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_HAND,0,1,1,nil):GetFirst()
	if not tc or Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)==0 then return end
	--Add up to 2 cards during the Standby Phase
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetCountLimit(1)
	e1:SetLabel(Duel.GetTurnCount(),tc:GetCode())
	e1:SetCondition(c101201067.thcond)
	e1:SetOperation(c101201067.thop)
	e1:SetReset(RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,1)
	Duel.RegisterEffect(e1,tp)
	if e:GetLabel()==0 then
		--If the opponent had 0 cards when this was activated, you cannot activate cards with the same name
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2:SetCode(EFFECT_CANNOT_ACTIVATE)
		e2:SetLabelObject(tc)
		e2:SetTargetRange(1,0)
		e2:SetValue(c101201067.aclimit)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
	end
end
function c101201067.aclimit(e,re,tp)
	local c=re:GetHandler()
	local tc=e:GetLabelObject()
	return c:IsOriginalCodeRule(tc:GetOriginalCodeRule())
end
function c101201067.thcond(e,tp)
	return Duel.GetTurnPlayer()==tp and Duel.GetTurnCount()~=e:GetLabel()
end
function c101201067.thfilter(c,code)
	return c:IsCode(code) and c:IsAbleToHand()
end
function c101201067.thop(e,tp,eg,ep,ev,re,r,rp)
	local _,code=e:GetLabel()
	local g=Duel.GetMatchingGroup(c101201067.thfilter,tp,LOCATION_DECK,0,nil,code)
	if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(101201067,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,2,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
