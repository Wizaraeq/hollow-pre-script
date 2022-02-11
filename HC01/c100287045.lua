--青い涙の天使
function c100287045.initial_effect(c)
	--Negate 1 face-up monster on the field
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DAMAGE+CATEGORY_DISABLE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_PLAYER_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,100287045)
	e1:SetTarget(c100287045.target)
	e1:SetOperation(c100287045.activate)
	c:RegisterEffect(e1)
	--Set 1 Normal Trap from hand or Deck
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_DAMAGE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,100287045)
	e2:SetCost(aux.bfgcost)
	e2:SetCondition(c100287045.setcon)
	e2:SetTarget(c100287045.settg)
	e2:SetOperation(c100287045.setop)
	c:RegisterEffect(e2)
end
function c100287045.tgfilter(c,ac)
	return aux.disfilter1(c) and Duel.GetMatchingGroupCount(nil,c:GetControler(),0,LOCATION_HAND,ac)>0
end
function c100287045.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c100287045.tgfilter(chkc,c) end
	if chk==0 then return Duel.IsExistingTarget(c100287045.tgfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c100287045.tgfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,c)
	local p=g:GetFirst():GetControler()
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-p,Duel.GetFieldGroupCount(1-p,LOCATION_HAND,0)*200)
end
function c100287045.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local p=tc:GetControler()
		local dam=Duel.GetFieldGroupCount(1-p,LOCATION_HAND,0)*200
		if Duel.Damage(1-p,dam,REASON_EFFECT)>0 and tc:IsFaceup() and not tc:IsDisabled() then
			Duel.BreakEffect()
			Duel.NegateRelatedChain(tc,RESET_TURN_SET)
			local c=e:GetHandler()
			--Negate its effects
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetValue(RESET_TURN_SET)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e2)
		end
	end
end
function c100287045.setcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_EFFECT)~=0
end
function c100287045.setfilter(c)
	return c:GetType()==TYPE_TRAP and c:IsSSetable()
end
function c100287045.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100287045.setfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil) end
end
function c100287045.setop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c100287045.setfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil)
	if #g==0 then return end
	local hand_chk=g:GetFirst():IsLocation(LOCATION_HAND)
	if Duel.SSet(tp,g)>0 and hand_chk then
		--can be activated this turn
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		g:GetFirst():RegisterEffect(e1)
	end
end
