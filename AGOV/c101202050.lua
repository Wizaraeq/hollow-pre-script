--ＴＧ－オールクリア
function c101202050.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--"T.G." monsters on the field become Machine monsters
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CHANGE_RACE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x27))
	e2:SetValue(RACE_MACHINE)
	c:RegisterEffect(e2)
	--Additional "T.G." Normal Summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(101202050,0))
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x27))
	c:RegisterEffect(e3)
	--Destroy 1 "T.G." monster and add 1 "T.G." monster with a different name to your hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101202050,1))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,101202050)
	e2:SetTarget(c101202050.destg)
	e2:SetOperation(c101202050.desop)
	c:RegisterEffect(e2)
end
function c101202050.desfilter(c,p)
	return c:IsSetCard(0x27) and c:IsType(TYPE_MONSTER) and (c:IsFaceup() or c:IsLocation(LOCATION_HAND))
		and Duel.IsExistingMatchingCard(c101202050.thfilter,p,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,c:GetCode())
end
function c101202050.thfilter(c,code)
	return c:IsSetCard(0x27) and c:IsType(TYPE_MONSTER) and not c:IsCode(code) and c:IsAbleToHand()
end
function c101202050.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101202050.desfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,1,nil,tp)end
	local g=Duel.GetMatchingGroup(c101202050.desfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,tp,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c101202050.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local tc=Duel.SelectMatchingCard(tp,c101202050.desfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,1,1,nil,tp):GetFirst()
	if not tc then return end
	local code=tc:GetCode()
	if Duel.Destroy(tc,REASON_EFFECT)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local thg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c101202050.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,code)
		if #thg>0 then
			Duel.SendtoHand(thg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,thg)
		end
	end
end