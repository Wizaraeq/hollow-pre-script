--八雷天神
--
--Script by Trishula9
function c100200210.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c100200210.spcon)
	e1:SetOperation(c100200210.spop)
	c:RegisterEffect(e1)
	--to deck
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_LEAVE_GRAVE+CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,100200210)
	e2:SetTarget(c100200210.tdtg)
	e2:SetOperation(c100200210.tdop)
	c:RegisterEffect(e2)
end
function c100200210.spfilter(c)
	return (c:IsLevel(8) or c:IsRank(8)) and c:IsAbleToRemoveAsCost()
end
function c100200210.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c100200210.spfilter,tp,LOCATION_GRAVE,0,1,nil)
end
function c100200210.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c100200210.spfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c100200210.tdfilter(c)
	return (c:IsLevel(8) or c:IsRank(8)) and (c:IsType(TYPE_SYNCHRO) or c:IsType(TYPE_FUSION) or c:IsType(TYPE_RITUAL) or c:IsType(TYPE_XYZ))
end
function c100200210.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and chkc:IsAbleToDeckAsCost() and c100200210.tdfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c100200210.tdfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c100200210.tdfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	local tc=g:GetFirst()
	if (tc:IsType(TYPE_RITUAL) or tc:IsType(TYPE_FUSION)) then
		Duel.SetOperationInfo(0,CATEGORY_TODECK,tc,1,0,0)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	else
		Duel.SetOperationInfo(0,CATEGORY_TODECK,tc,1,0,0)
		Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,c,1,0,1000)
	end
end
function c100200210.tdop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	if tc and tc:IsRelateToEffect(e) and (tc:IsType(TYPE_RITUAL) or tc:IsType(TYPE_FUSION)) and Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)>0 then
		Duel.Draw(tp,1,REASON_EFFECT)
	elseif tc and tc:IsRelateToEffect(e) and (tc:IsType(TYPE_SYNCHRO) or tc:IsType(TYPE_XYZ)) and Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)>0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(1000)
		c:RegisterEffect(e1)
	end
end 