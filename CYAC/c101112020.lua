--星騎士 アルテア
function c101112020.initial_effect(c)
	-- Destroy cards on the field
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101112020,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,101112020)
	e1:SetTarget(c101112020.destg)
	e1:SetOperation(c101112020.desop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	-- Special Summon itself from the GY
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(101112020,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCountLimit(1,101112020+100)
	e4:SetCondition(c101112020.spcon)
	e4:SetTarget(c101112020.sptg)
	e4:SetOperation(c101112020.spop)
	c:RegisterEffect(e4)
	--Activate(summon)
	local e5=e1:Clone()
	e5:SetType(EFFECT_TYPE_ACTIVATE)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetRange(LOCATION_REMOVED)
	c:RegisterEffect(e5)
	c101112020.summon_effect=e1
end
function c101112020.cfilter(c)
	return c:IsType(TYPE_XYZ) and c:IsFaceup() and c:IsAttribute(ATTRIBUTE_LIGHT+ATTRIBUTE_DARK)
end
function c101112020.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() end
	if chk==0 then return Duel.IsExistingMatchingCard(c101112020.cfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingTarget(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local ct=Duel.GetMatchingGroupCount(c101112020.cfilter,tp,LOCATION_MZONE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,ct,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
end
function c101112020.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	if #tg>0 then
		Duel.Destroy(tg,REASON_EFFECT)
	end
end
function c101112020.spcfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x9c,0x53) and c:IsControler(tp) and not c:IsCode(101112020)
end
function c101112020.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c101112020.spcfilter,1,nil,tp)
end
function c101112020.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,tp,0)
end
function c101112020.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c101112020.atktg)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function c101112020.atktg(e,c)
	return not c:IsType(TYPE_XYZ)
end
