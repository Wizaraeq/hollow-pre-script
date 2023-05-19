--ヴォルカニック・エミッション
function c100428023.initial_effect(c)
	--Activate 1 of these effects
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100428023,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_BATTLE_START+TIMINGS_CHECK_MONSTER)
	e1:SetTarget(c100428023.efftg)
	e1:SetOperation(c100428023.effop)
	c:RegisterEffect(e1)
end
function c100428023.thspfilter(c,e,tp,ft)
	return c:IsSetCard(0x32) and c:IsType(TYPE_MONSTER) and (c:IsAbleToHand() or (ft>0 and c:IsCanBeSpecialSummoned(e,0,tp,true,false)))
end
function c100428023.damfilter(c)
	return c:IsRace(RACE_PYRO) and c:IsFaceup() and c:GetBaseAttack()>0
end
function c100428023.efftg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c100428023.damfilter(chkc) end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local b1=Duel.IsExistingMatchingCard(c100428023.thspfilter,tp,LOCATION_DECK,0,1,nil,e,tp,ft) and  Duel.GetFlagEffect(tp,100428023)==0
	local b2=Duel.IsExistingTarget(c100428023.damfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) and Duel.GetFlagEffect(tp,100428023+100)==0
	if chk==0 then return b1 or b2 end
	local op=aux.SelectFromOptions(tp,
		{b1,aux.Stringid(100428023,0)},
		{b2,aux.Stringid(100428023,1)})
	e:SetLabel(op)
	if op==1 then
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON)
		e:SetProperty(0)
		Duel.RegisterFlagEffect(tp,100428023,RESET_PHASE+PHASE_END,0,1)
	elseif op==2 then
		e:SetCategory(CATEGORY_DAMAGE)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		local tc=Duel.SelectTarget(tp,c100428023.damfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil):GetFirst()
		local dam=tc:GetBaseAttack()
		local ctrl=tc:GetControler()
		if ctrl==tp then dam=dam//2 end
		Duel.SetTargetParam(ctrl)
		Duel.RegisterFlagEffect(tp,100428023+100,RESET_PHASE+PHASE_END,0,1)
		Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam)
	end
end
function c100428023.effop(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	if op==1 then
		--Search or Special Summon 1 "Volcanic" monster from your Deck
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
		local g=Duel.SelectMatchingCard(tp,c100428023.thspfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,ft)
		local tc=g:GetFirst()
		if tc then
			if ft>0 and tc:IsCanBeSpecialSummoned(e,0,tp,true,false)
				and (not tc:IsAbleToHand() or Duel.SelectOption(tp,1190,1152)==1) then
				Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP_DEFENSE)
				local fid=e:GetHandler():GetFieldID()
				tc:RegisterFlagEffect(100428023+200,RESET_EVENT+RESETS_STANDARD,0,1,fid)
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				e1:SetCode(EVENT_PHASE+PHASE_END)
				e1:SetCountLimit(1)
				e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
				e1:SetLabel(fid)
				e1:SetLabelObject(tc)
				e1:SetCondition(c100428023.thcon)
				e1:SetOperation(c100428023.thop)
				Duel.RegisterEffect(e1,tp)
			else
				Duel.SendtoHand(tc,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,tc)
			end
		end
	elseif op==2 then
		--Inflict damage to your opponent
		local tc=Duel.GetFirstTarget()
		if not tc:IsRelateToEffect(e) or tc:IsFacedown() then return end
		local dam=tc:GetBaseAttack()
		local ctrl=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
		if ctrl==tp then dam=dam//2 end
		Duel.Damage(1-tp,dam,REASON_EFFECT)
	end
end
function c100428023.thcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffectLabel(100428023+200)~=e:GetLabel() then
		e:Reset()
		return false
	else return true end
end
function c100428023.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoHand(e:GetLabelObject(),nil,REASON_EFFECT)
end
