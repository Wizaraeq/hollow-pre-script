--サンダー・ディスチャージ
function c100417035.initial_effect(c)
	aux.AddCodeList(c,100417125)
	--Destroy + Equip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100417035,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_EQUIP)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,100417035+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c100417035.condition)
	e1:SetTarget(c100417035.target)
	e1:SetOperation(c100417035.operation)
	c:RegisterEffect(e1)
end
function c100417035.tgfilter(c,tp)
	return c:GetEquipGroup():IsExists(c100417035.tgfilter2,1,nil) and Duel.IsExistingMatchingCard(c100417035.desfilter,tp,0,LOCATION_MZONE,1,nil,c:GetAttack())
end
function c100417035.tgfilter2(c)
	return aux.IsCodeListed(c,100417125)
end
function c100417035.desfilter(c,atk)
	return c:GetAttack()<=atk
end
function c100417035.eqfilter(c,tp)
	return c:IsType(TYPE_EQUIP) and aux.IsCodeListed(c,100417125) and Duel.IsExistingMatchingCard(c100417035.eqfilter2,tp,LOCATION_MZONE,0,1,nil,c)
end
function c100417035.eqfilter2(c,tc)
	return c:IsFaceup() and tc:CheckEquipTarget(c)
end
function c100417035.cfilter(c)
	return c:IsFaceup() and c:IsCode(100417125)
end
function c100417035.condition(e,tp,eg,ep,ev,re,r,rp) 
	return Duel.IsExistingMatchingCard(c100417035.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c100417035.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsMonster() and c100417035.tgfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c100417035.tgfilter,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local tc=Duel.SelectTarget(tp,c100417035.tgfilter,tp,LOCATION_MZONE,0,1,1,nil,tp):GetFirst()
	local g=Duel.GetMatchingGroup(c100417035.desfilter,tp,0,LOCATION_MZONE,nil,tc:GetAttack())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,1-tp,LOCATION_MZONE)
	e:SetLabelObject(tc)
end
function c100417035.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if not tc or not tc:IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c100417035.desfilter,tp,0,LOCATION_MZONE,nil,tc:GetAttack())
	if #g>0 then
		if Duel.Destroy(g,REASON_EFFECT)>0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(c100417035.eqfilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,tp) and Duel.SelectYesNo(tp,aux.Stringid(100417035,1)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
			tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c100417035.eqfilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,tp):GetFirst()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
			local tc2=Duel.SelectMatchingCard(tp,c100417035.eqfilter2,tp,LOCATION_MZONE,0,1,1,nil,tc):GetFirst()
			Duel.Equip(tp,tc,tc2)
		end
	end
end