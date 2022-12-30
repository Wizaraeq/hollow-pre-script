--深淵の神獣ディス・パテル
function c101112041.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsRace,RACE_DRAGON),1)
	c:EnableReviveLimit()
	--Special summon 1 banished LIGHT or DARK monster
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101112041,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,101112041)
	e1:SetTarget(c101112041.sptg)
	e1:SetOperation(c101112041.spop)
	c:RegisterEffect(e1)
	--Destroy monster or negate an opponent's monster effect
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101112041,1))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,101112041+100)
	e2:SetCondition(c101112041.descon)
	e2:SetTarget(c101112041.destg)
	e2:SetOperation(c101112041.desop)
	c:RegisterEffect(e2)
end
function c101112041.spfilter(c,e,tp)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_DARK+ATTRIBUTE_LIGHT) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101112041.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and c101112041.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c101112041.spfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c101112041.spfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c101112041.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c101112041.descon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and rp==1-tp and re:IsActiveType(TYPE_MONSTER) 
end
function c101112041.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsAbleToDeck() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToDeck,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local tc=Duel.SelectTarget(tp,Card.IsAbleToDeck,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,1,nil):GetFirst()
	Duel.SetOperationInfo(0,CATEGORY_TODECK,tc,1,0,0)
	if tc:GetOwner()==tp and re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,tp,0)
	elseif tc:GetOwner()==1-tp then
		Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
	end
end
function c101112041.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not (tc:IsRelateToEffect(e) and Duel.SendtoDeck(tc,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)>0) then return end
	if tc:GetOwner()==tp and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	elseif tc:GetOwner()==1-tp then
		Duel.NegateEffect(ev)
	end
end