--三戦の号
function c101111069.initial_effect(c)
	-- Set 1 Normal Spell/Trap
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101111069,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,101111069+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c101111069.setcon)
	e1:SetTarget(c101111069.settg)
	e1:SetOperation(c101111069.setop)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(101111069,ACTIVITY_CHAIN,c101111069.chainfilter)
end
function c101111069.chainfilter(re,tp,cid)
	return not re:IsActiveType(TYPE_MONSTER)
end
function c101111069.setcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCustomActivityCount(101111069,1-tp,ACTIVITY_CHAIN)~=0
end
function c101111069.stfilter(c,th)
	local typ=c:GetType()
	return (typ==TYPE_TRAP or typ==TYPE_SPELL) and (th and c:IsAbleToHand() or c:IsSSetable()) and not c:IsCode(101111069)
end
function c101111069.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101111069.stfilter,tp,LOCATION_DECK,0,1,nil)
		or (Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c101111069.stfilter,tp,LOCATION_DECK,0,1,nil,true)) end
end
function c101111069.setop(e,tp,eg,ep,ev,re,r,rp)
	local b1=Duel.IsExistingMatchingCard(c101111069.stfilter,tp,LOCATION_DECK,0,1,nil)
	local b2=Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c101111069.stfilter,tp,LOCATION_DECK,0,1,nil,true)
	if b2 and (not b1 or Duel.SelectYesNo(tp,aux.Stringid(101111069,1))) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c101111069.stfilter,tp,LOCATION_DECK,0,1,1,nil,true)
		if #g==0 then return end
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	elseif b1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local tc=Duel.SelectMatchingCard(tp,c101111069.stfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
		if not tc or Duel.SSet(tp,tc)==0 then return end
		-- Cannot be activated this turn
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetCode(EFFECT_CANNOT_TRIGGER)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
