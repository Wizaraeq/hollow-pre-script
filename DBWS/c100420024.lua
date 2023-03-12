--ＶＳ 螺旋流辻風
function c100420024.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100420024,0))
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetCountLimit(1,100420024,EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c100420024.target)
	e1:SetOperation(c100420024.activate)
	c:RegisterEffect(e1)
end
function c100420024.tgfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x297) and c:IsCanChangePosition()
end
function c100420024.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c100420024.tgfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c100420024.tgfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g=Duel.SelectTarget(tp,c100420024.tgfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function c100420024.ctfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x297)
end
function c100420024.posfilter(c)
	return c:IsFaceup() and c:IsCanTurnSet()
end
function c100420024.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.ChangePosition(tc,POS_FACEUP_DEFENSE,POS_FACEDOWN_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)>0 then
		local ct=Duel.GetMatchingGroup(c100420024.ctfilter,tp,LOCATION_MZONE,0,nil):GetClassCount(Card.GetCode)
		local g=Duel.GetMatchingGroup(c100420024.posfilter,tp,0,LOCATION_MZONE,nil)
		if ct>0 and #g>0 and Duel.SelectYesNo(tp,aux.Stringid(100420024,1)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
			local fg=g:Select(tp,1,ct,nil)
			Duel.HintSelection(fg)
			Duel.BreakEffect()
			Duel.ChangePosition(fg,POS_FACEDOWN_DEFENSE)
		end
	end
end

