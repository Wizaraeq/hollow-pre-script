--Libromancer Displaced
function c101108090.initial_effect(c)
	--Return and take control
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101108090,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_CONTROL)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetCountLimit(1,101108090,EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c101108090.target)
	e1:SetOperation(c101108090.activate)
	c:RegisterEffect(e1)
end
function c101108090.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x17c)
end
function c101108090.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c101108090.filter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingTarget(Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g1=Duel.SelectTarget(tp,c101108090.filter,tp,LOCATION_MZONE,0,1,1,nil)
	e:SetLabelObject(g1:GetFirst())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g2=Duel.SelectTarget(tp,Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g1,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g2,1,0,0)
end
function c101108090.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if #g<1 then return end
	local tg1=g:GetFirst()
	local tg2=g:GetNext()
	if tg2==e:GetLabelObject() then tg1,tg2=tg2,tg1 end
	if Duel.SendtoHand(tg1,nil,REASON_EFFECT)>0 then
		Duel.GetControl(tg2,tp)
		if not (tg1:IsType(TYPE_RITUAL) and tg1:IsType(TYPE_MONSTER)) then
			local c=e:GetHandler()
			local fid=c:GetFieldID()
			tg2:RegisterFlagEffect(101108090,RESET_EVENT+RESETS_STANDARD,0,1,fid)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
			e1:SetCode(EVENT_PHASE+PHASE_END)
			e1:SetCountLimit(1)
			e1:SetLabel(fid)
			e1:SetLabelObject(tg2)
			e1:SetCondition(c101108090.thcon)
			e1:SetOperation(c101108090.thop)
			Duel.RegisterEffect(e1,tp)
		end
	end
end
function c101108090.thcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffectLabel(101108090)~=e:GetLabel() then
		e:Reset()
		return false
	else return true end
end
function c101108090.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoHand(e:GetLabelObject(),nil,REASON_EFFECT)
end
