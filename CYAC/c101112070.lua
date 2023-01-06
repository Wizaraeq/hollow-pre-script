--赫ける王の烙印
function c101112070.initial_effect(c)
	aux.AddCodeList(c,68468459)
	--Negate the effects of cards on the field
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101112070,0))
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetCountLimit(1,101112070)
	e1:SetTarget(c101112070.distg)
	e1:SetOperation(c101112070.disop)
	c:RegisterEffect(e1)
	--Add itself to the hand during the End Phase
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101112070,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetCountLimit(1,101112070)
	e2:SetCondition(c101112070.thcon)
	e2:SetTarget(c101112070.thtg)
	e2:SetOperation(c101112070.thop)
	c:RegisterEffect(e2)
	--Check for Fusion Monsters sent to the GY
	if not c101112070.global_check then
		c101112070.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_TO_GRAVE)
		ge1:SetOperation(c101112070.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c101112070.checkfilter(c,tp)
	return c:IsType(TYPE_FUSION) and c:IsControler(tp)
end
function c101112070.checkop(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(c101112070.checkfilter,1,nil,0) then Duel.RegisterFlagEffect(0,101112070,RESET_PHASE+PHASE_END,0,1) end
	if eg:IsExists(c101112070.checkfilter,1,nil,1) then Duel.RegisterFlagEffect(1,101112070,RESET_PHASE+PHASE_END,0,1) end
end
function c101112070.cfilter(c,sc)
	return c:IsFaceup() and c:IsType(TYPE_FUSION) and aux.IsMaterialListCode(c,68468459)
		and Duel.IsExistingMatchingCard(Card.IsNegatable,0,LOCATION_ONFIELD,LOCATION_ONFIELD,1,Group.FromCards(c,sc))
end
function c101112070.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c101112070.cfilter,tp,LOCATION_MZONE,0,1,nil,c) end
	local g=Duel.GetMatchingGroup(aux.NegateAnyFilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,c)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,(#g-1),0,0)
end
function c101112070.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local exc=Duel.SelectMatchingCard(tp,c101112070.cfilter,tp,LOCATION_MZONE,0,1,1,nil,c)
	if #exc==0 then return end
	Duel.HintSelection(exc)
	exc:AddCard(c)
	local g=Duel.GetMatchingGroup(aux.NegateAnyFilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,exc)
	for tc in aux.Next(g) do
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		if tc:IsType(TYPE_TRAPMONSTER) then
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e3)
		end
	end
end
function c101112070.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,101112070)~=0 and Duel.GetCurrentPhase()==PHASE_END
end
function c101112070.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,c,1,0,0)
end
function c101112070.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,c)
	end
end