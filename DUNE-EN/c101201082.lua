--Finis Terrae, Tower of the Necroworld
function c101201082.initial_effect(c)
	--Special Summon it from the hand if you control a Level 10 monster
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101201082,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,101201082+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c101201082.spcon)
	c:RegisterEffect(e1)
	--Make 1 face-up card unable to de destroyed by effects
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101201082,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,101201082+100)
	e2:SetTarget(c101201082.indestg)
	e2:SetOperation(c101201082.indesop)
	c:RegisterEffect(e2)
end
function c101201082.spfilter(c)
	return c:IsFaceup() and c:IsLevel(10)
end
function c101201082.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c101201082.spfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c101201082.indestg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
end
function c101201082.indesop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		--Cannot be destroyed by card effects
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end