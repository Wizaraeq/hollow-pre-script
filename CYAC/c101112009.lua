--アルギロスの落胤
function c101112009.initial_effect(c)
	--Special Summon procedure (your field)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101112009,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND)
	e1:SetTargetRange(POS_FACEUP,0)
	e1:SetCountLimit(1,101112009+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c101112009.spcon1)
	c:RegisterEffect(e1)
	--Special Summon procedure (your opponent's field)
	local e2=e1:Clone()
	e2:SetDescription(aux.Stringid(101112009,1))
	e2:SetTargetRange(POS_FACEUP,1)
	e2:SetCondition(c101112009.spcon2)
	c:RegisterEffect(e2)
	--Neither player can activate the effects of Link Monsters that point to this card
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(1,1)
	e3:SetValue(c101112009.aclimit)
	c:RegisterEffect(e3)
	--Detach materials from an Xyz monster
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(101112009,2))
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,101112009+100)
	e4:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e4:SetCondition(c101112009.detchcon)
	e4:SetTarget(c101112009.detchtg)
	e4:SetOperation(c101112009.detchop)
	c:RegisterEffect(e4)
end
function c101112009.spconfilter(c)
	return c:IsFaceup() and (c:IsLevel(2) or c:IsRank(2) or c:IsLink(2))
end
function c101112009.spcon1(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(e:GetHandlerPlayer(),LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c101112009.spconfilter,0,LOCATION_MZONE,LOCATION_MZONE,1,nil)
end
function c101112009.spcon2(e,c)
	if c==nil then return true end
	local tp=e:GetHandlerPlayer()
	return Duel.GetLocationCount(1-tp,LOCATION_MZONE,tp)>0
		and Duel.IsExistingMatchingCard(c101112009.spconfilter,0,LOCATION_MZONE,LOCATION_MZONE,1,nil)
end
function c101112009.aclimit(e,re,tp)
	return re:GetHandler():GetLinkedGroup():IsContains(e:GetHandler())
end
function c101112009.cfilter(c,tp)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:CheckRemoveOverlayCard(tp,1,REASON_EFFECT)
end
function c101112009.detchcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c101112009.detchtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c101112009.cfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c101112009.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c101112009.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,tp)
end
function c101112009.detchop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		tc:RemoveOverlayCard(tp,1,2,REASON_EFFECT)
	end
end