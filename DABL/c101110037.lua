--沈黙狼
function c101110037.initial_effect(c)
	--Equip the top card
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101110037,0))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(c101110037.eqtg)
	e1:SetOperation(c101110037.eqop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--Opponent must guess the card at the End Phase
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(101110037,1))
	e3:SetCategory(CATEGORY_TOGRAVE+CATEGORY_HANDES+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,101110037)
	e3:SetCondition(c101110037.condition)
	e3:SetOperation(c101110037.operation)
	c:RegisterEffect(e3)
end
function c101110037.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_DECK)
end
function c101110037.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	local ec=Duel.GetDecktopGroup(tp,1):GetFirst()
	if ec then
		Duel.DisableShuffleCheck()
		if not Duel.Equip(tp,ec,c,false) then return end
		ec:RegisterFlagEffect(101110037,RESET_EVENT+RESETS_STANDARD,0,1)
		--ATK increase
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetValue(c101110037.eqlimit)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		ec:RegisterEffect(e1)
		local e2=Effect.CreateEffect(ec)
		e2:SetType(EFFECT_TYPE_EQUIP)
		e2:SetCode(EFFECT_UPDATE_ATTACK)
		e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e2:SetValue(500)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		ec:RegisterEffect(e2)
	end
end
function c101110037.eqlimit(e,c)
	return c:GetControler()==e:GetHandlerPlayer()
end
function c101110037.eqfilter(c)
	return c:GetFlagEffect(101110037)>0
end
function c101110037.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=c:GetEquipGroup():Filter(c101110037.eqfilter,nil)
	return #g>0
end
function c101110037.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local eg=c:GetEquipGroup():Filter(c101110037.eqfilter,nil)
	if not eg or #eg==0 then return end
	local op=Duel.AnnounceType(1-tp)
	Duel.ConfirmCards(1-tp,eg:GetFirst())
	local res=c101110037.testtype(op,eg:GetFirst())
	if res then
		Duel.SendtoGrave(c,REASON_EFFECT)
	else
		local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND,nil)
		if #g==0 then return end
		local sg=g:RandomSelect(1-tp,1)
		if Duel.SendtoGrave(sg,REASON_DISCARD+REASON_EFFECT)>0 then
			Duel.SendtoHand(c,nil,REASON_EFFECT)
		end
	end
end
function c101110037.testtype(op,c)
	return (op==0 and c:GetOriginalType()&TYPE_MONSTER~=0)
		or (op==1 and c:GetOriginalType()&TYPE_SPELL~=0)
		or (op==2 and c:GetOriginalType()&TYPE_TRAP~=0)
end