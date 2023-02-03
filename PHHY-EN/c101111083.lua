--Diabolantis the Menacing Mantis
function c101111083.initial_effect(c)
	--Synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--Send Insect/Plant monsters from your Deck to the GY
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101111083,0))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,101111083)
	e1:SetCondition(c101111083.syncon)
	e1:SetTarget(c101111083.gytg)
	e1:SetOperation(c101111083.gyop)
	c:RegisterEffect(e1)
	--Treat 1 Insect/Plant monster you control as a Tuner
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101111083,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,101111083+100)
	e2:SetCondition(c101111083.syncon)
	e2:SetTarget(c101111083.tuntg)
	e2:SetOperation(c101111083.tunop)
	c:RegisterEffect(e2)
end
function c101111083.syncon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c101111083.gyfilter(c)
	return c:IsRace(RACE_INSECT+RACE_PLANT) and c:IsAbleToGrave()
end
function c101111083.gytg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=e:GetHandler():GetMaterialCount()-1
	if chk==0 then return ct>0 and Duel.IsExistingMatchingCard(c101111083.gyfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c101111083.gyop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetHandler():GetMaterialCount()-1
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c101111083.gyfilter,tp,LOCATION_DECK,0,1,ct,nil)
	if #g>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function c101111083.tunfilter(c)
	return c:IsFaceup() and not c:IsType(TYPE_TUNER) and c:IsRace(RACE_INSECT+RACE_PLANT)
end
function c101111083.tuntg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c101111083.tunfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101111083.tunfilter,tp,LOCATION_MZONE,0,1,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c101111083.tunfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c101111083.tunop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and not tc:IsType(TYPE_TUNER) then
		--Treated as a Tuner
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_ADD_TYPE)
		e1:SetValue(TYPE_TUNER)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
