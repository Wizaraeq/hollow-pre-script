--春化精の暦替
--
--Script by Trishula9
function c101109074.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,101109074)
	e1:SetTarget(c101109074.target)
	e1:SetOperation(c101109074.activate)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCountLimit(1,101109074+100)
	e2:SetCondition(c101109074.spcon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c101109074.sptg)
	e2:SetOperation(c101109074.spop)
	c:RegisterEffect(e2)
end
function c101109074.filter(c,e,tp)
	return c:IsSetCard(0x281) and c:IsType(TYPE_MONSTER)
		and (c:IsAbleToHand() or (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)))
end
function c101109074.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c101109074.filter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c101109074.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c101109074.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c101109074.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if aux.NecroValleyNegateCheck(tc) then return end
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false)
			and (not tc:IsAbleToHand() or Duel.SelectOption(tp,1190,1152)==1) then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		else
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
		end
	end
end
function c101109074.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp and Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)==0 and aux.exccon(e,tp,eg,ep,ev,re,r,rp)
end
function c101109074.spfilter(c,e,tp)
	return c:IsSetCard(0x281) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101109074.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c101109074.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c101109074.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c101109074.spfilter),tp,LOCATION_GRAVE,0,nil,e,tp)
	if ft<=0 or g:GetCount()==0 then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	local ct=math.min(g:GetClassCount(Card.GetCode),ft)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:SelectSubGroup(tp,aux.dncheck,false,ct,ct)
	local tc=sg:GetFirst()
	while tc do
		if Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
			local fid=e:GetHandler():GetFieldID()
			tc:RegisterFlagEffect(101109074,RESET_EVENT+RESETS_STANDARD,0,1,fid)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
			e1:SetCode(EVENT_PHASE+PHASE_END)
			e1:SetCountLimit(1)
			e1:SetLabel(fid)
			e1:SetLabelObject(tc)
			e1:SetCondition(c101109074.tdcon)
			e1:SetOperation(c101109074.tdop)
			Duel.RegisterEffect(e1,tp)
			tc:CompleteProcedure()
		end
		Duel.SpecialSummonComplete()
		tc=sg:GetNext()
	end
end
function c101109074.tdcon(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetTurnPlayer()~=tp then return false end
	local tc=e:GetLabelObject()
	if tc:GetFlagEffectLabel(101109074)==e:GetLabel() then
		return true
	else
		e:Reset()
		return false
	end
end
function c101109074.tdop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.SendtoHand(tc,nil,REASON_EFFECT)
end