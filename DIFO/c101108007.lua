--セリオンズ“キング”レギュラス
function c101108007.initial_effect(c)
	-- Special Summon self
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101108007,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,101108007)
	e1:SetTarget(c101108007.sptg)
	e1:SetOperation(c101108007.spop)
	c:RegisterEffect(e1)
	-- Negate effect
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101108007,1))
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,101108007+100)
	e2:SetCondition(c101108007.discon)
	e2:SetCost(c101108007.discost)
	e2:SetTarget(c101108007.distg)
	e2:SetOperation(c101108007.disop)
	c:RegisterEffect(e2)
	-- Equipped monster gains ATK
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetCondition(c101108007.eqcon)
	e3:SetValue(700)
	c:RegisterEffect(e3)
	-- Equipped monster gains effect
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetTarget(c101108007.eqtg)
	e4:SetLabelObject(e2)
	c:RegisterEffect(e4)
end
function c101108007.eqfilter(c)
	return c:IsType(TYPE_MONSTER) and (c:IsSetCard(0x27a) or c:IsRace(RACE_MACHINE)) and not c:IsForbidden()
end
function c101108007.eqval(ec,c,tp)
	return ec:IsControler(tp) and c:IsType(TYPE_MONSTER) and (c:IsSetCard(0x27a) or c:IsRace(RACE_MACHINE))
end
function c101108007.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c101108007.eqfilter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingTarget(c101108007.eqfilter,tp,LOCATION_GRAVE,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,c101108007.eqfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,0,0)
end
function c101108007.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 
		and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and tc:IsRelateToEffect(e)
		and tc:IsType(TYPE_MONSTER) and not tc:IsForbidden() then
		if not Duel.Equip(tp,tc,c) then return end
		--Add Equip limit
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(c101108007.eqlimit)
		tc:RegisterEffect(e1)
	end
end
function c101108007.eqlimit(e,c)
	return e:GetOwner()==c
end
function c101108007.eqcon(e)
	return e:GetHandler():GetEquipTarget():IsSetCard(0x27a)
end
function c101108007.eqtg(e,c)
	return c==e:GetHandler():GetEquipTarget() and c:IsSetCard(0x27a)
end
function c101108007.discon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and Duel.IsChainDisablable(ev)
end
function c101108007.discostfilter(c)
	return c:IsSetCard(0x27a) and c:GetOriginalType()&TYPE_MONSTER~=0 and c:IsAbleToGraveAsCost()
		and (c:IsFaceup() or c:IsLocation(LOCATION_HAND))
end
function c101108007.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101108007.discostfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c101108007.discostfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c101108007.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not re:GetHandler():IsDisabled() end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function c101108007.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end