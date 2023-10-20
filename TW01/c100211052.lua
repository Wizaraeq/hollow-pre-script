--レアル・ジェネクス・ウンディーネ
function c100211052.initial_effect(c)
	--Banish 1 "Genex" monster from your GY and gain its Attribute
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100211052,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c100211052.attrcost)
	e1:SetOperation(c100211052.attrop)
	c:RegisterEffect(e1)
	--Add 2 "Genex" monsters from your GY to your hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100211052,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c100211052.thcon)
	e2:SetTarget(c100211052.thtg)
	e2:SetOperation(c100211052.thop)
	c:RegisterEffect(e2)
end
function c100211052.attrcfilter(c,attr)
	return c:IsSetCard(0x2) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost() and attr&c:GetAttribute()==0
end
function c100211052.attrcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local attr=e:GetHandler():GetAttribute()
	if chk==0 then return Duel.IsExistingMatchingCard(c100211052.attrcfilter,tp,LOCATION_GRAVE,0,1,nil,attr) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sc=Duel.SelectMatchingCard(tp,c100211052.attrcfilter,tp,LOCATION_GRAVE,0,1,1,nil,attr):GetFirst()
	Duel.Remove(sc,POS_FACEUP,REASON_COST)
	local tn_chk=sc:IsType(TYPE_TUNER) and 1 or 0
	e:SetLabel(sc:GetAttribute(),tn_chk)
end
function c100211052.attrop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not (c:IsFaceup() and c:IsRelateToEffect(e)) then return end
	local attr,tn_chk=e:GetLabel()
	if c:IsAttribute(attr) then return end
	--This card gains that monster's Attribute
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_ADD_ATTRIBUTE)
	e1:SetValue(attr)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
	c:RegisterEffect(e1)
	if tn_chk>0 and not c:IsType(TYPE_TUNER) and Duel.SelectYesNo(tp,aux.Stringid(100211052,2)) then
	Duel.BreakEffect()
	--non tuner
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EFFECT_ADD_TYPE)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e2:SetValue(TYPE_TUNER)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_NONTUNER)
	e3:SetValue(c100211052.tnval)
	e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e3)
	end
end
function c100211052.tnval(e,c)
	return e:GetHandler():IsControler(c:GetControler())
end
function c100211052.thcfilter(c)
	return c:IsSetCard(0x2) and c:IsType(TYPE_SYNCHRO) and c:IsFaceup()
end
function c100211052.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c100211052.thcfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c100211052.thfilter(c,e)
	return c:IsSetCard(0x2) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and c:IsCanBeEffectTarget(e)
end
function c100211052.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToHand() and c:IsCanBeEffectTarget(e)
		and Duel.IsExistingMatchingCard(c100211052.thfilter,tp,LOCATION_GRAVE,0,1,c,e) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c100211052.thfilter,tp,LOCATION_GRAVE,0,1,1,c,e)
	Duel.SetTargetCard(g+c)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,2,tp,0)
end
function c100211052.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	if #tg>0 then
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
	end
	local c=e:GetHandler()
	--Banish any card sent to your GY
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	e1:SetTargetRange(0xff,0)
	e1:SetTarget(c100211052.rmtg)
	e1:SetValue(LOCATION_REMOVED)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c100211052.rmtg(e,c)
	local tp=e:GetHandlerPlayer()
	return c:GetOwner()==tp and Duel.IsPlayerCanRemove(tp,c)
end