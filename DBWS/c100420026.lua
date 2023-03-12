--ＶＳ トリニティ・バースト
function c100420026.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100420026,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_MAIN_END+TIMINGS_CHECK_MONSTER)
	e1:SetCountLimit(1,100420026,EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c100420026.target)
	e1:SetOperation(c100420026.activate)
	c:RegisterEffect(e1)
end
function c100420026.tgfilter(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0x297)
		and Duel.IsExistingMatchingCard(c100420026.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp,c:GetOriginalAttribute())
end
function c100420026.spfilter(c,e,tp,att)
	return c:IsSetCard(0x297) and c:GetOriginalAttribute()~=att
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c100420026.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c100420026.tgfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c100420026.tgfilter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c100420026.tgfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c100420026.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if not tc:IsRelateToEffect(e) or tc:IsFacedown() or ft<=0 then return end
	local g=Duel.GetMatchingGroup(c100420026.spfilter,tp,LOCATION_HAND,0,nil,e,tp,tc:GetOriginalAttribute())
	if #g==0 then return end
	local ct=math.min(2,ft)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ct=1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:SelectSubGroup(tp,aux.dncheck,false,1,ct)
	local og=Group.CreateGroup()
	local fid=c:GetFieldID()
	for sc in aux.Next(sg) do
		Duel.SpecialSummonStep(sc,0,tp,tp,false,false,POS_FACEUP)
		sc:RegisterFlagEffect(100420026,RESET_EVENT+RESETS_STANDARD,0,1,fid)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		sc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		sc:RegisterEffect(e2)
		og:AddCard(sc)
	end
	if Duel.SpecialSummonComplete()==0 then return end
	if #og>0 then
		og:KeepAlive()
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetCode(EVENT_PHASE+PHASE_END)
		e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e3:SetCountLimit(1)
		e3:SetLabel(fid)
		e3:SetLabelObject(og)
		e3:SetCondition(c100420026.rmcon)
		e3:SetOperation(c100420026.rmop)
		Duel.RegisterEffect(e3,tp)
		local thg=Group.CreateGroup()
		for oc in aux.Next(og+tc) do
			thg:Merge(oc:GetColumnGroup():Filter(c100420026.thfilter,nil,1-tp))
		end
		if #thg>0 and Duel.SelectYesNo(tp,aux.Stringid(100420026,1)) then
			Duel.BreakEffect()
			Duel.SendtoHand(thg,nil,REASON_EFFECT)
		end
	end
end
function c100420026.thfilter(c,p)
	return c:IsAbleToHand() and c:IsControler(p)
end
function c100420026.rmfilter(c,fid)
	return c:GetFlagEffectLabel(100420026)==fid
end
function c100420026.rmcon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if not g:IsExists(c100420026.rmfilter,1,nil,e:GetLabel()) then
		g:DeleteGroup()
		e:Reset()
		return false
	else return true end
end
function c100420026.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local tg=g:Filter(c100420026.rmfilter,nil,e:GetLabel())
	Duel.SendtoHand(e:GetLabelObject(),nil,REASON_EFFECT)
end