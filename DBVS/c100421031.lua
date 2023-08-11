--天使の聲
function c100421031.initial_effect(c)
	c:EnableCounterPermit(0x16a,LOCATION_PZONE)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--add counter
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_RECOVER)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCondition(c100421031.ctcon)
	e1:SetOperation(c100421031.ctop)
	c:RegisterEffect(e1)
	--link
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c100421031.lkcon)
	e2:SetTarget(c100421031.lktg)
	e2:SetOperation(c100421031.lkop)
	c:RegisterEffect(e2)
	--place in pzone
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(100421031,0))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_HAND)
	e3:SetCountLimit(1,100421031)
	e3:SetCost(c100421031.pzcost)
	e3:SetTarget(c100421031.pztg)
	e3:SetOperation(c100421031.pzop)
	c:RegisterEffect(e3)
	--
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(100421031,1))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,100421031+100)
	e4:SetCondition(c100421031.cpcon)
	e4:SetCost(c100421031.cpcost)
	e4:SetTarget(c100421031.cptg)
	e4:SetOperation(c100421031.cpop)
	c:RegisterEffect(e4)
	if not c100421031.global_check then
		c100421031.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SUMMON_SUCCESS)
		ge1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		ge1:SetLabel(100421031)
		ge1:SetOperation(aux.sumreg)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		ge2:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge2:SetLabel(100421031)
		Duel.RegisterEffect(ge2,0)
	end
end
function c100421031.ctcilter(c,tc)
	return c:GetOriginalRace()==RACE_FIEND
end
function c100421031.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp and Duel.IsExistingMatchingCard(c100421031.ctcilter,tp,LOCATION_PZONE,0,1,nil)
end
function c100421031.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:AddCounter(0x16a,1)
	Duel.RaiseEvent(c,EVENT_CUSTOM+100421035,e,0,tp,tp,1)
end
function c100421031.lkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker():IsControler(1-tp)
end
function c100421031.lkfilter(c)
	return c:IsLinkSummonable(nil)
end
function c100421031.lktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100421031.lkfilter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c100421031.lkop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c100421031.lkfilter,tp,LOCATION_EXTRA,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.LinkSummon(tp,tc,nil)
	end
end
function c100421031.pzcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD,e:GetHandler())
end
function c100421031.pzfilter(c)
	return c:IsCode(100421032) and not c:IsForbidden()
end
function c100421031.pztg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) and Duel.CheckLocation(tp,LOCATION_PZONE,1)
		and Duel.IsExistingMatchingCard(c100421031.pzfilter,tp,LOCATION_DECK,0,1,nil) and not c:IsForbidden() end
end
function c100421031.pzop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) or not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return end
	local tc=Duel.GetFirstMatchingCard(c100421031.pzfilter,tp,LOCATION_DECK,0,nil)
	if not tc then return end
	Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
end
function c100421031.cpcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(100421031)>0
end
function c100421031.cpcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function c100421031.cpfilter(c)
	return c:IsSetCard(0x2a3) and (c:GetType()==TYPE_SPELL or c:GetType()==TYPE_TRAP) and c:IsAbleToRemoveAsCost()
		and c:CheckActivateEffect(false,true,false)
end
function c100421031.cptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()==0 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(c100421031.cpfilter,tp,LOCATION_GRAVE,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local tc=Duel.SelectMatchingCard(tp,c100421031.cpfilter,tp,LOCATION_GRAVE,0,1,1,nil):GetFirst()
	Duel.Remove(tc,POS_FACEUP,REASON_COST)
	e:SetLabelObject(tc)
end
function c100421031.cpop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if not tc then return end
	local eff=tc:GetActivateEffect()
	local op=eff:GetOperation()
	if op then op(e,tp,eg,ep,ev,re,r,rp,1) end
end
