--ＶＳ ヘヴィ・ボーガー
function c100420018.initial_effect(c)
	--Return 1 non-Machine "Vanquish Soul" monster to the hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100420018,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetHintTiming(0,TIMING_MAIN_END+TIMINGS_CHECK_MONSTER)
	e1:SetCountLimit(1,100420018)
	e1:SetCondition(c100420018.spcon)
	e1:SetCost(c100420018.opccost)
	e1:SetTarget(c100420018.sptg)
	e1:SetOperation(c100420018.spop)
	c:RegisterEffect(e1)
	--Draw 1 card, OR inflict 1500 damage to the opponent
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100420018,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMING_MAIN_END)
	e2:SetCountLimit(1,100420018+100)
	e2:SetCost(c100420018.opccost)
	e2:SetTarget(c100420018.vstg)
	e2:SetOperation(c100420018.vsop)
	c:RegisterEffect(e2)
end
function c100420018.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c100420018.opccost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,100420018)==0 end
	Duel.RegisterFlagEffect(tp,100420018,RESET_CHAIN,0,1)
end
function c100420018.thfilter(c,tp)
	return c:IsSetCard(0x297) and not c:IsRace(RACE_MACHINE) and c:IsFaceup()
		and c:IsAbleToHand() and Duel.GetMZoneCount(tp,c)>0
end
function c100420018.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c100420018.thfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c100420018.thfilter,tp,LOCATION_MZONE,0,1,nil,tp)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,c100420018.thfilter,tp,LOCATION_MZONE,0,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c100420018.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	if tc:IsRelateToEffect(e) and Duel.SendtoHand(tc,nil,REASON_EFFECT)>0
		and tc:IsLocation(LOCATION_HAND) and c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c100420018.vscostfilter(c,att)
	return c:IsAttribute(att) and not c:IsPublic()
end
function c100420018.vsrescon(sg)
	return sg:FilterCount(Card.IsAttribute,nil,ATTRIBUTE_EARTH)>0
		and sg:FilterCount(Card.IsAttribute,nil,ATTRIBUTE_FIRE)>0
end
function c100420018.vstg(e,tp,eg,ep,ev,re,r,rp,chk)
	local cg1=Duel.GetMatchingGroup(c100420018.vscostfilter,tp,LOCATION_HAND,0,nil,ATTRIBUTE_DARK)
	local b1=#cg1>0 and Duel.IsPlayerCanDraw(tp,1)
	local cg2=Duel.GetMatchingGroup(c100420018.vscostfilter,tp,LOCATION_HAND,0,nil,ATTRIBUTE_EARTH+ATTRIBUTE_FIRE)
	local b2=cg2:CheckSubGroup(c100420018.vsrescon,2,2)
	if chk==0 then return b1 or b2 end
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(100420018,2),aux.Stringid(100420018,3))
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(100420018,2))
	else
		op=Duel.SelectOption(tp,aux.Stringid(100420018,3))+1
	end
	e:SetLabel(op)
	if op==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local g=cg1:Select(tp,1,1,nil)
		Duel.ConfirmCards(1-tp,g)
		Duel.ShuffleHand(tp)
		e:SetCategory(CATEGORY_DRAW)
		Duel.SetTargetPlayer(tp)
		Duel.SetTargetParam(1)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	elseif op==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local g=cg2:SelectSubGroup(tp,c100420018.vsrescon,false,2,2)
		Duel.ConfirmCards(1-tp,g)
		Duel.ShuffleHand(tp)
		e:SetCategory(CATEGORY_DAMAGE)
		Duel.SetTargetPlayer(1-tp)
		Duel.SetTargetParam(1500)
		Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1500)
	end
end
function c100420018.vsop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	local op=e:GetLabel()
	if op==0 then
		Duel.Draw(p,d,REASON_EFFECT)
	elseif op==1 then
		Duel.Damage(p,d,REASON_EFFECT)
	end
end