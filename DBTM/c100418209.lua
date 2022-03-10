--ヴァリアンツの聚－幻中
--
--Script by Trishula9
function c100418209.initial_effect(c)
	--fusion summon
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c100418209.ffilter,3,true)
	--pendulum summon
	aux.EnablePendulumAttribute(c,false)
	--pzone effect
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,100418209)
	e1:SetTarget(c100418209.ptg)
	e1:SetOperation(c100418209.pop)
	c:RegisterEffect(e1)
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,100418209+100)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e2:SetCondition(c100418209.stcon)
	e2:SetTarget(c100418209.sttg)
	e2:SetOperation(c100418209.stop)
	c:RegisterEffect(e2)
	--pendulum
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCondition(c100418209.pencon)
	e3:SetTarget(c100418209.pentg)
	e3:SetOperation(c100418209.penop)
	c:RegisterEffect(e3)
end
function c100418209.ffilter(c,fc,sub,mg,sg)
	return c:IsFusionSetCard(0x27c)
end
function c100418209.pfilter(c)
	local seq=c:GetSequence()
	local tp=c:GetControler()
	if seq>4 then return false end
	return (seq>0 and Duel.CheckLocation(tp,LOCATION_MZONE,seq-1))
		or (seq<4 and Duel.CheckLocation(tp,LOCATION_MZONE,seq+1))
end
function c100418209.ptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local zone=1<<c:GetSequence()
	local b1=c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone)
	local b2=Duel.IsExistingMatchingCard(c100418209.pfilter,tp,LOCATION_MZONE,0,1,nil)
	if chk==0 then return b1 or b2 end
	local s=0
	if b1 and not b2 then
		s=Duel.SelectOption(tp,aux.Stringid(100418209,0))
	end
	if not b1 and b2 then
		s=Duel.SelectOption(tp,aux.Stringid(100418209,1))+1
	end
	if b1 and b2 then
		s=Duel.SelectOption(tp,aux.Stringid(100418209,0),aux.Stringid(100418209,1))
	end
	e:SetLabel(s)
	if s==0 then
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	end
end
function c100418209.pop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local zone=1<<c:GetSequence()
	if e:GetLabel()==0 then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP,zone)
	end
	if e:GetLabel()==1 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(100418209,2))
		local sc=Duel.SelectMatchingCard(tp,c100418209.pfilter,tp,LOCATION_MZONE,0,1,1,nil):GetFirst()
		if sc then
			local seq=sc:GetSequence()
			if seq>4 then return end
			local flag=0
			if seq>0 and Duel.CheckLocation(tp,LOCATION_MZONE,seq-1) then flag=flag|(1<<(seq-1)) end
			if seq<4 and Duel.CheckLocation(tp,LOCATION_MZONE,seq+1) then flag=flag|(1<<(seq+1)) end
			if flag==0 then return end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
			local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,~flag)
			local nseq=math.log(s,2)
			Duel.MoveSequence(sc,nseq)
		end
	end
end
function c100418209.stcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c100418209.stfilter(c)
	local seq=c:GetSequence()
	return seq<=4 and c:IsType(TYPE_EFFECT) and c:IsFaceup()
end
function c100418209.sttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c100418209.stfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c100418209.stfilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(100418209,3))
	Duel.SelectTarget(tp,c100418209.stfilter,tp,0,LOCATION_MZONE,1,1,nil)
end
function c100418209.stop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not (tc:IsRelateToEffect(e) and tc:IsControler(1-tp) and not tc:IsImmuneToEffect(e)) then return end
	local zone=1<<tc:GetSequence()
	local oc=Duel.GetMatchingGroup(c100418209.seqfilter,tp,0,LOCATION_SZONE,nil,tc:GetSequence()):GetFirst()
	if oc and Duel.Destroy(oc,REASON_EFFECT)>0 and oc:IsType(TYPE_MONSTER) then
		Duel.SetLP(1-tp,Duel.GetLP(1-tp)-oc:GetAttack())
	end
	if Duel.MoveToField(tc,tp,1-tp,LOCATION_SZONE,POS_FACEUP,true,zone) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
		tc:RegisterEffect(e1)
	end
end
function c100418209.seqfilter(c,seq)
	return c:GetSequence()==seq
end
function c100418209.pencon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_SPECIAL) and rp==1-tp and c:IsReason(REASON_EFFECT)
		and c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup()
end
function c100418209.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function c100418209.penop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end