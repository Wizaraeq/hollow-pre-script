--黒羽の旋風
function c101110052.initial_effect(c)
	aux.AddCodeList(c,9012916)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c101110052.spcon)
	e2:SetTarget(c101110052.sptg)
	e2:SetOperation(c101110052.spop)
	c:RegisterEffect(e2)
	--replace destruction
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c101110052.desreptg)
	e3:SetValue(c101110052.desrepval)
	e3:SetOperation(c101110052.desrepop)
	c:RegisterEffect(e3)
end
function c101110052.spcfilter(c,tp)
	return c:IsFaceup() and c:IsSummonPlayer(tp) and c:IsAttribute(ATTRIBUTE_DARK)
		and c:IsType(TYPE_SYNCHRO) and c:IsSummonLocation(LOCATION_EXTRA)
end
function c101110052.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c101110052.spcfilter,1,nil,tp)
end
function c101110052.spfilter(c,e,tp,atk)
	return (c:IsSetCard(0x33) or c:IsCode(9012916)) and c:IsAttackBelow(atk) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101110052.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local ag,atk=eg:Filter(c101110052.spcfilter,nil,tp):GetMaxGroup(Card.GetAttack)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c101110052.spfilter(chkc,e,tp,atk) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c101110052.spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp,atk) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c101110052.spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp,atk)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c101110052.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc and tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c101110052.repfilter(c,tp)
	return c:IsControler(tp) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsLocation(LOCATION_MZONE)
		and c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
end
function c101110052.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return eg:IsExists(c101110052.repfilter,1,nil,tp)
		and Duel.IsCanRemoveCounter(tp,1,0,0x10,1,REASON_EFFECT) end
	return Duel.SelectEffectYesNo(tp,c,96)
end
function c101110052.desrepval(e,c)
	return c101110052.repfilter(c,e:GetHandlerPlayer())
end
function c101110052.desrepop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RemoveCounter(tp,1,0,0x10,1,REASON_EFFECT+REASON_REPLACE)
end
