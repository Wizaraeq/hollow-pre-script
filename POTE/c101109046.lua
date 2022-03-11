--Ｐ.Ｕ.Ｎ.Ｋ.ＪＡＭドラゴン・ドライブ
function c101109046.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_PSYCHO),aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,101109046)
	e1:SetCondition(c101109046.condition)
	e1:SetCost(c101109046.cost)
	e1:SetTarget(c101109046.target)
	e1:SetOperation(c101109046.operation)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101109046,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,101109046+100)
	e2:SetCondition(c101109046.spcon)
	e2:SetTarget(c101109046.sptg)
	e2:SetOperation(c101109046.spop)
	c:RegisterEffect(e2)
end
function c101109046.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO) or 
		(re and re:GetHandler():IsSetCard(0x171))
end
function c101109046.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,600) end
	Duel.PayLPCost(tp,600)
end
function c101109046.filter(c)
	return c:IsRace(RACE_PSYCHO) and c:IsLevel(3) and (c:IsAbleToHand() or c:IsAbleToGrave())
end
function c101109046.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101109046.filter,tp,LOCATION_DECK,0,1,nil) end
end
function c101109046.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,c101109046.filter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc and tc:IsAbleToHand() and (not tc:IsAbleToGrave() or Duel.SelectOption(tp,1190,1191)==0) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	else
		Duel.SendtoGrave(tc,REASON_EFFECT)
	end
end
function c101109046.spcon(e,tp,eg,ep,ev,re,r,rp)
	local ch=Duel.GetCurrentChain(true)-1
	if ch<=0 then return false end
	local cplayer=Duel.GetChainInfo(ch,CHAININFO_TRIGGERING_CONTROLER)
	local ceff=Duel.GetChainInfo(ch,CHAININFO_TRIGGERING_EFFECT)
	return ep==1-tp and cplayer==tp and ceff:GetHandler():IsSetCard(0x171)
end
function c101109046.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c101109046.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end