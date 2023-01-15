--愉怪な燐のきつねびゆらら
function c101112028.initial_effect(c)
	--Change monster's attribute to FIRE
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
	e1:SetValue(ATTRIBUTE_FIRE)
	c:RegisterEffect(e1)
	--Special Summon itself from GY
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101112028,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,101112028)
	e2:SetCondition(c101112028.spcon)
	e2:SetTarget(c101112028.sptg)
	e2:SetOperation(c101112028.spop)
	c:RegisterEffect(e2)
end
function c101112028.cfilter(c)
	return c:IsAttribute(ATTRIBUTE_FIRE) and (c:IsFaceup() or not c:IsOnField())
end
function c101112028.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c101112028.cfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil)
end
function c101112028.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c101112028.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
