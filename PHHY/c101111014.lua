--昆虫機甲鎧
function c101111014.initial_effect(c)
	--Equip itself to an insect monster
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101111014,0))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,101111014)
	e1:SetCondition(c101111014.eqcond)
	e1:SetTarget(c101111014.eqtg)
	e1:SetOperation(c101111014.eqop)
	c:RegisterEffect(e1)
	--ATK/DEF
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetCondition(c101111014.atkcon)
	e2:SetValue(1500)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	e3:SetValue(2000)
	c:RegisterEffect(e3)
end
function c101111014.cfilter(c)
	return c:IsCode(101111014) and c:IsFaceup()
end
function c101111014.eqcond(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c101111014.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c101111014.eqfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_INSECT)
end
function c101111014.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c101111014.eqfilter(chkc) and chkc:IsRace(RACE_INSECT) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c101111014.eqfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c101111014.eqfilter,tp,LOCATION_MZONE,0,1,1,nil)
	local c=e:GetHandler()
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,c,1,tp,0)
	if c:IsLocation(LOCATION_GRAVE) then
		Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,c,0,0,0)
	end
end
function c101111014.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)==0 or tc:IsFacedown() or not tc:IsRelateToEffect(e) then
		return Duel.SendtoGrave(c,REASON_RULE)
	end
	if Duel.Equip(tp,c,tc) then
		--Equip limit registration
		local e0=Effect.CreateEffect(c)
		e0:SetType(EFFECT_TYPE_SINGLE)
		e0:SetCode(EFFECT_EQUIP_LIMIT)
		e0:SetReset(RESET_EVENT+RESETS_STANDARD)
		e0:SetValue(c101111014.eqlimit)
		e0:SetLabelObject(tc)
		c:RegisterEffect(e0)
		--Banish itself and the equipped monster when they leave the field
		local rg=Group.FromCards(c,tc)
		local tc=rg:GetFirst()
		while tc do
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
			e1:SetValue(LOCATION_REMOVED)
			e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
			tc:RegisterEffect(e1)
			tc=rg:GetNext()
		end
	end
end
function c101111014.eqlimit(e,c)
	return c==e:GetLabelObject()
end
function c101111014.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN2 or (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE)
end