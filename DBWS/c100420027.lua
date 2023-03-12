--ＶＳ 龍帝ノ槍
function c100420027.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100420027,0))
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,100420027+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c100420027.condition)
	e1:SetTarget(c100420027.target)
	e1:SetOperation(c100420027.activate)
	c:RegisterEffect(e1)
end
function c100420027.filter(c,p)
	return c:IsOnField() and c:IsControler(p)
end
function c100420027.ffilter(c)
	return c:IsFaceup() and c:IsSetCard(0x297)
end
function c100420027.condition(e,tp,eg,ep,ev,re,r,rp)
	if rp==tp or not Duel.IsExistingMatchingCard(c100420027.ffilter,tp,LOCATION_MZONE,0,1,nil) then return false end
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return tg:IsExists(c100420027.filter,1,nil,tp) and Duel.IsChainNegatable(ev)
		and (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE))
end
function c100420027.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	local rc=re:GetHandler()
	if rc:IsDestructable() and rc:IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c100420027.damfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x297) and c:GetAttack()>0
end
function c100420027.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) and Duel.Destroy(eg,REASON_EFFECT)>0 then
		local g=Duel.GetMatchingGroup(c100420027.damfilter,tp,LOCATION_MZONE,0,nil)
		if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(100420027,1)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
			local sg=g:Select(tp,1,1,nil)
			local tc=sg:GetFirst()
			Duel.HintSelection(sg)
			local dam=tc:GetAttack()
			Duel.BreakEffect()
			Duel.Damage(1-tp,dam,REASON_EFFECT)
		end
	end
end
