--融合複製
function c101112077.initial_effect(c)
	--copy trap
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(0x1e1,0x1e1)
	e1:SetCountLimit(1,101112077+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c101112077.target)
	e1:SetOperation(c101112077.operation)
	c:RegisterEffect(e1)
end
function c101112077.cpfilter(c)
	return (c:GetType()==TYPE_SPELL or c:IsType(TYPE_QUICKPLAY)) and c:IsSetCard(0x46) and c:IsAbleToRemove() and c:CheckActivateEffect(false,true,false)~=nil
end
function c101112077.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		local te=e:GetLabelObject()
		local tg=te:GetTarget()
		return tg and tg(e,tp,eg,ep,ev,re,r,rp,0,chkc)
	end
	if chk==0 then return Duel.IsExistingTarget(c101112077.cpfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c101112077.cpfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil)
	local te,ceg,cep,cev,cre,cr,crp=g:GetFirst():CheckActivateEffect(false,true,true)
	Duel.ClearTargetCard()
	g:GetFirst():CreateEffectRelation(e)
	local tg=te:GetTarget()
	if tg then tg(e,tp,ceg,cep,cev,cre,cr,crp,1) end
	te:SetLabelObject(e:GetLabelObject())
	e:SetLabelObject(te)
	Duel.ClearOperationInfo(0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c101112077.operation(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	if not te then return end
	local tc=te:GetHandler()
	if tc:IsRelateToEffect(e) and (tc:GetType()==TYPE_SPELL or tc:IsType(TYPE_QUICKPLAY)) and Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)>0 then
		e:SetLabelObject(te:GetLabelObject())
		local op=te:GetOperation()
		if op then op(e,tp,eg,ep,ev,re,r,rp) end
	end
end