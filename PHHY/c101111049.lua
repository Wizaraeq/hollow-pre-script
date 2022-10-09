--魔界劇団－ハイパー・ディレクター
function c101111049.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,nil,2,2,c101111049.lcheck)
	-- Destroy 1 face-up card
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101111049,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetCountLimit(1,101111049)
	e1:SetCondition(c101111049.descon)
	e1:SetTarget(c101111049.destg)
	e1:SetOperation(c101111049.desop)
	c:RegisterEffect(e1)
end
function c101111049.lcheck(g,lc)
	return g:IsExists(Card.IsLinkRace,1,nil,RACE_FIEND)
end
function c101111049.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c101111049.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(tp) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c101111049.fldfilter(c)
	return c:IsCode(77297908) and c:IsType(TYPE_FIELD) and not c:IsForbidden()
end
function c101111049.pendfilter(c)
	return c:IsSetCard(0x10ec) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function c101111049.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or Duel.Destroy(tc,REASON_EFFECT)==0 then return end
	local g1=Duel.GetMatchingGroup(c101111049.fldfilter,tp,LOCATION_DECK,0,nil)
	local g2=Duel.GetMatchingGroup(c101111049.pendfilter,tp,LOCATION_DECK,0,nil)
	local b1=#g1>0
	local b2=#g2>0 and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1))
	if not ((b1 or b2) and Duel.SelectYesNo(tp,aux.Stringid(101111049,1))) then return end
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(101111049,2),aux.Stringid(101111049,3))
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(101111049,2))
	else
		op=Duel.SelectOption(tp,aux.Stringid(101111049,3))+1
	end
	if op==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local tc=Duel.SelectMatchingCard(tp,c101111049.fldfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
		if not tc then return end
		local fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
		if fc then
			Duel.SendtoGrave(fc,REASON_RULE)
		end
		Duel.BreakEffect()
		Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
	elseif op==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local tc=Duel.SelectMatchingCard(tp,c101111049.pendfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
		if not tc then return end
		Duel.BreakEffect()
		Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end