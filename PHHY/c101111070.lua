--土地ころがし
function c101111070.initial_effect(c)
	 --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,101111070+EFFECT_COUNT_CODE_OATH)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c101111070.target)
	e1:SetOperation(c101111070.activate)
	c:RegisterEffect(e1)
end
function c101111070.filter(c)
	return c:IsFaceup() and c:IsAbleToRemove() and not c:IsForbidden()
end
function c101111070.filter2(c,targ_p,code)
	return c:IsType(TYPE_FIELD) and c:IsType(TYPE_SPELL) and not c:IsForbidden()
		and not c:IsOriginalCodeRule(code) and (c:IsControler(targ_p) or c:IsAbleToChangeControler())
end
function c101111070.placefield(c,tp,targ_p)
	local fc=Duel.GetFieldCard(targ_p,LOCATION_SZONE,5)
	if fc then
		Duel.SendtoGrave(fc,REASON_RULE)
		Duel.BreakEffect()
	end
	return Duel.MoveToField(c,tp,targ_p,LOCATION_FZONE,POS_FACEUP,true)
end
function c101111070.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_FZONE) and c101111070.filter(chkc) and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(c101111070.filter,tp,LOCATION_FZONE,LOCATION_FZONE,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c101111070.filter,tp,LOCATION_FZONE,LOCATION_FZONE,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c101111070.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local old_fp=tc:GetControler()
	if not tc:IsRelateToEffect(e)
		or Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)==0
		or not tc:IsLocation(LOCATION_REMOVED)
		or (tc:IsControler(old_fp) and not tc:IsAbleToChangeControler())
		or tc:IsForbidden() then return end
	Duel.BreakEffect()
	if not c101111070.placefield(tc,tp,1-old_fp) then return end
	local g=Duel.GetMatchingGroup(c101111070.filter2,tc:GetControler(),LOCATION_GRAVE,0,nil,old_fp,tc:GetOriginalCode())
	if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(101111070,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local pg=g:Select(tp,1,1,nil)
		local pc=pg:GetFirst()
		if not pc then return end
		Duel.HintSelection(pg)
		Duel.BreakEffect()
		c101111070.placefield(pc,tp,old_fp)
	end
end
