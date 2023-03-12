--ＶＳ ラゼン
function c100420016.initial_effect(c)
	--Search 1 non-Warrior "Vanquish Soul" monster
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100420016,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,100420016)
	e1:SetCost(c100420016.opccost)
	e1:SetTarget(c100420016.thtg)
	e1:SetOperation(c100420016.thop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--Make this card indestructible by effects, OR destroy all monsters in this card's column
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(100420016,1))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetHintTiming(0,TIMING_MAIN_END+TIMINGS_CHECK_MONSTER)
	e3:SetCountLimit(1,100420016+100)
	e3:SetCost(c100420016.opccost)
	e3:SetTarget(c100420016.vstg)
	e3:SetOperation(c100420016.vsop)
	c:RegisterEffect(e3)
end
function c100420016.opccost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,100420016)==0 end
	Duel.RegisterFlagEffect(tp,100420016,RESET_CHAIN,0,1)
end
function c100420016.thfilter(c)
	return c:IsSetCard(0x297) and c:IsType(TYPE_MONSTER) and not c:IsRace(RACE_WARRIOR) and c:IsAbleToHand()
end
function c100420016.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100420016.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c100420016.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c100420016.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c100420016.vscostfilter(c,att)
	return c:IsAttribute(att) and not c:IsPublic()
end
function c100420016.vsrescon(sg)
	return sg:FilterCount(Card.IsAttribute,nil,ATTRIBUTE_FIRE)>0
		and sg:FilterCount(Card.IsAttribute,nil,ATTRIBUTE_DARK)>0
end
function c100420016.vstg(e,tp,eg,ep,ev,re,r,rp,chk)
	local cg1=Duel.GetMatchingGroup(c100420016.vscostfilter,tp,LOCATION_HAND,0,nil,ATTRIBUTE_FIRE)
	local b1=#cg1>0
	local cg2=cg1+Duel.GetMatchingGroup(c100420016.vscostfilter,tp,LOCATION_HAND,0,nil,ATTRIBUTE_DARK)
	local colg=e:GetHandler():GetColumnGroup():Filter(Card.IsLocation,nil,LOCATION_MZONE)
	local b2=#colg>0 and cg2:CheckSubGroup(c100420016.vsrescon,2,2)
	if chk==0 then return b1 or b2 end
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(100420016,2),aux.Stringid(100420016,3))
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(100420016,2))
	else
		op=Duel.SelectOption(tp,aux.Stringid(100420016,3))+1
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
		local g=cg2:SelectSubGroup(tp,c100420016.vsrescon,false,2,2)
		Duel.ConfirmCards(1-tp,g)
		Duel.ShuffleHand(tp)
		e:SetCategory(CATEGORY_DESTROY)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,colg,#colg,0,0)
	end
end
function c100420016.vsop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local op=e:GetLabel()
	if op==0 and c:IsFaceup() then
		--Cannot be destroyed by card effects
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	elseif op==1 then
		local cg=c:GetColumnGroup():Filter(Card.IsLocation,nil,LOCATION_MZONE)
		if #cg==0 then return end
		Duel.Destroy(cg,REASON_EFFECT)
	end
end