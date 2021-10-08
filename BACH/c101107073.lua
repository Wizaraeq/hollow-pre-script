--ダイノルフィア・リヴァージョン
function c101107073.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101107073,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,101107073,EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c101107073.condition)
	e1:SetCost(c101107073.cost)
	e1:SetTarget(c101107073.target)
	c:RegisterEffect(e1)
	local e1a=e1:Clone()
	e1a:SetCode(EVENT_SUMMON)
	c:RegisterEffect(e1a)
	local e1b=e1:Clone()
	e1b:SetCode(EVENT_FLIP_SUMMON)
	c:RegisterEffect(e1b)
	local e1c=e1:Clone()
	e1c:SetCode(EVENT_SPSUMMON)
	c:RegisterEffect(e1c)
	--No battle damage
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101107073,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c101107073.nodamcon)
	e2:SetCost(aux.bfgcost)
	e2:SetOperation(c101107073.nodamop)
	c:RegisterEffect(e2)
end
function c101107073.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x273) and c:IsType(TYPE_FUSION)
end
function c101107073.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c101107073.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c101107073.effilter(c)
	return c:IsAbleToRemoveAsCost() and c:IsType(TYPE_COUNTER)
		and c:CheckActivateEffect(c101107073.summonnegcheck(),true,false)~=nil
		and c:CheckActivateEffect(c101107073.summonnegcheck(),true,false):GetOperation()~=nil
end
function c101107073.summonnegcheck()
	return Duel.CheckEvent(EVENT_SUMMON)
		or Duel.CheckEvent(EVENT_FLIP_SUMMON)
		or Duel.CheckEvent(EVENT_SPSUMMON)
end
function c101107073.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101107073.effilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.PayLPCost(tp,Duel.GetLP(tp)//2)
end
function c101107073.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		local te=e:GetLabelObject()
		if not te then return end
		local tg=te:GetTarget()
		return tg and tg(e,tp,eg,ep,ev,re,r,rp,0,chkc)
	end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c101107073.effilter,tp,LOCATION_GRAVE,0,1,1,nil)
	if Duel.Remove(g,POS_FACEUP,REASON_COST)==0 then return end
	local te,ceg,cep,cev,cre,cr,crp=g:GetFirst():CheckActivateEffect(c101107073.summonnegcheck(),true,true)
	e:SetLabel(te:GetLabel())
	e:SetLabelObject(te:GetLabelObject())
	local tg=te:GetTarget()
	if tg then tg(e,tp,ceg,cep,cev,cre,cr,crp,1) end
	te:SetLabel(e:GetLabel())
	te:SetLabelObject(e:GetLabelObject())
	e:SetLabelObject(te)
	Duel.ClearOperationInfo(0)
	e:SetOperation(c101107073.activate)
end
function c101107073.activate(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	if not te then return end
	e:SetLabel(te:GetLabel())
	e:SetLabelObject(te:GetLabelObject())
	local op=te:GetOperation()
	if op then op(e,tp,eg,ep,ev,re,r,rp) end
	te:SetLabel(e:GetLabel())
	te:SetLabelObject(e:GetLabelObject())
	e:SetOperation(nil)
end
function c101107073.nodamcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLP(tp)<=2000 and Duel.GetBattleDamage(tp)>0
end
function c101107073.nodamop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
	Duel.RegisterEffect(e1,tp)
end