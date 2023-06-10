--世壊賛歌
function c101202053.initial_effect(c)
	aux.AddCodeList(c,56099748)
	--Destroy 1 monster you control and negate the effects of 1 of your opponent's monster
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101202053,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetCountLimit(1,101202053)
	e1:SetTarget(c101202053.negttg)
	e1:SetOperation(c101202053.negtop)
	c:RegisterEffect(e1)
	--Destroy 1 card you control
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101202053,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,101202053+100)
	e2:SetCost(aux.bfgcost)
	e2:SetCondition(c101202053.descond)
	e2:SetTarget(c101202053.destg)
	e2:SetOperation(c101202053.desop)
	c:RegisterEffect(e2)
end
function c101202053.cfilter(c,e,tp)
	return (c:IsControler(tp)) or (c:IsControler(1-tp) and not c:IsDisabled() and c:IsType(TYPE_EFFECT))
		and c:IsFaceup() and c:IsCanBeEffectTarget(e)
end
function c101202053.rescon(sg,e,tp)
	return sg:FilterCount(Card.IsControler,nil,tp)==1
end
function c101202053.negttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local rg=Duel.GetMatchingGroup(c101202053.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,e,tp)
	if chk==0 then return rg:CheckSubGroup(c101202053.rescon,2,2,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local tg=rg:SelectSubGroup(tp,c101202053.rescon,false,2,2,e,tp)
	Duel.SetTargetCard(tg)
	local dg=tg:Filter(Card.IsControler,nil,tp)
	e:SetLabelObject(dg:GetFirst())
	local ng=tg:Filter(Card.IsControler,nil,1-tp)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,dg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,ng,1,0,0)
end
function c101202053.actcfilter(c)
	return c:IsFaceup() and c:IsCode(56099748)
end
function c101202053.negtop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if #g==0 then return end
	local dc=g:GetFirst()
	local negc=g:GetNext()
	if negc==e:GetLabelObject() then dc,negc=negc,dc end
	if dc:IsControler(tp) and Duel.Destroy(dc,REASON_EFFECT)>0 and negc and negc:IsControler(1-tp) and negc:IsCanBeDisabledByEffect(e,false) then
		Duel.NegateRelatedChain(negc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		negc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		negc:RegisterEffect(e2)
		if negc:IsType(TYPE_TRAPMONSTER) then
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			negc:RegisterEffect(e3)
		end
		if Duel.IsExistingMatchingCard(c101202053.actcfilter,tp,LOCATION_ONFIELD,0,1,nil)
			and Duel.SelectYesNo(tp,aux.Stringid(101202053,2)) then
			Duel.BreakEffect()
			Duel.Destroy(negc,REASON_EFFECT)
		end
	end
end
function c101202053.vedafilter(c)
	return c:IsFaceup() and c:IsSetCard(0x29a) and c:GetOriginalType()&TYPE_MONSTER~=0
end
function c101202053.descond(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c101202053.vedafilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
end
function c101202053.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_MZONE,0,nil)
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c101202053.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_MZONE,0,1,1,nil)
	if #g>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end