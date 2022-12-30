--ネムレリアの寝姫楼
function c101112059.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--Search 2 Level 10 Beast monsters with different names
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101112059,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1,101112059)
	e1:SetCost(c101112059.thcost)
	e1:SetTarget(c101112059.thtg)
	e1:SetOperation(c101112059.thop)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(101112059,ACTIVITY_SPSUMMON,c101112059.counterfilter)
	--prevent destruction
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTarget(c101112059.reptg)
	e2:SetValue(c101112059.repval)
	e2:SetOperation(c101112059.repop)
	c:RegisterEffect(e2)
end
function c101112059.counterfilter(c)
	return not c:IsSummonLocation(LOCATION_EXTRA) or c:IsType(TYPE_PENDULUM)
end
function c101112059.cfilter(c)
	return c:IsFacedown() and c:IsAbleToRemoveAsCost(POS_FACEDOWN)
end
function c101112059.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101112059.cfilter,tp,LOCATION_EXTRA,0,2,nil)
		and Duel.GetCustomActivityCount(101112059,tp,ACTIVITY_SPSUMMON)==0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c101112059.cfilter,tp,LOCATION_EXTRA,0,2,2,nil)
	Duel.Remove(g,POS_FACEDOWN,REASON_COST)
	--Cannot Special Summon from the Extra Deck, except Pendulum Monsters
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c101112059.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c101112059.splimit(e,c,sump,sumtype,sumpos,targetp)
	return c:IsLocation(LOCATION_EXTRA) and not c:IsType(TYPE_PENDULUM)
end
function c101112059.thfilter(c)
	return c:IsRace(RACE_BEAST) and c:IsLevel(10) and c:IsAbleToHand()
end
function c101112059.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g=Duel.GetMatchingGroup(c101112059.thfilter,tp,LOCATION_DECK,0,nil)
		return g:GetClassCount(Card.GetCode)>=2
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK)
end
function c101112059.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c101112059.thfilter,tp,LOCATION_DECK,0,nil)
	if #g<2 then return end
	local sg=g:SelectSubGroup(tp,aux.dncheck,false,2,2)
	if #sg>0 then
		Duel.SendtoHand(sg,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function c101112059.repfilter(c,tp)
	return c:IsFaceup() and c:IsLocation(LOCATION_MZONE) and c:IsControler(tp) and c:IsSetCard(0x292)
		and not c:IsReason(REASON_REPLACE) and (c:IsReason(REASON_BATTLE) or (c:IsReason(REASON_EFFECT) and c:GetReasonPlayer()==1-tp))
end
function c101112059.rmfilter(c,tp)
	return c:IsFacedown() and c:IsAbleToRemove(tp,POS_FACEDOWN,REASON_EFFECT+REASON_REPLACE)
end
function c101112059.filter(c)
	return c:IsFaceup() and c:IsCode(101112015)
end
function c101112059.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101112059.filter,tp,LOCATION_EXTRA,0,1,nil)
		and eg:IsExists(c101112059.repfilter,1,nil,tp)
		and Duel.IsExistingMatchingCard(c101112059.rmfilter,tp,LOCATION_EXTRA,0,1,nil,tp) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function c101112059.repval(e,c)
	return c101112059.repfilter(c,e:GetHandlerPlayer())
end
function c101112059.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c101112059.rmfilter,tp,LOCATION_EXTRA,0,1,1,nil,tp)
	Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT+REASON_REPLACE)
	Duel.Hint(HINT_CARD,0,101112059)
end