--潜伏するＧ
function c101111030.initial_effect(c)
	--Special Summon itself from hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101111030,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,101111030)
	e1:SetCondition(c101111030.spcon)
	e1:SetTarget(c101111030.sptg)
	e1:SetOperation(c101111030.spop)
	c:RegisterEffect(e1)
	--Destroy all Special Summoned monsters on the field
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101111030,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_FLIP)
	e2:SetCondition(c101111030.descon)
	e2:SetTarget(c101111030.destg)
	e2:SetOperation(c101111030.desop)
	c:RegisterEffect(e2)
end
function c101111030.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsSummonPlayer,1,nil,1-tp)
end
function c101111030.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,tp,0)
end
function c101111030.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)>0 then
		Duel.ConfirmCards(1-tp,c)
		c:RegisterFlagEffect(101111030,RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(101111030,2))
		--Flip itself face-up during the End Phase
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetLabelObject(c)
		e1:SetCountLimit(1)
		e1:SetCondition(c101111030.flipcon)
		e1:SetOperation(c101111030.flipop)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
function c101111030.flipcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return tc:IsFacedown() and tc:GetFlagEffect(101111030)>0
end
function c101111030.flipop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.ChangePosition(tc,POS_FACEUP_DEFENSE)
end
function c101111030.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_END
end
function c101111030.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(Card.IsSummonType,tp,LOCATION_MZONE,LOCATION_MZONE,nil,SUMMON_TYPE_SPECIAL)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
end
function c101111030.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsSummonType,tp,LOCATION_MZONE,LOCATION_MZONE,nil,SUMMON_TYPE_SPECIAL)
	if #g>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end