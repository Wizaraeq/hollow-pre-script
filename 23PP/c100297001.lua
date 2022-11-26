--武装再生
function c100297001.initial_effect(c)
	-- Make a monster gain 800 ATK or Set or Equip a card from the GY
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,100297001+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c100297001.target)
	e1:SetOperation(c100297001.operation)
	c:RegisterEffect(e1)
end
function c100297001.eqcfilter(c,tp)
	return c:IsType(TYPE_EQUIP) and (c:IsSSetable()
		or Duel.IsExistingMatchingCard(c100297001.eqtfilter,tp,LOCATION_MZONE,0,1,nil,c,tp))
end
function c100297001.eqtfilter(c,ec,tp)
	return c:IsFaceup() and ec:CheckEquipTarget(c) and ec:CheckUniqueOnField(tp)
end
function c100297001.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil)
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if e:GetHandler():IsLocation(LOCATION_HAND) then ft=ft-1 end
	local b2=ft>0 and Duel.IsExistingTarget(c100297001.eqcfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,tp)
	if chk==0 then return b1 or b2 end
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(100297001,0),aux.Stringid(100297001,1))
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(100297001,0))
	elseif b2 then
		op=Duel.SelectOption(tp,aux.Stringid(100297001,1))+1
	end
	e:SetLabel(op)
	if op==0 then
		e:SetCategory(CATEGORY_ATKCHANGE)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		local tc=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,0,1,1,nil)
		Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,tc,1,tp,800)
	else
		e:SetCategory(CATEGORY_EQUIP)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		local tc=Duel.SelectTarget(tp,c100297001.eqcfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,tp):GetFirst()
		Duel.SetOperationInfo(0,CATEGORY_EQUIP,tc,1,tp,0)
		Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,tc,1,tc:GetControler(),0)
	end
end
function c100297001.operation(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==0 then
		local tc=Duel.GetFirstTarget()
		if tc:IsFaceup() and tc:IsRelateToEffect(e) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(800)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
		end
	else
		if Duel.GetLocationCount(tp,LOCATION_SZONE)==0 then return end
		local eqpc=Duel.GetFirstTarget()
		if not eqpc:IsRelateToEffect(e) then return end
		local b1=eqpc:IsSSetable()
		local b2=Duel.IsExistingMatchingCard(c100297001.eqtfilter,tp,LOCATION_MZONE,0,1,nil,eqpc,tp)
		if b1 and b2 then
			op=Duel.SelectOption(tp,aux.Stringid(100297001,2),aux.Stringid(100297001,3))
		elseif b1 then
			op=Duel.SelectOption(tp,aux.Stringid(100297001,2))
		elseif b2 then
			op=Duel.SelectOption(tp,aux.Stringid(100297001,3))+1
		end
		if op==0 then
			Duel.SSet(tp,eqpc)
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
			local eqptg=Duel.SelectMatchingCard(tp,c100297001.eqtfilter,tp,LOCATION_MZONE,0,1,1,nil,eqpc,tp):GetFirst()
			if not eqptg then return end
			Duel.Equip(tp,eqpc,eqptg)
		end
	end
end