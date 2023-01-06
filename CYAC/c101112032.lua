--ウサミミ導師
function c101112032.initial_effect(c)
	--Add Counters
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101112032,0))
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c101112032.countercond)
	e1:SetTarget(c101112032.countertg)
	e1:SetOperation(c101112032.counterop)
	c:RegisterEffect(e1)
	--Monsters with counters cannot be destroyed by battle
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c101112032.indtg)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--Banish itself and a monster with counters
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(101112032,1))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e3:SetCountLimit(1)
	e3:SetTarget(c101112032.rmtg)
	e3:SetOperation(c101112032.rmop)
	c:RegisterEffect(e3)
end
function c101112032.indtg(e,c)
	return c:GetCounter(0x1162)>0
end
function c101112032.countercond(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_MONSTER)
		and Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)==LOCATION_MZONE and not re:GetHandler():IsCode(101112032)
end
function c101112032.countertg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return re:GetHandler():IsRelateToEffect(re) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,tp,LOCATION_HAND)
end
function c101112032.counterop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if rc:IsRelateToEffect(re) then
		rc:AddCounter(0x1162,1)
	end
end
function c101112032.cfilter(c)
	return c:IsAbleToRemove() and c:GetCounter(0x1162)>0
end
function c101112032.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_ONFIELD) and s.cfilter(chkc) end
	if chk==0 then return c:IsAbleToRemove() and Duel.IsExistingTarget(c101112032.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,c) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c101112032.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,c)
	g:AddCard(e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,2,0,0)
end
function c101112032.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not c:IsRelateToEffect(e) or not tc:IsRelateToEffect(e) then return end
	local g=Group.FromCards(c,tc)
	if Duel.Remove(g,0,REASON_EFFECT+REASON_TEMPORARY)~=0 then
		local ct=Duel.GetCurrentPhase()<=PHASE_STANDBY and 2 or 1
		local og=Duel.GetOperatedGroup():Filter(Card.IsLocation,nil,LOCATION_REMOVED)
		local c=e:GetHandler()
		for tc in aux.Next(og) do
			tc:RegisterFlagEffect(101112032,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY,0,ct)
		end
		og:KeepAlive()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
		e1:SetReset(RESET_PHASE+PHASE_STANDBY,ct)
		e1:SetLabelObject(og)
		e1:SetCountLimit(1)
		e1:SetCondition(c101112032.retcon)
		e1:SetOperation(c101112032.retop)
		e1:SetLabel(Duel.GetTurnCount())
		Duel.RegisterEffect(e1,tp)
	end
end
function c101112032.retfilter(c,e)
	return c:GetFlagEffect(101112032)~=0 and Duel.GetTurnCount()~=e:GetLabel()
end
function c101112032.retcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabelObject():IsExists(c101112032.retfilter,1,nil,e)
end
function c101112032.retop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local sg=g:Filter(c101112032.retfilter,nil,e)
	if sg:GetCount()>1 and Duel.GetLocationCount(1-tp,LOCATION_MZONE)==1 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(101112032,1))
		local tc=sg:Select(tp,1,1,nil):GetFirst()
		Duel.ReturnToField(tc)
	else
		local tc=sg:GetFirst()
		while tc do
			Duel.ReturnToField(tc)
			tc=sg:GetNext()
		end
	end
end