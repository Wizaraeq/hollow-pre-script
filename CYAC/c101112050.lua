--Ｓ－Ｆｏｒｃｅ ナイトチェイサー
function c101112050.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,c101112050.matfilter,1,1)
	c:EnableReviveLimit()
	--Limit attack target selection
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetRange(LOCATION_MZONE)
	e0:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e0:SetValue(c101112050.atlimit)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetLabelObject(e0)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetTarget(c101112050.atktg)
	c:RegisterEffect(e1)
	--to deck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101112050,0))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(TIMING_MAIN_END,TIMING_MAIN_END)
	e2:SetCountLimit(1,101112050)
	e2:SetCondition(c101112050.tdcon)
	e2:SetTarget(c101112050.tdtg)
	e2:SetOperation(c101112050.tdop)
	c:RegisterEffect(e2)
end
function c101112050.matfilter(c)
	return c:IsLinkSetCard(0x156) and not c:IsLinkType(TYPE_LINK)
end
function c101112050.atlimit(e,c)
	return e:GetHandler():GetColumnGroup():IsContains(c)
end
function c101112050.atkfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x156) and c:IsLocation(LOCATION_MZONE) and c:IsControler(tp)
end
function c101112050.atktg(e,c)
	local cg=c:GetColumnGroup()
	return cg:IsExists(c101112050.atkfilter,1,nil,e:GetHandlerPlayer())
end
function c101112050.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c101112050.tdfilter(c)
	return c:IsSetCard(0x156) and c:IsFaceup() and c:IsAbleToDeck()
end
function c101112050.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c101112050.tdfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101112050.tdfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c101112050.tdfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c101112050.spfilter(c,e,tp)
	return c:IsSetCard(0x156) and c:IsFaceup() and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101112050.tdop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoDeck(tc,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)>0
		and tc:IsLocation(LOCATION_DECK+LOCATION_EXTRA) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c101112050.spfilter,tp,LOCATION_REMOVED,0,1,nil,e,tp)
		and Duel.SelectYesNo(tp,aux.Stringid(101112050,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,c101112050.spfilter,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
		if #sg>0 then
			Duel.BreakEffect()
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end