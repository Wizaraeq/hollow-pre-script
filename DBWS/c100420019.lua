--ＶＳ Ｄｒ.マッドラヴ
function c100420019.initial_effect(c)
	--Search 1 "Vanquish Soul" Spell/Trap
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100420019,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,100420019)
	e1:SetCost(c100420019.opccost)
	e1:SetTarget(c100420019.thtg)
	e1:SetOperation(c100420019.thop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--Reduce 1 opponent's monster's ATK/DEF, OR send 1 face-up monster on the field to the hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(100420019,1))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetHintTiming(TIMING_DAMAGE_STEP,TIMING_MAIN_END+TIMINGS_CHECK_MONSTER+TIMING_DAMAGE_STEP)
	e3:SetCountLimit(1,100420019+100)
	e3:SetCost(c100420019.opccost)
	e3:SetTarget(c100420019.vstg)
	e3:SetOperation(c100420019.vsop)
	c:RegisterEffect(e3)
end
function c100420019.opccost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,100420019)==0 end
	Duel.RegisterFlagEffect(tp,100420019,RESET_CHAIN,0,1)
end
function c100420019.thfilter(c)
	return c:IsSetCard(0x297) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c100420019.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100420019.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c100420019.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c100420019.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c100420019.vscostfilter(c,att)
	return c:IsAttribute(att) and not c:IsPublic()
end
function c100420019.vsrescon(sg)
	return sg:FilterCount(Card.IsAttribute,nil,ATTRIBUTE_DARK)>0
		and sg:FilterCount(Card.IsAttribute,nil,ATTRIBUTE_EARTH)>0
end
function c100420019.filter(c)
	return c:IsFaceup() and c:IsDefenseAbove(0)
end
function c100420019.vstg(e,tp,eg,ep,ev,re,r,rp,chk)
	local not_dmg_step=Duel.GetCurrentPhase()~=PHASE_DAMAGE
	local cg1=Duel.GetMatchingGroup(c100420019.vscostfilter,tp,LOCATION_HAND,0,nil,ATTRIBUTE_DARK)
	local fg1=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	local b1=#cg1>0 and #fg1>0 and (not_dmg_step or not Duel.IsDamageCalculated())
	local cg2=cg1+Duel.GetMatchingGroup(c100420019.vscostfilter,tp,LOCATION_HAND,0,nil,ATTRIBUTE_EARTH)
	local fg2=Duel.GetMatchingGroup(c100420019.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local b2=#fg2>0 and cg2:CheckSubGroup(c100420019.vsrescon,2,2) and not_dmg_step
	if chk==0 then return b1 or b2 end
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(100420019,2),aux.Stringid(100420019,3))
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(100420019,2))
	else
		op=Duel.SelectOption(tp,aux.Stringid(100420019,3))+1
	end
	e:SetLabel(op)
	if op==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local g=cg1:Select(tp,1,1,nil)
		Duel.ConfirmCards(1-tp,g)
		Duel.ShuffleHand(tp)
		e:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	elseif op==1 then
		local g=cg2:SelectSubGroup(tp,c100420019.vsrescon,false,2,2)
		Duel.ConfirmCards(1-tp,g)
		Duel.ShuffleHand(tp)
		e:SetCategory(CATEGORY_TOHAND)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_MZONE)
	end
end
function c100420019.vsop(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	local c=e:GetHandler()
	if op==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATKDEF)
		local g=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
		if not g:GetFirst() then return end
		Duel.HintSelection(g)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(-500)
		g:GetFirst():RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		g:GetFirst():RegisterEffect(e2)
	elseif op==1 then
		local g2=Duel.GetMatchingGroup(c100420019.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil):GetMinGroup(Card.GetDefense)
		if #g2==0 then return end
		if #g2>1 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
			g2=g2:FilterSelect(tp,Card.IsAbleToHand,1,1,nil)
		end
		if #g2==0 then return end
		Duel.HintSelection(g2,true)
		Duel.SendtoHand(g2,nil,REASON_EFFECT)
	end
end