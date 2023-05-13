--アーマード・エクシーズ
function c100207015.initial_effect(c)
	--Equip 1 Xyz monster to another monster on the field
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100207015,0))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c100207015.target)
	e1:SetOperation(c100207015.activate)
	c:RegisterEffect(e1)
end
function c100207015.eqfilter(c)
	return c:IsType(TYPE_XYZ) and not c:IsForbidden()
end
function c100207015.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if e:GetHandler():IsLocation(LOCATION_HAND) then ft=ft-1 end
	if chk==0 then return ft>0 and Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil,tp)
		and Duel.IsExistingTarget(c100207015.eqfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local tc=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,0,1,1,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local eqc=Duel.SelectTarget(tp,c100207015.eqfilter,tp,LOCATION_GRAVE,0,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,eqc,1,tp,0)
end
function c100207015.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local tc2=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsLocation,nil,LOCATION_MZONE):GetFirst()
	local tc1=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsLocation,nil,LOCATION_GRAVE):GetFirst()
	if tc1 and tc2 and tc1:IsRelateToEffect(e) and aux.NecroValleyFilter()(tc1) then
		if not Duel.Equip(tp,tc1,tc2) then return end
		local atk=tc1:GetTextAttack()
		local att=tc1:GetAttribute()
		--Equip limit
		local e0=Effect.CreateEffect(tc2)
		e0:SetType(EFFECT_TYPE_SINGLE)
		e0:SetCode(EFFECT_EQUIP_LIMIT)
		e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e0:SetValue(c100207015.eqlimit)
		e0:SetLabelObject(tc2)
		e0:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc1:RegisterEffect(e0)
		--ATK becomes the equipped monster's
		local e1=Effect.CreateEffect(tc1)
		e1:SetType(EFFECT_TYPE_EQUIP)
		e1:SetCode(EFFECT_SET_ATTACK)
		e1:SetValue(atk)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc1:RegisterEffect(e1)
		--Gains the attribute of the equipped monster
		local e2=e1:Clone()
		e2:SetCode(EFFECT_ADD_ATTRIBUTE)
		e2:SetValue(att)
		tc1:RegisterEffect(e2)
		--Second attack in a row
		local e3=Effect.CreateEffect(tc1)
		e3:SetDescription(aux.Stringid(100207015,1))
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
		e3:SetCode(EVENT_DAMAGE_STEP_END)
		e3:SetRange(LOCATION_SZONE)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		e3:SetCondition(c100207015.atkcon)
		e3:SetCost(c100207015.atkcost)
		e3:SetOperation(c100207015.atkop)
		tc1:RegisterEffect(e3)
	end
end
function c100207015.eqlimit(e,c)
	return c==e:GetLabelObject()
end
function c100207015.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local bc=Duel.GetBattleMonster(tp)
	local ec=e:GetHandler():GetEquipTarget()
	return bc and bc==ec and bc:IsChainAttackable()
end
function c100207015.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c100207015.atkop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChainAttack()
end