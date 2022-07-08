--決戦のゴルゴンダ
function c101110054.initial_effect(c)
	aux.AddCodeList(c,68468459)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Change name
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_CHANGE_CODE)
	e2:SetRange(LOCATION_SZONE+LOCATION_GRAVE)
	e2:SetValue(60884672)
	c:RegisterEffect(e2)
	--Destruction replacement
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c101110054.reptg)
	e3:SetValue(c101110054.repval)
	c:RegisterEffect(e3)
	--Special Summon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(101110054,0))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1,101110054)
	e4:SetCondition(c101110054.spcond)
	e4:SetTarget(c101110054.sptg)
	e4:SetOperation(c101110054.spop)
	c:RegisterEffect(e4)
end
function c101110054.repfilter(c,tp)
	return c:IsLocation(LOCATION_ONFIELD) and c:IsControler(tp) and c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
end
function c101110054.tgfilter(c)
	return c:IsType(TYPE_FUSION) and aux.IsMaterialListCode(c,68468459) and c:IsAbleToGrave()
end
function c101110054.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c101110054.repfilter,1,nil,tp)
		and Duel.IsExistingMatchingCard(c101110054.tgfilter,tp,LOCATION_EXTRA,0,1,nil) end
	if Duel.SelectEffectYesNo(tp,e:GetHandler(),96) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg=Duel.SelectMatchingCard(tp,c101110054.tgfilter,tp,LOCATION_EXTRA,0,1,1,nil)
		Duel.Hint(HINT_CARD,0,101110054)
		Duel.SendtoGrave(sg,REASON_EFFECT+REASON_REPLACE)
		return true
	else return false end
end
function c101110054.repval(e,c)
	return c101110054.repfilter(c,e:GetHandlerPlayer())
end
function c101110054.cfilter(c)
	return c:IsFaceup() and c:IsCode(68468459)
end
function c101110054.spcond(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c101110054.cfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil)
end
function c101110054.spfilter(c,e,tp)
	return c:IsSetCard(0x155) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101110054.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and 
		Duel.IsExistingMatchingCard(c101110054.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c101110054.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c101110054.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
