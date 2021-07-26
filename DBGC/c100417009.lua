--Ga－P.U.N.K.ワイルド・ピッキング
--
--Script by REIKAI
function c100417009.initial_effect(c)
	--ACT
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100417009,0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_START)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,100417009)
	e2:SetCondition(c100417009.descon2)
	e2:SetTarget(c100417009.destg2)
	e2:SetOperation(c100417009.desop2)
	c:RegisterEffect(e2)
	--Cannot Break
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(100417009,1))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetCondition(c100417009.limcon)
	e3:SetOperation(c100417009.limop)
	c:RegisterEffect(e3)
end
function c100417009.descon2(e,tp,eg,ep,ev,re,r,rp)
	local a,at=Duel.GetAttacker(),Duel.GetAttackTarget()
	if a:IsControler(1-tp) then a,at=at,a end
	return a and at and a:IsSetCard(0x26f) and a:IsFaceup() and at:IsControler(1-tp)
end
function c100417009.destg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local a,at=Duel.GetAttacker(),Duel.GetAttackTarget()
	if a:IsControler(1-tp) then a,at=at,a end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,at,1,1-tp,LOCATION_MZONE)
end
function c100417009.desop2(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local a,at=Duel.GetAttacker(),Duel.GetAttackTarget()
	if a:IsControler(1-tp) then a,at=at,a end
	if at and at:IsRelateToBattle() and at:IsControler(1-tp) then
		Duel.Destroy(at,REASON_EFFECT)
	end
end
function c100417009.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x26f)
end
function c100417009.limcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return rp==1-tp and c:IsReason(REASON_EFFECT) and c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_SZONE)
		and Duel.GetMatchingGroupCount(c100417009.cfilter,tp,LOCATION_MZONE,0,nil)>0
end
function c100417009.limop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c100417009.cfilter,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
			e1:SetValue(1)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end