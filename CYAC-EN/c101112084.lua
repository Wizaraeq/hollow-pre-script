--Pendulum Pendant
function c101112084.initial_effect(c)
	--Place 1 Pendulum monster in the Pendulum Zone
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101112084,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_LIMIT_ZONE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,101112084+EFFECT_COUNT_CODE_OATH)
	e1:SetValue(c101112084.zones)
	e1:SetCost(c101112084.cost)
	e1:SetTarget(c101112084.target)
	e1:SetOperation(c101112084.activate)
	c:RegisterEffect(e1)
	--Reduce a Pendulum Scale by 1
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101112084,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c101112084.scltg)
	e2:SetOperation(c101112084.sclop)
	c:RegisterEffect(e2)
end
function c101112084.zones(e,tp,eg,ep,ev,re,r,rp)
	local zone=0xff
	local p0=Duel.CheckLocation(tp,LOCATION_PZONE,0)
	local p1=Duel.CheckLocation(tp,LOCATION_PZONE,1)
	if p0==p1 then return zone end
	if p0 then zone=zone-0x1 end
	if p1 then zone=zone-0x10 end
	return zone
end
function c101112084.costfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM) and c:IsAbleToRemoveAsCost()
end
function c101112084.pendfilter(c)
	return c:IsType(TYPE_PENDULUM) and (c:IsFaceup() or c:IsLocation(LOCATION_DECK)) and not c:IsForbidden()
end
function c101112084.rescon(sg,e,tp,mg)
	return #sg==5 and mg:IsExists(aux.TRUE,1,sg)
end
function c101112084.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c101112084.costfilter,tp,LOCATION_EXTRA,0,nil)
	local pg=Duel.GetMatchingGroup(c101112084.pendfilter,tp,LOCATION_EXTRA+LOCATION_DECK,0,nil)
	if chk==0 then return #g>=5 and g:CheckSubGroup(c101112084.rescon,5,5,e,tp,pg) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local rg=g:SelectSubGroup(tp,c101112084.rescon,false,5,5,e,tp,pg)
	Duel.Remove(rg,POS_FACEUP,REASON_COST)
end
function c101112084.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1))
		and Duel.IsExistingMatchingCard(c101112084.pendfilter,tp,LOCATION_EXTRA+LOCATION_DECK,0,1,nil) end
end
function c101112084.activate(e,tp,eg,ep,ev,re,r,rp)
	if not (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=Duel.SelectMatchingCard(tp,c101112084.pendfilter,tp,LOCATION_EXTRA+LOCATION_DECK,0,1,1,nil):GetFirst()
	if tc then
		Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end
function c101112084.sclfilter(c)
	return c:GetLeftScale()>0
end
function c101112084.scltg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_PZONE) end
	if chk==0 then return Duel.IsExistingTarget(c101112084.sclfilter,tp,LOCATION_PZONE,LOCATION_PZONE,1,nil) end
	Duel.SelectTarget(tp,c101112084.sclfilter,tp,LOCATION_PZONE,LOCATION_PZONE,1,1,nil)
end
function c101112084.sclop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:GetLeftScale()>0 then
		--Reduce its scale by 1
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_UPDATE_LSCALE)
		e1:SetValue(-1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_RSCALE)
		tc:RegisterEffect(e2)
	end
end