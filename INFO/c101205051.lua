--星界樹イルミスティル
local s,id,o=GetID()
function s.initial_effect(c)
	c:SetUniqueOnField(1,0,id)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),3)
	c:EnableReviveLimit()
	--Gain LP equal to the ATK of a monster(s) Special Summoned by your opponent
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(s.lpgaincon)
	e1:SetOperation(s.lpgainop)
	c:RegisterEffect(e1)
	--sp_summon effect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(s.regcon)
	e2:SetOperation(s.regop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EVENT_CHAIN_SOLVED)
	e3:SetRange(LOCATION_MZONE)
	e3:SetLabelObject(e2)
	e3:SetCondition(s.lpgaincon2)
	e3:SetOperation(s.lpgainop2)
	c:RegisterEffect(e3)
	--Make this card gain ATK based on how much LP you pay
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,0))
	e4:SetCategory(CATEGORY_ATKCHANGE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetHintTiming(TIMING_DAMAGE_STEP,TIMING_DAMAGE_STEP+TIMINGS_CHECK_MONSTER)
	e4:SetCountLimit(1)
	e4:SetCondition(aux.dscon)
	e4:SetCost(s.atkcost)
	e4:SetOperation(s.atkop)
	c:RegisterEffect(e4)
end
function s.cfilter(c,tp)
	return c:IsSummonPlayer(1-tp)
end
function s.lpgaincon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return eg:IsExists(s.cfilter,1,e:GetHandler(),tp)
		and (ph==PHASE_MAIN1 or ph==PHASE_MAIN2 or (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE))
		and (not re:IsHasType(EFFECT_TYPE_ACTIONS) or re:IsHasType(EFFECT_TYPE_CONTINUOUS))
end
function s.lpgainop(e,tp,eg,ep,ev,re,r,rp)
	local lg=eg:Filter(s.cfilter,e:GetHandler(),tp)
	local rnum=lg:GetSum(Card.GetAttack)
	if Duel.Recover(tp,rnum,REASON_EFFECT)<1 then return end
end
function s.regcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return eg:IsExists(s.cfilter,1,nil,tp)
		and (ph==PHASE_MAIN1 or ph==PHASE_MAIN2 or (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE))
		and re:IsHasType(EFFECT_TYPE_ACTIONS) and not re:IsHasType(EFFECT_TYPE_CONTINUOUS)
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	local lg=eg:Filter(s.cfilter,e:GetHandler(),tp)
	local g=e:GetLabelObject()
	if g==nil or #g==0 then
		lg:KeepAlive()
		e:SetLabelObject(lg)
	else
		g:Merge(lg)
	end
	Duel.RegisterFlagEffect(tp,id,RESET_CHAIN,0,1)
end
function s.lpgaincon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,id)>0
end
function s.lpgainop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.ResetFlagEffect(tp,id)
	local lg=e:GetLabelObject():GetLabelObject()
	lg=lg:Filter(Card.IsLocation,nil,LOCATION_MZONE)
	local rnum=lg:GetSum(Card.GetAttack)
	local g=Group.CreateGroup()
	g:KeepAlive()
	e:GetLabelObject():SetLabelObject(g)
	lg:DeleteGroup()
	if Duel.Recover(tp,rnum,REASON_EFFECT)<1 then return end
end
function s.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000,true) end
	local lp=Duel.GetLP(tp)
	local m=math.floor(math.min(lp,3000)/1000)
	local t={}
	for i=1,m do
		t[i]=i*1000
	end
	local ac=Duel.AnnounceNumber(tp,table.unpack(t))
	Duel.PayLPCost(tp,ac,true)
	e:SetLabel(ac)
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		--Gains ATK equal to the amount of LP you paid
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(e:GetLabel())
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end