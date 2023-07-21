--Demigod of the Tistina
function c101201088.initial_effect(c)
	--Special Summon this card
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101201088,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,101201088)
	e1:SetCondition(c101201088.spcon)
	e1:SetTarget(c101201088.sptg)
	e1:SetOperation(c101201088.spop)
	c:RegisterEffect(e1)
	--Flip opponent's monsters face-down
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101201088,1))
	e2:SetCategory(CATEGORY_POSITION+CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e2:SetCountLimit(1,101201088+100)
	e2:SetCondition(c101201088.poscon)
	e2:SetTarget(c101201088.postg)
	e2:SetOperation(c101201088.posop)
	c:RegisterEffect(e2)
end
function c101201088.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x2a2)
end
function c101201088.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c101201088.filter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c101201088.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c101201088.thfilter(c)
	return c:IsSetCard(0x2a2) and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c101201088.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0
		and Duel.IsExistingMatchingCard(c101201088.thfilter,tp,LOCATION_DECK,0,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(101201088,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c101201088.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if #g==0 then return end
		Duel.BreakEffect()
		Duel.SendtoHand(g,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c101201088.poscfilter(c)
	return c:IsFaceup() and c:IsCode(101201089)
end
function c101201088.poscon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==1-tp
		and Duel.IsExistingMatchingCard(c101201088.poscfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c101201088.postg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsCanTurnSet,tp,0,LOCATION_MZONE,nil)
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,#g,0,0)
end
function c101201088.posop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsCanTurnSet,tp,0,LOCATION_MZONE,nil)
	if #g==0 or Duel.ChangePosition(g,POS_FACEDOWN_DEFENSE)==0 then return end
	local gg=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_ONFIELD,nil)
	if #gg>0 and Duel.SelectYesNo(tp,aux.Stringid(101201088,3)) then
		Duel.BreakEffect()
		Duel.SendtoGrave(gg,REASON_EFFECT)
	end
end