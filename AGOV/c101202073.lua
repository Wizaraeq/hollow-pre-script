--世壊輪廻
function c101202073.initial_effect(c)
	aux.AddCodeList(c,56099748)
	--Special Summon 1 "Heart" monster with 3000 ATK
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101202073,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetCountLimit(1,101202073)
	e1:SetCost(c101202073.spcost)
	e1:SetTarget(c101202073.sptg)
	e1:SetOperation(c101202073.spop)
	c:RegisterEffect(e1)
	--Add it to the hand if the opponent Special Summons from the Extra Deck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101202073,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,101202073+100)
	e2:SetCondition(c101202073.thcon)
	e2:SetTarget(c101202073.thtg)
	e2:SetOperation(c101202073.thop)
	c:RegisterEffect(e2)
end
function c101202073.spcostfilter(c,e,tp)
	return c:IsFaceup() and c:IsCode(56099748) and c:IsAbleToRemoveAsCost()
		and Duel.IsExistingMatchingCard(c101202073.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,c)
end
function c101202073.spfilter(c,e,tp,rmvc)
	return c:IsSetCard(0x29b) and c:IsAttack(3000) and Duel.GetLocationCountFromEx(tp,tp,rmvc,c)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c101202073.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c101202073.spcostfilter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c101202073.spcostfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	if Duel.Remove(g,0,REASON_COST+REASON_TEMPORARY)~=0 then
		local rc=g:GetFirst()
		if rc:IsType(TYPE_TOKEN) then return end
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(101202073,2))
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetLabelObject(rc)
		e1:SetCountLimit(1)
		e1:SetOperation(c101202073.retop)
		Duel.RegisterEffect(e1,tp)
	end
end
function c101202073.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetLabelObject())
end
function c101202073.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c101202073.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,c101202073.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp):GetFirst()
	if tc and Duel.SpecialSummonStep(tc,0,tp,tp,true,false,POS_FACEUP) then
		local fid=c:GetFieldID()
		tc:RegisterFlagEffect(101202073,RESET_EVENT+RESETS_STANDARD,0,1,fid)
		--Can only activate its effects once
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAIN_SOLVED)
		e1:SetCondition(c101202073.limactcon)
		e1:SetOperation(c101202073.limactop)
		e1:SetLabelObject(tc)
		Duel.RegisterEffect(e1,tp)
		--Banish it during the End Phase
		local e2=Effect.CreateEffect(c)
		e2:SetDescription(aux.Stringid(101202073,3)) --"Banish the summoned monster"
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_PHASE+PHASE_END)
		e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e2:SetCountLimit(1)
		e2:SetLabel(fid)
		e2:SetLabelObject(tc)
		e2:SetCondition(c101202073.rmcon)
		e2:SetOperation(c101202073.rmop)
		Duel.RegisterEffect(e2,tp)
		Duel.SpecialSummonComplete()
	end
end
function c101202073.limactcon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler()==e:GetLabelObject()
end
function c101202073.limactop(e,tp,eg,ep,ev,re,r,rp)
	--Cannot activate its effects
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_TRIGGER)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e:GetLabelObject():RegisterEffect(e1)
	e:Reset()
end
function c101202073.rmcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffectLabel(101202073)~=e:GetLabel() then
		e:Reset()
		return false
	else
		return true
	end
end
function c101202073.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.Remove(tc,POS_FACEDOWN,REASON_EFFECT)
end
function c101202073.cfilter(c,tp)
	return c:IsSummonLocation(LOCATION_EXTRA) and c:IsSummonPlayer(1-tp)
end
function c101202073.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c101202073.cfilter,1,nil,tp)
end
function c101202073.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,tp,0)
end
function c101202073.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,c)
	end
end