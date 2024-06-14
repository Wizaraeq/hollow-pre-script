--ユニオン・パイロット
local s,id,o=GetID()
function s.initial_effect(c)
	aux.EnableUnionAttribute(c,s.filter)
	--reequip
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,2))
	e4:SetCategory(CATEGORY_EQUIP)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1,id)
	e4:SetCost(s.recost)
	e4:SetTarget(s.retg)
	e4:SetOperation(s.reop)
	c:RegisterEffect(e4)
end
s.has_text_type=TYPE_UNION
function s.filter(c)
	return c:IsType(TYPE_EFFECT)
end
function s.recost(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=e:GetHandler():GetEquipTarget()
	e:SetLabelObject(tc)
	if chk==0 then return e:GetHandler():IsAbleToHandAsCost() end
	Duel.SendtoHand(e:GetHandler(),nil,REASON_COST)
end
function s.refilter(c,tc,tp,exclude_modern_count)
	return aux.CheckUnionEquip(c,tc,exclude_modern_count) and c:CheckUnionTarget(tc) and c:IsType(TYPE_UNION)
		and c:CheckUniqueOnField(tp) and not c:IsForbidden()
end
function s.retg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local c=e:GetHandler()
		local exct=aux.IsUnionState(e) and 1 or 0
		return c:GetEquipTarget()
			and Duel.IsExistingMatchingCard(s.refilter,tp,LOCATION_REMOVED,0,1,nil,c:GetEquipTarget(),tp,exct)
	end
	local tc=e:GetLabelObject()
	Duel.SetTargetCard(tc)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,tc,1,0,0)
end
function s.reop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local g=Duel.SelectMatchingCard(tp,s.refilter,tp,LOCATION_REMOVED,0,1,1,nil,tc,tp,nil)
		local ec=g:GetFirst()
		if ec and Duel.Equip(tp,ec,tc) then
			aux.SetUnionState(ec)
		end
	end
end