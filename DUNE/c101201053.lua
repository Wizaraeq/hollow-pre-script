--ジュラシック・パワー
function c101201053.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Increase the ATK of Dinosaur monsters you control by 300
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_DINOSAUR))
	e2:SetValue(300)
	c:RegisterEffect(e2)
	--Level 5 or higher Dinosaur monsters can be summoned without Tributing
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(101201053,0))
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SUMMON_PROC)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_HAND,0)
	e3:SetCondition(c101201053.ntcon)
	e3:SetTarget(c101201053.nttg)
	c:RegisterEffect(e3)
	--Search 1 Dionosaur monster with 1200 DEF
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(101201053,1))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1,101201053)
	e4:SetCost(c101201053.thcost)
	e4:SetTarget(c101201053.thtg)
	e4:SetOperation(c101201053.thop)
	c:RegisterEffect(e4)
end
function c101201053.ntcon(e,c,minc)
	if c==nil then return true end
	return minc==0 and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function c101201053.nttg(e,c)
	return c:IsLevelAbove(5) and c:IsRace(RACE_DINOSAUR)
end
function c101201053.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=eg:GetFirst()
	if chk==0 then return eg:GetCount()==1 and tc:IsFaceup() and tc:IsLocation(LOCATION_MZONE)
		and tc:IsRace(RACE_DINOSAUR) and tc:IsLevelAbove(5) and tc:IsSummonType(SUMMON_TYPE_NORMAL)
		and not tc:IsReason(REASON_REPLACE) end
	if Duel.SelectEffectYesNo(tp,e:GetHandler(),96) then
		Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT)
		return true
	else return false end
end
function c101201053.cfilter(c)
	return c:IsRace(RACE_DINOSAUR) and c:IsAbleToGraveAsCost() and (c:IsFaceup() or c:IsLocation(LOCATION_HAND))
end
function c101201053.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101201053.cfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c101201053.cfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c101201053.thfilter(c)
	return c:IsRace(RACE_DINOSAUR) and c:IsDefense(1200) and c:IsAbleToHand()
end
function c101201053.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101201053.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c101201053.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c101201053.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end