--ＶＳ パンテラ
function c100420017.initial_effect(c)
	--Special Summon this card
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100420017,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,100420017)
	e1:SetCondition(c100420017.spcon)
	e1:SetCost(c100420017.opccost)
	e1:SetTarget(c100420017.sptg)
	e1:SetOperation(c100420017.spop)
	c:RegisterEffect(e1)
	--Make this card indestructible by attacks, OR destroy all Spell/Traps in this card's column
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100420017,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMING_MAIN_END+TIMINGS_CHECK_MONSTER)
	e2:SetCountLimit(1,100420017+100)
	e2:SetCost(c100420017.opccost)
	e2:SetTarget(c100420017.vstg)
	e2:SetOperation(c100420017.vsop)
	c:RegisterEffect(e2)
end
function c100420017.cfilter(c)
	return c:GetSequence()<5
end
function c100420017.spcon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c100420017.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c100420017.opccost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,100420017)==0 end
	Duel.RegisterFlagEffect(tp,100420017,RESET_CHAIN,0,1)
end
function c100420017.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c100420017.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c100420017.vscostfilter(c,att)
	return c:IsAttribute(att) and not c:IsPublic()
end
function c100420017.vsrescon(sg)
	return sg:FilterCount(Card.IsAttribute,nil,ATTRIBUTE_EARTH)>0
		and sg:FilterCount(Card.IsAttribute,nil,ATTRIBUTE_FIRE)>0
end
function c100420017.desfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c100420017.vstg(e,tp,eg,ep,ev,re,r,rp,chk)
	local cg1=Duel.GetMatchingGroup(c100420017.vscostfilter,tp,LOCATION_HAND,0,nil,ATTRIBUTE_EARTH)
	local b1=#cg1>0
	local cg2=cg1+Duel.GetMatchingGroup(c100420017.vscostfilter,tp,LOCATION_HAND,0,nil,ATTRIBUTE_FIRE)
	local colg=e:GetHandler():GetColumnGroup():Filter(c100420017.desfilter,nil)
	local b2=#colg>0 and cg2:CheckSubGroup(c100420017.vsrescon,2,2)
	if chk==0 then return b1 or b2 end
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(100420017,2),aux.Stringid(100420017,3))
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(100420017,2))
	else
		op=Duel.SelectOption(tp,aux.Stringid(100420017,3))+1
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
		local g=cg2:SelectSubGroup(tp,c100420017.vsrescon,false,2,2)
		Duel.ConfirmCards(1-tp,g)
		Duel.ShuffleHand(tp)
		e:SetCategory(CATEGORY_DESTROY)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,colg,#colg,0,0)
	end
end
function c100420017.vsop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local op=e:GetLabel()
	if op==0 and c:IsFaceup() then
		--Cannot be destroyed by card effects
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	elseif op==1 then
		local cg=c:GetColumnGroup():Filter(c100420017.desfilter,nil)
		if #cg==0 then return end
		Duel.Destroy(cg,REASON_EFFECT)
	end
end