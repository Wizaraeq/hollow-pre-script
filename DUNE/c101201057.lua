--大聖剣博物館
function c101201057.initial_effect(c)
	aux.AddCodeList(c,77656797)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--FIRE Warrior monsters you control gain 500 ATK
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c101201057.atktg)
	e2:SetValue(500)
	c:RegisterEffect(e2)
	--Add 1 "Noble Arms" card from your Deck to your hand, except " The Great Noble Arms Museum"
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(101201057,0))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1)
	e3:SetCost(c101201057.thcost)
	e3:SetTarget(c101201057.thtg)
	e3:SetOperation(c101201057.thop)
	c:RegisterEffect(e3)
	--Special Summon 1 "Noble Knight" monster from your Spell & Trap Zone
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(101201057,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(c101201057.spcon)
	e4:SetTarget(c101201057.sptg)
	e4:SetOperation(c101201057.spop)
	c:RegisterEffect(e4)
end
function c101201057.atktg(e,c)
	return c:IsAttribute(ATTRIBUTE_FIRE) and c:IsRace(RACE_WARRIOR)
end
function c101201057.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1200) end
	Duel.PayLPCost(tp,1200)
end
function c101201057.thfilter(c)
	return c:IsSetCard(0x207a) and not c:IsCode(101201057) and c:IsAbleToHand()
end
function c101201057.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101201057.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c101201057.thop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(101201057,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,nil,aux.Stringid(101201057,2))
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c101201057.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c101201057.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(101201057)>0
end
function c101201057.spfilter(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0x107a) and c:GetSequence()<5
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101201057.lcfilter(c)
	return c:IsFaceup() and c:IsCode(77656797)
end
function c101201057.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_SZONE) and c101201057.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c101201057.spfilter,tp,LOCATION_SZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c101201057.spfilter,tp,LOCATION_SZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
	if not Duel.IsExistingMatchingCard(c101201057.lcfilter,tp,LOCATION_ONFIELD,0,1,nil) then
		e:SetLabel(1)
	else
		e:SetLabel(0)
	end
end
function c101201057.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
	if e:GetLabel()==1 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,0)
		e1:SetTarget(c101201057.splimit)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
function c101201057.splimit(e,c)
	return not c:IsRace(RACE_WARRIOR)
end