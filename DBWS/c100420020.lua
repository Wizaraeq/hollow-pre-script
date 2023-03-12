--ＶＳ プルトンＨＧ
function c100420020.initial_effect(c)
	--Special Summon this card
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100420020,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetHintTiming(0,TIMING_MAIN_END+TIMINGS_CHECK_MONSTER)
	e1:SetCountLimit(1,100420020)
	e1:SetCondition(c100420020.spcon)
	e1:SetCost(c100420020.opccost)
	e1:SetTarget(c100420020.sptg)
	e1:SetOperation(c100420020.spop)
	c:RegisterEffect(e1)
	--Gain 3000 DEF, OR Gain 3000 ATK
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100420020,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(TIMING_DAMAGE_STEP,TIMING_MAIN_END+TIMING_DAMAGE_STEP)
	e2:SetCountLimit(1,100420020+100)
	e2:SetCondition(c100420020.vscon)
	e2:SetCost(c100420020.opccost)
	e2:SetTarget(c100420020.vstg)
	e2:SetOperation(c100420020.vsop)
	c:RegisterEffect(e2)
end
function c100420020.opccost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,100420020)==0 end
	Duel.RegisterFlagEffect(tp,100420020,RESET_CHAIN,0,1)
end
function c100420020.spconfilter(c,tp)
	return (c:IsFacedown() or not c:IsSetCard(0x297)) and c:GetSequence()<5
end
function c100420020.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==1-tp and not Duel.IsExistingMatchingCard(c100420020.spconfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c100420020.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c100420020.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c100420020.vscon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()~=PHASE_DAMAGE or not Duel.IsDamageCalculated()
end
function c100420020.vscostfilter(c,att)
	return c:IsAttribute(att) and not c:IsPublic()
end
function c100420020.vsrescon(sg)
	return sg:FilterCount(Card.IsAttribute,nil,ATTRIBUTE_DARK)>0
		and sg:FilterCount(Card.IsAttribute,nil,ATTRIBUTE_EARTH)>0
end
function c100420020.vstg(e,tp,eg,ep,ev,re,r,rp,chk)
	local cg1=Duel.GetMatchingGroup(c100420020.vscostfilter,tp,LOCATION_HAND,0,nil,ATTRIBUTE_FIRE)
	local b1=#cg1>0
	local cg2=Duel.GetMatchingGroup(c100420020.vscostfilter,tp,LOCATION_HAND,0,nil,ATTRIBUTE_DARK+ATTRIBUTE_EARTH)
	local b2=cg2:CheckSubGroup(c100420020.vsrescon,2,2)
	if chk==0 then return b1 or b2 end
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(100420020,2),aux.Stringid(100420020,3))
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(100420020,2))
	else
		op=Duel.SelectOption(tp,aux.Stringid(100420020,3))+1
	end
	e:SetLabel(op)
	if op==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local g=cg1:Select(tp,1,1,nil)
		Duel.ConfirmCards(1-tp,g)
		Duel.ShuffleHand(tp)
		e:SetCategory(CATEGORY_DEFCHANGE)
	elseif op==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local g=cg2:SelectSubGroup(tp,c100420020.vsrescon,false,2,2)
		Duel.ConfirmCards(1-tp,g)
		Duel.ShuffleHand(tp)
		e:SetCategory(CATEGORY_ATKCHANGE)
	end
end
function c100420020.vsop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	local op=e:GetLabel()
	if op==0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_DEFENSE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END)
		e1:SetValue(3000)
		c:RegisterEffect(e1)
	elseif op==1 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END)
		e1:SetValue(3000)
		c:RegisterEffect(e1)
	end
end
