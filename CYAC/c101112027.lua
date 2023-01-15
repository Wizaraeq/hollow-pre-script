--幸魂
function c101112027.initial_effect(c)
	--spirit return
	aux.EnableSpiritReturn(c,EVENT_SUMMON_SUCCESS,EVENT_FLIP)
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1)
	--Normal Summon 1 Spirit monster from the hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101112027,0))
	e2:SetCategory(CATEGORY_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,101112027)
	e2:SetCost(c101112027.nscost)
	e2:SetTarget(c101112027.nstg)
	e2:SetOperation(c101112027.nsop)
	c:RegisterEffect(e2)
	--Add 1 Spirit monster from the GY to the hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(101112027,1))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_RELEASE)
	e3:SetCountLimit(1,101112027+100)
	e3:SetTarget(c101112027.thtg)
	e3:SetOperation(c101112027.thop)
	c:RegisterEffect(e3)
end
function c101112027.nscost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
	Duel.ConfirmCards(1-tp,e:GetHandler())
	Duel.ShuffleHand(tp)
end
function c101112027.sumfilter(c)
	return c:IsType(TYPE_SPIRIT) and c:IsSummonable(true,nil)
end
function c101112027.nstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101112027.sumfilter,tp,LOCATION_HAND,0,1,nil) end
	local g=Duel.GetMatchingGroup(c101112027.sumfilter,tp,LOCATION_HAND,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,g,1,0,0)
end
function c101112027.nsop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local tc=Duel.SelectMatchingCard(tp,c101112027.sumfilter,tp,LOCATION_HAND,0,1,1,nil):GetFirst()
	if tc then
		Duel.Summon(tp,tc,true,nil)
	end
end
function c101112027.thfilter(c)
	return c:IsType(TYPE_SPIRIT) and c:IsAbleToHand()
end
function c101112027.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c101112027.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101112027.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c101112027.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,tp,LOCATION_GRAVE)
end
function c101112027.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
