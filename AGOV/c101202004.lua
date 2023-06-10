--ヴィサス＝サンサーラ
function c101202004.initial_effect(c)
	--change name
	aux.EnableChangeCode(c,56099748,LOCATION_MZONE+LOCATION_GRAVE)
	--Special summon itself from the hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101202004,0))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,101202004+100)
	e2:SetTarget(c101202004.sptg)
	e2:SetOperation(c101202004.spop)
	c:RegisterEffect(e2)
	--Can be treated as a non-tuner for a Synchro Summon
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_NONTUNER)
	c:RegisterEffect(e3)
end
function c101202004.visasfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x198) and c:IsAbleToDeck() and Duel.GetMZoneCount(tp,c,tp)>0
end
function c101202004.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(loc) and c101202004.visasfilter(chkc,tp)end
	local c=e:GetHandler()
	if chk==0 then return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingTarget(c101202004.visasfilter,tp,LOCATION_MZONE+LOCATION_REMOVED+LOCATION_GRAVE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c101202004.visasfilter,tp,LOCATION_MZONE+LOCATION_REMOVED+LOCATION_GRAVE,0,1,99,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,#g,tp,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c101202004.spop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetTargetsRelateToChain()
	if Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)>0 then
		local og=Duel.GetOperatedGroup()
		local c=e:GetHandler()
		if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 and #og>0 then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(og:GetClassCount(Card.GetCode)*400)
			c:RegisterEffect(e1)
		end
	end
end