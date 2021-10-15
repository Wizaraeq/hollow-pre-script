--トップ・シェア
function c101107064.initial_effect(c)
	-- Place on top
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,101107064+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c101107064.pltg)
	e1:SetOperation(c101107064.plop)
	c:RegisterEffect(e1)
end
function c101107064.pltg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_DECK,0,1,nil) 
			and Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_DECK,1,nil) 
	end
end
function c101107064.plop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(101107064,0))
	local tc=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	if not tc then return end
	Duel.ShuffleDeck(tp)
	Duel.MoveSequence(tc,0)
	Duel.ConfirmDecktop(tp,1)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(101107064,0))
	tc=Duel.SelectMatchingCard(1-tp,aux.TRUE,1-tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	if not tc then return end
	Duel.BreakEffect()
	Duel.ShuffleDeck(1-tp)
	Duel.MoveSequence(tc,0)
	Duel.ConfirmDecktop(1-tp,1)
end 
