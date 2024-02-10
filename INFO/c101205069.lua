--黒魔術のバリア －ミラーフォース－
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,46986414,101204051)
	--Activate (on attack)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCondition(s.condition1)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--Activate (on effect)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetCondition(s.condition2)
	e2:SetTarget(s.target)
	e2:SetOperation(s.activate)
	c:RegisterEffect(e2)
end
function s.cfilter1(c)
	return c:IsFaceup() and aux.IsCodeListed(c,101204051)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.cfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
end
function s.condition1(e,tp,eg,ep,ev,re,r,rp)
	return s.condition(e,tp,eg,ep,ev,re,r,rp) and Duel.GetAttacker():IsControler(1-tp)
end
function s.cfilter(c)
	return c:IsOnField() and c:IsType(TYPE_MONSTER)
end
function s.condition2(e,tp,eg,ep,ev,re,r,rp)
	if e==re or not Duel.IsChainNegatable(ev) then return false end
	local ex,tg,tc=Duel.GetOperationInfo(ev,CATEGORY_DESTROY)
	return rp==1-tp and ex and tg~=nil and s.condition(e,tp,eg,ep,ev,re,r,rp) and tc+tg:FilterCount(s.cfilter,nil)-#tg>0
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsAttackPos,tp,0,LOCATION_MZONE,nil)
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
end
function s.cfilter2(c)
	return c:IsFaceup() and c:IsCode(46986414)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(s.tg)
	e1:SetValue(s.indct)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local g=Duel.GetMatchingGroup(Card.IsAttackPos,tp,0,LOCATION_MZONE,nil)
	local ct=Duel.Destroy(g,REASON_EFFECT)
	if ct>0 and Duel.IsExistingMatchingCard(s.cfilter2,tp,LOCATION_MZONE,0,1,nil) then
		Duel.BreakEffect()
		Duel.Damage(1-tp,ct*500,REASON_EFFECT)
	end
end
function s.tg(e,c)
	return aux.IsCodeListed(c,101204051)
end
function s.indct(e,re,r,rp)
	if bit.band(r,REASON_BATTLE+REASON_EFFECT)~=0 then
		return 1
	else return 0 end
end