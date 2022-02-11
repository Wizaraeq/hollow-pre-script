--神碑の誑かし
function c100418028.initial_effect(c)
	c:SetUniqueOnField(1,0,100418028)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Banish the top card of your opponent's Deck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100418028,0))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_CHAIN_SOLVED)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c100418028.rmcon)
	e2:SetTarget(c100418028.rmtg)
	e2:SetOperation(c100418028.rmop)
	c:RegisterEffect(e2)
end
function c100418028.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_SPELL) and re:GetHandler():IsType(TYPE_QUICKPLAY) and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c100418028.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_DECK)
end
function c100418028.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetDecktopGroup(1-tp,1)
	if #g==0 then return end
	Duel.DisableShuffleCheck()
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
end