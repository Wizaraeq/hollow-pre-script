--粛声の祈り手ロー
function c101203019.initial_effect(c)
	--ritual level
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_RITUAL_LEVEL)
	e0:SetValue(c101203019.rlevel)
	c:RegisterEffect(e0)
	--Place
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101203019,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,101203019)
	e1:SetTarget(c101203019.pltg)
	e1:SetOperation(c101203019.plop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--Special Summon this card
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(101203019,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY,EFFECT_FLAG2_CHECK_SIMULTANEOUS)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,101203019+100)
	e3:SetCondition(c101203019.spcon)
	e3:SetTarget(c101203019.sptg)
	e3:SetOperation(c101203019.spop)
	c:RegisterEffect(e3)
end
function c101203019.rlevel(e,c)
	local lv=aux.GetCappedLevel(e:GetHandler())
	if (c:IsAttribute(ATTRIBUTE_LIGHT) and (c:IsRace(RACE_DRAGON) or c:IsRace(RACE_WARRIOR))) then
		local clv=c:GetLevel()
		return (lv<<16)+clv
	else return lv end
end
function c101203019.plfilter(c,tp)
	return c:IsSetCard(0x2a6) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsType(TYPE_CONTINUOUS) and not c:IsForbidden() and c:CheckUniqueOnField(tp)
end
function c101203019.pltg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c101203019.plfilter,tp,LOCATION_DECK,0,1,nil,tp) end
end
function c101203019.plop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=Duel.SelectMatchingCard(tp,c101203019.plfilter,tp,LOCATION_DECK,0,1,1,nil,tp):GetFirst()
	if tc then
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
function c101203019.cfilter(c,tp)
	return c:IsType(TYPE_RITUAL) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsRace(RACE_WARRIOR+RACE_DRAGON) and c:IsFaceup()
		and c:IsControler(tp)
end
function c101203019.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c101203019.cfilter,1,nil,tp)
end
function c101203019.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,tp,0)
end
function c101203019.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end