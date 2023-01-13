--開かれし大地
function c101112054.initial_effect(c)
	aux.AddCodeList(c,68468459)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Activate 1 effect if the opponent Special Summons a monster
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101112054,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCondition(c101112054.condition)
	e2:SetTarget(c101112054.target)
	e2:SetOperation(c101112054.operation)
	c:RegisterEffect(e2)
end
function c101112054.cfilter(c,tp)
	return c:IsSummonPlayer(1-tp) and c:IsType(TYPE_RITUAL+TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK) and c:IsFaceup()
end
function c101112054.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c101112054.cfilter,1,nil,tp)
end
function c101112054.thfilter(c)
	return c:IsCode(68468459) or (c:IsType(TYPE_MONSTER) and aux.IsCodeListed(c,68468459)) and c:IsAbleToHand()
end
function c101112054.spfilter(c,e,tp)
	return c:IsCode(68468459) or (c:IsType(TYPE_MONSTER) and aux.IsCodeListed(c,68468459)) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101112054.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.GetFlagEffect(tp,101112054)==0 and Duel.IsExistingMatchingCard(c101112054.thfilter,tp,LOCATION_DECK,0,1,nil)
	local b2=Duel.GetFlagEffect(tp,101112054+100)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c101112054.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp)
	if chk==0 then return b1 or b2 end
	local op=0
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(101112054,0),aux.Stringid(101112054,1))
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(101112054,0))
	else
		op=Duel.SelectOption(tp,aux.Stringid(101112054,1))+1
	end
	if op==0 then
		Duel.RegisterFlagEffect(tp,101112054,RESET_PHASE+PHASE_END,0,1)
		e:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	else
		Duel.RegisterFlagEffect(tp,101112054+100,RESET_PHASE+PHASE_END,0,1)
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
	end
	e:SetLabel(op)
end
function c101112054.operation(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c101112054.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if #g>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	else
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c101112054.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
		if #g>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
