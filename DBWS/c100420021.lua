--ＶＳ 龍帝ヴァリウス
function c100420021.initial_effect(c)
	--Return 1 non-Dragon "Vanquish Soul" monster to the hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100420021,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetHintTiming(0,TIMING_MAIN_END+TIMINGS_CHECK_MONSTER)
	e1:SetCountLimit(1,100420021)
	e1:SetCondition(c100420021.spcon)
	e1:SetCost(c100420021.opccost)
	e1:SetTarget(c100420021.sptg)
	e1:SetOperation(c100420021.spop)
	c:RegisterEffect(e1)
	--Make this card unaffected by effects, OR destroy 1 other card on the field
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100420021,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMING_MAIN_END+TIMINGS_CHECK_MONSTER)
	e2:SetCountLimit(1,100420021+100)
	e2:SetCost(c100420021.opccost)
	e2:SetTarget(c100420021.vstg)
	e2:SetOperation(c100420021.vsop)
	c:RegisterEffect(e2)
end
function c100420021.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c100420021.opccost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,100420021)==0 end
	Duel.RegisterFlagEffect(tp,100420021,RESET_CHAIN,0,1)
end
function c100420021.thfilter(c,tp)
	return c:IsSetCard(0x297) and not c:IsRace(RACE_DRAGON) and c:IsFaceup()
		and c:IsAbleToHand() and Duel.GetMZoneCount(tp,c)>0
end
function c100420021.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c100420021.thfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c100420021.thfilter,tp,LOCATION_MZONE,0,1,nil,tp)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,c100420021.thfilter,tp,LOCATION_MZONE,0,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c100420021.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	if tc:IsRelateToEffect(e) and Duel.SendtoHand(tc,nil,REASON_EFFECT)>0
		and tc:IsLocation(LOCATION_HAND) and c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c100420021.vscostfilter(c,att)
	return c:IsAttribute(att) and not c:IsPublic()
end
function c100420021.vsrescon(sg)
	return sg:FilterCount(Card.IsAttribute,nil,ATTRIBUTE_EARTH)>0
		and sg:FilterCount(Card.IsAttribute,nil,ATTRIBUTE_DARK)>0
		and sg:FilterCount(Card.IsAttribute,nil,ATTRIBUTE_FIRE)>0
end
function c100420021.vstg(e,tp,eg,ep,ev,re,r,rp,chk)
	local cg1=Duel.GetMatchingGroup(c100420021.vscostfilter,tp,LOCATION_HAND,0,nil,ATTRIBUTE_EARTH)
	local b1=#cg1>0
	local cg2=cg1+Duel.GetMatchingGroup(c100420021.vscostfilter,tp,LOCATION_HAND,0,nil,ATTRIBUTE_DARK|ATTRIBUTE_FIRE)
	local dg=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
	local b2=#dg>0 and cg2:CheckSubGroup(c100420021.vsrescon,3,3)
	if chk==0 then return b1 or b2 end
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(100420021,2),aux.Stringid(100420021,3))
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(100420021,2))
	else
		op=Duel.SelectOption(tp,aux.Stringid(100420021,3))+1
	end
	e:SetLabel(op)
	if op==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local g=cg1:Select(tp,1,1,nil)
		Duel.ConfirmCards(1-tp,g)
		Duel.ShuffleHand(tp)
		e:SetCategory(0)
	elseif op==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local g=cg2:SelectSubGroup(tp,c100420021.vsrescon,false,3,3)
		Duel.ConfirmCards(1-tp,g)
		Duel.ShuffleHand(tp)
		e:SetCategory(CATEGORY_DESTROY)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,dg,1,0,0)
	end
end
function c100420021.vsop(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	local c=e:GetHandler()
	if op==0 then
		if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
		--Unaffected by opponent's activated effects
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetRange(LOCATION_MZONE)
		e1:SetValue(c100420021.efilter)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	elseif op==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,c)
		if #g==0 then return end
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
	end
end
function c100420021.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer() and re:IsActivated()
end