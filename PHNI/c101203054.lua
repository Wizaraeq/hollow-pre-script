--ナイトメア・ペイン
function c101203054.initial_effect(c)
	aux.AddCodeList(c,78371393)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--Search 1 "Yubel" or 1 card that mentions it
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101203054,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1,101203054)
	e1:SetTarget(c101203054.destg)
	e1:SetOperation(c101203054.desop)
	c:RegisterEffect(e1)
	--Opponent's monsters must attack a "Yubel" monster
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_MUST_ATTACK)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetCondition(c101203054.atkcon)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_MUST_ATTACK_MONSTER)
	e3:SetValue(aux.TargetBoolFunction(Card.IsSetCard,0x2a4))
	c:RegisterEffect(e3)
	--Your opponent takes any battle damage you would have taken from battles involving your "Yubel" monsters instead
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_REFLECT_BATTLE_DAMAGE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x2a4))
	e4:SetValue(1)
	c:RegisterEffect(e4)
end
function c101203054.desfilter(c)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsFaceupEx()
end
function c101203054.thfilter(c)
	return (c:IsCode(78371393) or aux.IsCodeListed(c,78371393)) and c:IsAbleToHand() and not c:IsCode(101203054)
end
function c101203054.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101203054.desfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(c101203054.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_HAND+LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c101203054.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,c101203054.desfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
	if #g>0 and Duel.Destroy(g,REASON_EFFECT)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=Duel.SelectMatchingCard(tp,c101203054.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if #sg>0 then
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		end
	end
end
function c101203054.cfilter(c)
	return c:IsFaceup() or c:IsSetCard(0x2a4)
end
function c101203054.atkcon(e)
	return Duel.IsExistingMatchingCard(c101203054.cfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end