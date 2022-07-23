--The Most Distant, Deepest Depths
function c101109090.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Prevent destruction by effects
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_CANNOT_REMOVE)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCondition(c101109090.ptcon)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--Search "Ghoti"
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(101109090,0))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCountLimit(1,101109090)
	e4:SetCost(c101109090.thcost)
	e4:SetTarget(c101109090.thtg)
	e4:SetOperation(c101109090.thop)
	c:RegisterEffect(e4)
	--Return to hand
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(101109090,1))
	e5:SetCategory(CATEGORY_TOHAND+CATEGORY_REMOVE)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_SUMMON_SUCCESS)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetRange(LOCATION_GRAVE)
	e5:SetCountLimit(1,101109090+100)
	e5:SetCondition(c101109090.rtcon)
	e5:SetTarget(c101109090.rttg)
	e5:SetOperation(c101109090.rtop)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e6)	
end
function c101109090.filter(c)
	return c:IsFaceup() and c:IsRace(RACE_FISH) and c:IsType(TYPE_SYNCHRO)
end
function c101109090.ptcon(e)
	return Duel.IsExistingMatchingCard(c101109090.filter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c101109090.cfilter(c)
	return c:IsRace(RACE_FISH) and c:IsAbleToRemoveAsCost()
end
function c101109090.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101109090.cfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c101109090.cfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c101109090.thfilter(c)
	return c:IsSetCard(0x28b) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c101109090.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101109090.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c101109090.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c101109090.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c101109090.rdcfilter(c,p)
	return c:IsFaceup() and c:IsRace(RACE_FISH) and c:IsControler(p)
end
function c101109090.rtcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c101109090.rdcfilter,1,nil,tp)
end
function c101109090.rmfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_FISH) and c:IsAbleToRemove()
end
function c101109090.rttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c101109090.rmfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101109090.rmfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c101109090.rmfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c101109090.rtop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)~=0 and c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,c)
	end
end